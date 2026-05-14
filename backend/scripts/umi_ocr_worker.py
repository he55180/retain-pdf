"""Umi-OCR Worker for RetainPDF.

Renders PDF pages to images and OCRs them via local Umi-OCR HTTP API.
Produces document.v1.json compatible with the translation pipeline.

v4.5.0 adds:
  - Text block merging (adjacent lines → paragraphs)
  - Header/footer ignore regions (tbpu.ignoreArea)
  - Rule-based layout classification (title/subtitle/header/footer/paragraph)

Usage:
    python backend/scripts/umi_ocr_worker.py --pdf-path <path> --output-dir <dir>
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import re
import sys
import time
import uuid
from pathlib import Path

UMI_OCR_HOST = "http://127.0.0.1:1224"
UMI_OCR_TIMEOUT = 120
UMI_OCR_EXE_NAME = "Umi-OCR.exe"
_UMI_PROCESS = None

_SENTENCE_END_RE = re.compile(r"[。.!！?？:：；;]$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Umi-OCR worker")
    parser.add_argument("--pdf-path", type=str, required=True, help="Input PDF path")
    parser.add_argument("--output-dir", type=str, required=True, help="Output directory")
    parser.add_argument("--dpi", type=int, default=200, help="Render DPI (default: 200)")
    parser.add_argument("--limit-side-len", type=int, default=1500,
                        help="OCR image side limit in px (default: 1500)")
    return parser.parse_args()


# ─── Umi-OCR lifecycle ───────────────────────────────────────────────────────

def _find_umi_ocr_exe() -> str | None:
    this_file = Path(__file__).resolve()
    candidates = [
        Path(os.environ.get("RETAIN_PDF_RESOURCES", "")) / "umi-ocr" / UMI_OCR_EXE_NAME,
        this_file.parents[3] / "umi-ocr" / UMI_OCR_EXE_NAME,
        this_file.parents[2] / "umi-ocr" / UMI_OCR_EXE_NAME,
        Path(os.path.expanduser("~")) / "Umi-OCR" / UMI_OCR_EXE_NAME,
    ]
    for p in candidates:
        if p.exists():
            return str(p)
    return None


def _is_connection_error(exc: Exception) -> bool:
    msg = str(exc).lower()
    return any(kw in msg for kw in (
        "connection refused", "connection aborted", "connection reset",
        "timeout", "connecterror", "connectionerror",
        "cannot connect", "no connection",
    ))


def _umi_ocr_alive() -> bool:
    try:
        import urllib.request
        req = urllib.request.Request(
            f"{UMI_OCR_HOST}/api/ocr/get_options",
            headers={"User-Agent": "RetainPDF/1.0"},
        )
        resp = urllib.request.urlopen(req, timeout=4)
        return resp.status == 200
    except Exception:
        return False


def _request_json(url, payload=None, timeout=UMI_OCR_TIMEOUT):
    import urllib.request
    data = None
    if payload is not None:
        data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Content-Type": "application/json",
            "User-Agent": "RetainPDF/1.0",
        },
    )
    resp = urllib.request.urlopen(req, timeout=timeout)
    return json.loads(resp.read().decode("utf-8"))


def ensure_umi_ocr_running() -> None:
    global _UMI_PROCESS
    if _umi_ocr_alive():
        print("[umi-ocr] service already running", flush=True)
        return
    exe_path = _find_umi_ocr_exe()
    if not exe_path:
        raise RuntimeError(
            "Umi-OCR executable not found. "
            "Place Umi-OCR folder under resources/umi-ocr/ near the backend scripts."
        )
    print(f"[umi-ocr] starting: {exe_path}", flush=True)
    import subprocess
    creationflags = 0
    if sys.platform == "win32":
        creationflags = subprocess.CREATE_NO_WINDOW
    _UMI_PROCESS = subprocess.Popen(
        [exe_path],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        creationflags=creationflags,
    )
    deadline = time.perf_counter() + 30
    while time.perf_counter() < deadline:
        time.sleep(1)
        if _umi_ocr_alive():
            print(f"[umi-ocr] service ready ({time.perf_counter() - (deadline - 30):.0f}s)", flush=True)
            return
    raise RuntimeError("Umi-OCR did not start within 30 seconds.")


def _stop_umi_ocr() -> None:
    global _UMI_PROCESS
    if _UMI_PROCESS is not None:
        try:
            _UMI_PROCESS.terminate()
            _UMI_PROCESS.wait(timeout=5)
        except Exception:
            pass
        _UMI_PROCESS = None


# ─── OCR ─────────────────────────────────────────────────────────────────────

def _ocr_page(image_path: str, limit_side_len: int,
              ignore_header_pct: float = 0.10,
              ignore_footer_pct: float = 0.10,
              retry_on_connection: bool = True) -> list[dict]:
    with open(image_path, "rb") as f:
        img_b64 = base64.b64encode(f.read()).decode()

    # Detect image dimensions for ignoreArea pixel coords
    from PIL import Image
    try:
        with Image.open(image_path) as img:
            img_w, img_h = img.size
    except Exception:
        img_w, img_h = 2480, 3508  # A4 at 200 DPI fallback

    options = {
        "ocr.language": "models/config_chinese.txt",
        "ocr.cls": True,
        "ocr.limit_side_len": limit_side_len,
        "tbpu.parser": "multi_para",
        "data.format": "dict",
    }
    # Apply header/footer ignore regions
    ignore_areas = []
    if ignore_header_pct > 0:
        ignore_areas.append([
            [0, 0],
            [img_w, int(img_h * ignore_header_pct)],
        ])
    if ignore_footer_pct > 0:
        ignore_areas.append([
            [0, int(img_h * (1.0 - ignore_footer_pct))],
            [img_w, img_h],
        ])
    if ignore_areas:
        options["tbpu.ignoreArea"] = ignore_areas

    payload = {
        "base64": img_b64,
        "options": options,
    }

    def _do_request():
        return _request_json(f"{UMI_OCR_HOST}/api/ocr", payload)

    try:
        result = _do_request()
    except Exception as exc:
        if retry_on_connection and _is_connection_error(exc):
            print("[umi-ocr] connection lost, restarting service...", flush=True)
            _stop_umi_ocr()
            try:
                ensure_umi_ocr_running()
                result = _do_request()
            except Exception as exc2:
                raise RuntimeError(f"Umi-OCR unreachable after restart: {exc2}") from exc2
        else:
            raise

    code = result.get("code")
    if code == 100:
        return result.get("data", [])
    if code == 101:
        return []
    raise RuntimeError(f"Umi-OCR returned error code={code}: {result}")


def _render_pdf_to_images(pdf_path: Path, output_dir: Path, dpi: int) -> tuple[list[Path], list[tuple[float, float]], list[tuple[int, int]]]:
    """Returns (image_paths, page_sizes_pt, page_sizes_px)."""
    import fitz
    doc = fitz.open(str(pdf_path))
    image_paths = []
    page_sizes_pt = []
    page_sizes_px = []

    for page_num in range(len(doc)):
        page = doc[page_num]
        page_sizes_pt.append((float(page.rect.width), float(page.rect.height)))
        zoom = dpi / 72.0
        mat = fitz.Matrix(zoom, zoom)
        pix = page.get_pixmap(matrix=mat)
        page_sizes_px.append((pix.width, pix.height))
        img_path = output_dir / f"page_{page_num:04d}.png"
        pix.save(str(img_path))
        image_paths.append(img_path)
        print(f"[umi-ocr] rendered page {page_num + 1}/{len(doc)}  "
              f"{pix.width}x{pix.height}px", flush=True)
    doc.close()
    return image_paths, page_sizes_pt, page_sizes_px


# ─── Layer 1: Merge ──────────────────────────────────────────────────────────

def _item_bbox(item: dict) -> tuple[float, float, float, float]:
    """Return (xmin, ymin, xmax, ymax) for a raw Umi-OCR item."""
    box = item.get("box", [])
    if not box:
        return (0, 0, 0, 0)
    xs = [p[0] for p in box]
    ys = [p[1] for p in box]
    return (min(xs), min(ys), max(xs), max(ys))


def _horizontal_overlap(a: tuple[float, float, float, float],
                        b: tuple[float, float, float, float]) -> float:
    """Overlap ratio of two bboxes on the x-axis."""
    overlap = min(a[2], b[2]) - max(a[0], b[0])
    if overlap <= 0:
        return 0.0
    min_width = min(a[2] - a[0], b[2] - b[0])
    return overlap / min_width if min_width > 0 else 0.0


def _should_merge(prev: dict, curr: dict) -> bool:
    """Determine if two raw Umi-OCR items should be merged into one paragraph."""
    pa = _item_bbox(prev)
    pb = _item_bbox(curr)
    # Condition 1: horizontal overlap > 70% (same column)
    if _horizontal_overlap(pa, pb) < 0.70:
        return False
    # Condition 2: vertical gap < 1.5x line height of previous item
    prev_line_h = pa[3] - pa[1]
    if prev_line_h <= 0:
        return False
    gap = pb[1] - pa[3]
    if gap > prev_line_h * 1.5:
        return False
    # Condition 3: previous line does NOT end with sentence-ending punctuation
    prev_text = (prev.get("text", "") or "").strip()
    if prev_text and _SENTENCE_END_RE.search(prev_text):
        return False
    return True


def _merge_items(raw_items: list[dict]) -> list[dict]:
    """Merge vertically adjacent text blocks into paragraphs."""
    if not raw_items:
        return []
    # Sort top-to-bottom, then left-to-right
    sorted_items = sorted(raw_items, key=lambda it: (
        _item_bbox(it)[1],  # ymin
        _item_bbox(it)[0],  # xmin
    ))
    merged = [dict(sorted_items[0])]
    merged[-1]["_merge_count"] = 1
    for item in sorted_items[1:]:
        if _should_merge(merged[-1], item):
            prev = merged[-1]
            pbox = _item_bbox(prev)
            ibox = _item_bbox(item)
            # Combine texts with a space
            prev_text = (prev.get("text", "") or "").strip()
            curr_text = (item.get("text", "") or "").strip()
            prev["text"] = prev_text + " " + curr_text
            # Expand bbox to encompass both
            new_box = [[
                min(pbox[0], ibox[0]), min(pbox[1], ibox[1]),
            ], [
                max(pbox[2], ibox[2]), min(pbox[1], ibox[1]),
            ], [
                max(pbox[2], ibox[2]), max(pbox[3], ibox[3]),
            ], [
                min(pbox[0], ibox[0]), max(pbox[3], ibox[3]),
            ]]
            prev["box"] = new_box
            prev["score"] = max(prev.get("score", 0), item.get("score", 0))
            prev["_merge_count"] = (prev.get("_merge_count", 1) or 1) + 1
        else:
            item["_merge_count"] = 1
            merged.append(dict(item))
    return merged


# ─── Layer 2: Classify ───────────────────────────────────────────────────────

def _classify_blocks(merged_items: list[dict], img_w: int, img_h: int) -> list[dict]:
    """Add layout_type to each merged item based on position and size rules."""
    if not merged_items:
        return []

    # Compute average block height for font-size heuristic
    heights = []
    for item in merged_items:
        bbox = _item_bbox(item)
        h = bbox[3] - bbox[1]
        if h > 0:
            heights.append(h)
    avg_h = sum(heights) / len(heights) if heights else 20

    page_center_x = img_w / 2

    for item in merged_items:
        bbox = _item_bbox(item)
        x, y, w, h = bbox[0], bbox[1], bbox[2] - bbox[0], bbox[3] - bbox[1]
        text = (item.get("text", "") or "").strip()

        # Rule 1: position-based header/footer (configurable via UI)
        if y < img_h * 0.10:
            item["layout_type"] = "header"
        elif y + h > img_h * 0.90:
            item["layout_type"] = "footer"
        # Rule 2: font-size based title (bbox height > 1.5x average)
        elif h > avg_h * 1.5:
            item["layout_type"] = "title"
        # Rule 3: centered + short text → subtitle
        elif abs((x + w / 2) - page_center_x) < img_w * 0.10 and len(text) < 80:
            item["layout_type"] = "subtitle"
        # Rule 4: numbered paragraph
        elif text[:2] in ("1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9."):
            item["layout_type"] = "numbered_paragraph"
        else:
            item["layout_type"] = "paragraph"

    return merged_items


# ─── Build document.v1 ───────────────────────────────────────────────────────

def _build_document_v1(
    pdf_path: Path,
    all_page_results: list[list[dict]],
    page_sizes_pt: list[tuple[float, float]],
    dpi: int,
    elapsed: float,
) -> dict:
    """Convert classified Umi-OCR results to normalized_document_v1 format."""
    scale = 72.0 / float(dpi)

    # layout_type → layout_role mapping
    _layout_role_map = {
        "title": "title",
        "subtitle": "title",
        "header": "header",
        "footer": "footer",
        "numbered_paragraph": "paragraph",
        "paragraph": "paragraph",
    }

    pages_data = []
    total_blocks = 0

    for page_idx, (page_results, (pw, ph)) in enumerate(zip(all_page_results, page_sizes_pt)):
        blocks = []
        for order, item in enumerate(page_results):
            text = (item.get("text", "") or "").strip()
            if not text:
                continue
            box = item.get("box", [])
            score = item.get("score", 0.0)
            layout_type = item.get("layout_type", "paragraph")
            is_merged = (item.get("_merge_count", 1) or 1) > 1
            merge_count = item.get("_merge_count", 1) or 1

            x_vals = [p[0] for p in box]
            y_vals = [p[1] for p in box]
            xmin = min(x_vals) * scale
            ymin = min(y_vals) * scale
            xmax = max(x_vals) * scale
            ymax = max(y_vals) * scale

            layout_role = _layout_role_map.get(layout_type, "paragraph")
            translate = layout_type not in ("header", "footer")

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
                    "translate_reason": "main_text" if translate else "ancillary",
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
                    "confidence": float(score),
                },
                "metadata": {
                    "layout_type": layout_type,
                    "is_merged": is_merged,
                    "merge_source_count": merge_count,
                },
                "source": {
                    "provider": "docling",
                },
            }
            blocks.append(block)
            total_blocks += 1

        pages_data.append({
            "page_index": page_idx,
            "page": page_idx + 1,
            "width": pw,
            "height": ph,
            "unit": "pt",
            "blocks": blocks,
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
                "engine": "PaddleOCR-json",
                "merge_enabled": True,
                "classify_enabled": True,
            },
            "stats": {
                "pages": len(pages_data),
                "blocks": total_blocks,
                "elapsed_seconds": round(elapsed, 2),
            },
        },
        "markers": {},
    }


# ─── Main process ────────────────────────────────────────────────────────────

def process_pdf(pdf_path: Path, output_dir: Path, dpi: int = 200, limit_side_len: int = 1500,
                ignore_header_pct: float = 0.10, ignore_footer_pct: float = 0.10) -> dict:
    ensure_umi_ocr_running()

    img_dir = output_dir / "page_images"
    img_dir.mkdir(parents=True, exist_ok=True)

    try:
        start = time.perf_counter()

        print(f"[umi-ocr] rendering PDF: {pdf_path}", flush=True)
        image_paths, page_sizes_pt, page_sizes_px = _render_pdf_to_images(pdf_path, img_dir, dpi)

        all_results = []
        total_merges = 0
        total = len(image_paths)
        for i, img_path in enumerate(image_paths):
            print(f"[umi-ocr] OCR page {i + 1}/{total} ...", flush=True)
            try:
                raw = _ocr_page(str(img_path), limit_side_len,
                                ignore_header_pct=ignore_header_pct,
                                ignore_footer_pct=ignore_footer_pct)
                # Layer 1: merge adjacent lines into paragraphs
                merged = _merge_items(raw)
                merges_this_page = sum(1 for m in merged if (m.get("_merge_count", 1) or 1) > 1)
                total_merges += merges_this_page
                # Layer 2: classify by position/size/text
                img_w, img_h = page_sizes_px[i]
                classified = _classify_blocks(merged, img_w, img_h)
                all_results.append(classified)
                print(f"[umi-ocr]   raw={len(raw)} merged={len(merged)} "
                      f"merged_blocks={merges_this_page}", flush=True)
            except Exception as exc:
                print(f"[umi-ocr] page {i + 1} OCR failed: {exc}", flush=True)
                all_results.append([])

        elapsed = time.perf_counter() - start

        document = _build_document_v1(pdf_path, all_results, page_sizes_pt, dpi, elapsed)

        # Save document.v1.json
        doc_v1_path = output_dir / "document.v1.json"
        doc_v1_path.parent.mkdir(parents=True, exist_ok=True)
        with open(doc_v1_path, "w", encoding="utf-8") as f:
            json.dump(document, f, ensure_ascii=False, indent=2)

        # Save layout.json
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
            f"[umi-ocr] done  pages={total}  blocks={block_count}  "
            f"merged={total_merges}  time={elapsed:.1f}s  output={doc_v1_path}",
            flush=True,
        )

        return document

    finally:
        import shutil
        if img_dir.exists():
            shutil.rmtree(img_dir, ignore_errors=True)


def main() -> None:
    args = parse_args()
    pdf_path = Path(args.pdf_path).resolve()
    output_dir = Path(args.output_dir).resolve()

    if not pdf_path.exists():
        print(f"ERROR: PDF not found: {pdf_path}", file=sys.stderr)
        sys.exit(1)

    print(f"umi-ocr-worker: pdf={pdf_path}", flush=True)
    print(f"umi-ocr-worker: output_dir={output_dir}", flush=True)
    print(f"umi-ocr-worker: dpi={args.dpi}", flush=True)
    print(f"umi-ocr-worker: limit_side_len={args.limit_side_len}", flush=True)

    process_pdf(pdf_path, output_dir, dpi=args.dpi, limit_side_len=args.limit_side_len)


if __name__ == "__main__":
    main()
