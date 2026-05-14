"""Umi-OCR Worker for RetainPDF.

Renders PDF pages to images and OCRs them via local Umi-OCR HTTP API.
Produces document.v1.json compatible with the translation pipeline.

Usage:
    python backend/scripts/umi_ocr_worker.py --pdf-path <path> --output-dir <dir>
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import sys
import time
import uuid
from pathlib import Path

UMI_OCR_HOST = "http://127.0.0.1:1224"
UMI_OCR_TIMEOUT = 120
UMI_OCR_EXE_NAME = "Umi-OCR.exe"
_UMI_PROCESS = None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Umi-OCR worker")
    parser.add_argument("--pdf-path", type=str, required=True, help="Input PDF path")
    parser.add_argument("--output-dir", type=str, required=True, help="Output directory")
    parser.add_argument("--dpi", type=int, default=200, help="Render DPI (default: 200)")
    parser.add_argument("--limit-side-len", type=int, default=2000,
                        help="OCR image side limit in px (default: 2000)")
    return parser.parse_args()


def _find_umi_ocr_exe() -> str | None:
    this_file = Path(__file__).resolve()
    candidates = [
        Path(os.environ.get("RETAIN_PDF_RESOURCES", "")) / "umi-ocr" / UMI_OCR_EXE_NAME,
        # Runtime: resources/backend/scripts/ -> resources/umi-ocr/
        this_file.parents[3] / "umi-ocr" / UMI_OCR_EXE_NAME,
        # Dev: backend/scripts/ -> backend/../Umi-OCR_Paddle_v2.1.5/
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


def _ocr_page(image_path: str, limit_side_len: int, retry_on_connection: bool = True) -> list[dict]:
    with open(image_path, "rb") as f:
        img_b64 = base64.b64encode(f.read()).decode()

    payload = {
        "base64": img_b64,
        "options": {
            "ocr.language": "models/config_chinese.txt",
            "ocr.cls": True,
            "ocr.limit_side_len": limit_side_len,
            "tbpu.parser": "multi_para",
            "data.format": "dict",
        },
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
                raise RuntimeError(
                    f"Umi-OCR unreachable after restart: {exc2}"
                ) from exc2
        else:
            raise

    code = result.get("code")
    if code == 100:
        return result.get("data", [])
    if code == 101:
        return []
    raise RuntimeError(f"Umi-OCR returned error code={code}: {result}")


def _render_pdf_to_images(pdf_path: Path, output_dir: Path, dpi: int) -> tuple[list[Path], list[tuple[float, float]]]:
    import fitz

    doc = fitz.open(str(pdf_path))
    image_paths = []
    page_sizes = []

    for page_num in range(len(doc)):
        page = doc[page_num]
        page_sizes.append((float(page.rect.width), float(page.rect.height)))
        zoom = dpi / 72.0
        mat = fitz.Matrix(zoom, zoom)
        pix = page.get_pixmap(matrix=mat)
        img_path = output_dir / f"page_{page_num:04d}.png"
        pix.save(str(img_path))
        image_paths.append(img_path)
        print(f"[umi-ocr] rendered page {page_num + 1}/{len(doc)}  "
              f"{pix.width}x{pix.height}px", flush=True)

    doc.close()
    return image_paths, page_sizes


def _build_document_v1(
    pdf_path: Path,
    all_page_results: list[list[dict]],
    page_sizes: list[tuple[float, float]],
    dpi: int,
    elapsed: float,
) -> dict:
    """Convert Umi-OCR results to normalized_document_v1 format."""
    scale = 72.0 / float(dpi)

    pages_data = []
    total_blocks = 0

    for page_idx, (page_results, (pw, ph)) in enumerate(zip(all_page_results, page_sizes)):
        blocks = []
        for order, item in enumerate(page_results):
            text = (item.get("text", "") or "").strip()
            if not text:
                continue
            box = item.get("box", [])
            score = item.get("score", 0.0)

            x_vals = [p[0] for p in box]
            y_vals = [p[1] for p in box]
            xmin = min(x_vals) * scale
            ymin = min(y_vals) * scale
            xmax = max(x_vals) * scale
            ymax = max(y_vals) * scale

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
                "layout_role": "paragraph",
                "semantic_role": "body",
                "structure_role": "body",
                "policy": {
                    "translate": True,
                    "translate_reason": "main_text",
                },
                "provenance": {
                    "provider": "docling",
                    "raw_label": "text",
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
                "metadata": {},
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
            },
            "stats": {
                "pages": len(pages_data),
                "blocks": total_blocks,
                "elapsed_seconds": round(elapsed, 2),
            },
        },
        "markers": {},
    }


def process_pdf(pdf_path: Path, output_dir: Path, dpi: int = 200, limit_side_len: int = 1500) -> dict:
    ensure_umi_ocr_running()

    img_dir = output_dir / "page_images"
    img_dir.mkdir(parents=True, exist_ok=True)

    try:
        start = time.perf_counter()

        print(f"[umi-ocr] rendering PDF: {pdf_path}", flush=True)
        image_paths, page_sizes = _render_pdf_to_images(pdf_path, img_dir, dpi)

        all_results = []
        total = len(image_paths)
        for i, img_path in enumerate(image_paths):
            print(f"[umi-ocr] OCR page {i + 1}/{total} ...", flush=True)
            try:
                page_result = _ocr_page(str(img_path), limit_side_len)
                all_results.append(page_result)
            except Exception as exc:
                print(f"[umi-ocr] page {i + 1} OCR failed: {exc}", flush=True)
                all_results.append([])

        elapsed = time.perf_counter() - start

        document = _build_document_v1(pdf_path, all_results, page_sizes, dpi, elapsed)

        # Save document.v1.json
        doc_v1_path = output_dir / "document.v1.json"
        doc_v1_path.parent.mkdir(parents=True, exist_ok=True)
        with open(doc_v1_path, "w", encoding="utf-8") as f:
            json.dump(document, f, ensure_ascii=False, indent=2)

        # Save layout.json (used by normalize_pipeline as source_json)
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
            f"time={elapsed:.1f}s  output={doc_v1_path}",
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
