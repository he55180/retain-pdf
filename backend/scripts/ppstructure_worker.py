"""ppstructure_worker.py
PP-StructureV2 layout analysis + Umi-OCR dual-pipeline fusion Worker.
Replaces v4.5.0 rule-based classification with AI-powered layout detection.

Architecture:
  Path A: Umi-OCR HTTP API -> text blocks with pixel-precise coordinates
  Path B: PPStructure (PaddleOCR) -> semantic layout regions (header/text/figure/...)
  Fusion: for each text block, check if its center falls in a layout region -> assign type
  Post: merge adjacent text blocks into paragraphs (reuse v4.5.0 merge logic)

Output: normalized_document_v1 JSON compatible with translation pipeline.
"""

from __future__ import annotations

import argparse
import base64
import io
import json
import os
import sys
import time
import uuid
from pathlib import Path

import fitz
import numpy as np
from PIL import Image
from paddleocr import PPStructure
import urllib.request

# ── Config ──────────────────────────────────────────────────────────────────
UMI_OCR_HOST = os.environ.get("UMI_OCR_URL", "http://127.0.0.1:1224")
UMI_OCR_API  = f"{UMI_OCR_HOST}/api/ocr"
SKIP_TYPES   = {"header", "footer", "figure", "reference", "page_number"}
DPI           = 150

# ── Global engine (init once per process) ───────────────────────────────────
_layout_engine = None


def _get_engine():
    global _layout_engine
    if _layout_engine is None:
        _layout_engine = PPStructure(table=False, ocr=False, show_log=False)
    return _layout_engine


# ── Path A: Umi-OCR ─────────────────────────────────────────────────────────

def _call_umi_ocr(img: Image.Image, limit_side_len: int = 1500) -> list[dict]:
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    b64 = base64.b64encode(buf.getvalue()).decode()

    payload = json.dumps({
        "base64": b64,
        "options": {
            "ocr.language": "models/config_chinese.txt",
            "ocr.cls": True,
            "ocr.limit_side_len": limit_side_len,
            "tbpu.parser": "multi_para",
            "data.format": "dict",
        },
    }, ensure_ascii=False).encode("utf-8")

    req = urllib.request.Request(
        UMI_OCR_API,
        data=payload,
        headers={"Content-Type": "application/json", "User-Agent": "RetainPDF/1.0"},
    )
    retries = 2
    for attempt in range(retries + 1):
        try:
            resp = urllib.request.urlopen(req, timeout=120)
            data = json.loads(resp.read().decode("utf-8"))
            if data.get("code") == 100:
                return data.get("data", [])
            if data.get("code") == 101:
                return []
            raise RuntimeError(f"Umi-OCR error code={data.get('code')}: {data}")
        except (OSError, urllib.error.URLError) as exc:
            if attempt < retries and _is_connection_error(exc):
                print("[ppstructure] umi-ocr connection lost, retrying...", flush=True)
                time.sleep(2)
                continue
            raise


def _is_connection_error(exc: Exception) -> bool:
    msg = str(exc).lower()
    return any(kw in msg for kw in (
        "refused", "aborted", "reset", "timeout",
        "connecterror", "connectionerror",
    ))


# ── Path B: PPStructure ─────────────────────────────────────────────────────

def _get_layout_regions(pix: fitz.Pixmap) -> list[dict]:
    img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
    arr = np.array(img)
    results = _get_engine()(arr)
    regions = []
    for r in results:
        regions.append({
            "type": r.get("type", "text"),
            "bbox": r.get("bbox", []),
        })
    return regions


# ── Fusion ──────────────────────────────────────────────────────────────────

def _point_in_bbox(cx: float, cy: float, bbox: list[int]) -> bool:
    x1, y1, x2, y2 = bbox
    margin = 10
    return (x1 - margin) <= cx <= (x2 + margin) and (y1 - margin) <= cy <= (y2 + margin)


def _assign_layout(blocks: list[dict], regions: list[dict]) -> list[dict]:
    for block in blocks:
        coords = block.get("box", [])
        if not coords:
            block["layout_type"] = "text"
            block["_ppi_match"] = False
            continue
        xs = [p[0] for p in coords]
        ys = [p[1] for p in coords]
        cx, cy = sum(xs) / len(xs), sum(ys) / len(ys)

        matched = "text"
        for region in regions:
            if _point_in_bbox(cx, cy, region["bbox"]):
                matched = region["type"]
                break
        block["layout_type"] = matched
        block["_ppi_match"] = matched != "text"
    return blocks


# ── Merge (reuse v4.5.0 logic) ──────────────────────────────────────────────

_SENTENCE_END_SET = set("。.!！?？:：；;")


def _merge_blocks(blocks: list[dict]) -> list[dict]:
    if len(blocks) < 2:
        return blocks

    # Sort top-to-bottom, left-to-right
    def sort_key(b):
        coords = b.get("box", [])
        if not coords:
            return (0, 0)
        return (min(p[1] for p in coords), min(p[0] for p in coords))
    blocks = sorted(blocks, key=sort_key)

    merged = [dict(blocks[0])]
    merged[-1]["_merge_count"] = merged[-1].get("_merge_count", 1)

    for b in blocks[1:]:
        prev = merged[-1]
        # Only merge same-type text blocks
        if prev.get("layout_type") != "text" or b.get("layout_type", "text") != "text":
            merged.append(dict(b))
            merged[-1]["_merge_count"] = 1
            continue

        pcoords = prev.get("box", [])
        ncoords = b.get("box", [])
        if not pcoords or not ncoords:
            merged.append(dict(b))
            merged[-1]["_merge_count"] = 1
            continue

        px1, px2 = min(p[0] for p in pcoords), max(p[0] for p in pcoords)
        py1, py2 = min(p[1] for p in pcoords), max(p[1] for p in pcoords)
        nx1, nx2 = min(p[0] for p in ncoords), max(p[0] for p in ncoords)
        ny1, ny2 = min(p[1] for p in ncoords), max(p[1] for p in ncoords)

        pw, nw = px2 - px1, nx2 - nx1
        ph = py2 - py1
        overlap = min(px2, nx2) - max(px1, nx1)
        overlap_ratio = overlap / max(pw, nw, 1) if max(pw, nw) > 0 else 0
        gap = ny1 - py2

        prev_text = (prev.get("text", "") or "").strip()
        ends_sentence = prev_text[-1] in _SENTENCE_END_SET if prev_text else False

        if overlap_ratio > 0.70 and gap < ph * 1.5 and not ends_sentence:
            prev["text"] = prev.get("text", "") + " " + b.get("text", "")
            prev["score"] = max(prev.get("score", 0), b.get("score", 0))
            prev["_merge_count"] = prev.get("_merge_count", 1) + 1
            # Expand bbox
            new_box = [
                [min(px1, nx1), min(py1, ny1)],
                [max(px2, nx2), min(py1, ny1)],
                [max(px2, nx2), max(py2, ny2)],
                [min(px1, nx1), max(py2, ny2)],
            ]
            prev["box"] = new_box
        else:
            merged.append(dict(b))
            merged[-1]["_merge_count"] = 1

    return merged


# ── Build document.v1 ───────────────────────────────────────────────────────

_LAYOUT_ROLE_MAP = {
    "title": "title",
    "text": "paragraph",
    "header": "header",
    "footer": "footer",
    "figure": "paragraph",
    "reference": "paragraph",
    "page_number": "metadata",
    "table": "paragraph",
}


def _build_document_v1(
    pdf_path: Path,
    all_page_blocks: list[list[dict]],
    page_sizes_pt: list[tuple[float, float]],
    dpi: int,
    elapsed: float,
) -> dict:
    scale = 72.0 / float(dpi)
    pages_data = []
    total_blocks = 0

    for page_idx, (page_blocks, (pw, ph)) in enumerate(zip(all_page_blocks, page_sizes_pt)):
        blocks_out = []
        for order, b in enumerate(page_blocks):
            text = (b.get("text", "") or "").strip()
            if not text:
                continue

            coords = b.get("box", [])
            xs = [p[0] for p in coords] if coords else [0, 0, 0, 0]
            ys = [p[1] for p in coords] if coords else [0, 0, 0, 0]
            xmin = min(xs) * scale
            ymin = min(ys) * scale
            xmax = max(xs) * scale
            ymax = max(ys) * scale

            layout_type = b.get("layout_type", "text")
            layout_role = _LAYOUT_ROLE_MAP.get(layout_type, "paragraph")
            translate = layout_type not in SKIP_TYPES

            block = {
                "block_id": str(uuid.uuid4()),
                "page_index": page_idx,
                "order": order,
                "reading_order": order,
                "geometry": {
                    "bbox": [round(xmin, 3), round(ymin, 3), round(xmax, 3), round(ymax, 3)],
                },
                "content": {
                    "kind": "text",
                    "text": text,
                },
                "layout_role": layout_role,
                "semantic_role": "body",
                "structure_role": "body",
                "policy": {
                    "translate": translate,
                    "translate_reason": "main_text" if translate else f"layout={layout_type}",
                },
                "provenance": {
                    "provider": "docling",
                    "raw_label": layout_type,
                    "raw_sub_type": "",
                    "raw_bbox": [round(xmin, 3), round(ymin, 3), round(xmax, 3), round(ymax, 3)],
                    "raw_path": str(pdf_path),
                },
                "continuation_hint": {
                    "source": "",
                    "group_id": "",
                    "role": "",
                    "scope": "",
                    "reading_order": -1,
                    "confidence": float(b.get("score", 0.0)),
                },
                "metadata": {
                    "layout_type": layout_type,
                    "is_merged": (b.get("_merge_count", 1) or 1) > 1,
                    "merge_source_count": b.get("_merge_count", 1) or 1,
                    "ppi_match": b.get("_ppi_match", False),
                },
                "source": {
                    "provider": "docling",
                },
            }
            blocks_out.append(block)
            total_blocks += 1

        pages_data.append({
            "page_index": page_idx,
            "page": page_idx + 1,
            "width": pw,
            "height": ph,
            "unit": "pt",
            "blocks": blocks_out,
        })

    return {
        "schema": "normalized_document_v1",
        "schema_version": "1.1",
        "document_id": str(uuid.uuid4()),
        "source": {},
        "page_count": len(pages_data),
        "pages": pages_data,
        "assets": {},
        "derived": {
            "provider_signals": {
                "provider": "docling",
                "dpi": dpi,
                "engine": "PPStructureV2+Umi-OCR",
                "fusion": "center-point-IoU",
            },
            "stats": {
                "pages": len(pages_data),
                "blocks": total_blocks,
                "elapsed_seconds": round(elapsed, 2),
            },
        },
        "markers": {},
    }


# ── Public API ──────────────────────────────────────────────────────────────

def process_pdf(
    pdf_path: Path,
    output_dir: Path,
    dpi: int = DPI,
    limit_side_len: int = 1500,
) -> dict:
    """Full dual-pipeline: PPStructure layout + Umi-OCR text -> document.v1.json."""
    doc = fitz.open(str(pdf_path))
    page_sizes_pt = [(float(p.rect.width), float(p.rect.height)) for p in doc]

    all_page_blocks = []
    total = len(doc)

    start = time.perf_counter()

    for page_num, page in enumerate(doc):
        print(f"[ppstructure] page {page_num + 1}/{total}", flush=True)

        # Render page at DPI
        mat = fitz.Matrix(dpi / 72, dpi / 72)
        pix = page.get_pixmap(matrix=mat)

        # Path B: PPStructure layout regions
        regions = _get_layout_regions(pix)
        region_summary = ", ".join(
            f"{r['type']}({r['bbox'][0]},{r['bbox'][1]},{r['bbox'][2]},{r['bbox'][3]})"
            for r in regions
        )
        print(f"  layout regions: {len(regions)} [{region_summary}]", flush=True)

        # Path A: Umi-OCR text blocks
        img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
        try:
            raw_blocks = _call_umi_ocr(img, limit_side_len)
        except Exception as exc:
            print(f"  Umi-OCR failed: {exc}", flush=True)
            raw_blocks = []

        # Fusion
        blocks = _assign_layout(raw_blocks, regions)
        blocks = _merge_blocks(blocks)

        translate_count = sum(1 for b in blocks if b.get("layout_type") not in SKIP_TYPES)
        skip_count = len(blocks) - translate_count
        print(f"  blocks={len(blocks)}  translate={translate_count}  skip={skip_count}", flush=True)

        all_page_blocks.append(blocks)

    doc.close()
    elapsed = time.perf_counter() - start

    document = _build_document_v1(pdf_path, all_page_blocks, page_sizes_pt, dpi, elapsed)

    # Write document.v1.json
    doc_v1_path = output_dir / "document.v1.json"
    doc_v1_path.parent.mkdir(parents=True, exist_ok=True)
    with open(doc_v1_path, "w", encoding="utf-8") as f:
        json.dump(document, f, ensure_ascii=False, indent=2)

    # Write layout.json
    unpacked_dir = output_dir / "unpacked"
    unpacked_dir.mkdir(parents=True, exist_ok=True)
    layout_json_path = unpacked_dir / "layout.json"
    with open(layout_json_path, "w", encoding="utf-8") as f:
        json.dump({
            "provider": "docling",
            "document_v1_path": str(doc_v1_path),
            "elapsed_seconds": round(elapsed, 2),
        }, f, ensure_ascii=False)

    block_count = sum(len(p["blocks"]) for p in document["pages"])
    print(
        f"[ppstructure] done  pages={total}  blocks={block_count}  "
        f"time={elapsed:.1f}s  output={doc_v1_path}",
        flush=True,
    )

    return document


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="PPStructure + Umi-OCR worker")
    parser.add_argument("--pdf-path", type=str, required=True, help="Input PDF path")
    parser.add_argument("--output-dir", type=str, required=True, help="Output directory")
    parser.add_argument("--dpi", type=int, default=DPI, help=f"Render DPI (default: {DPI})")
    parser.add_argument("--limit-side-len", type=int, default=1500, help="OCR image side limit")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    pdf_path = Path(args.pdf_path).resolve()
    output_dir = Path(args.output_dir).resolve()

    if not pdf_path.exists():
        print(f"ERROR: PDF not found: {pdf_path}", file=sys.stderr)
        sys.exit(1)

    print(f"ppstructure-worker: pdf={pdf_path}", flush=True)
    print(f"ppstructure-worker: output_dir={output_dir}", flush=True)
    print(f"ppstructure-worker: dpi={args.dpi}", flush=True)

    process_pdf(pdf_path, output_dir, dpi=args.dpi, limit_side_len=args.limit_side_len)


if __name__ == "__main__":
    main()
