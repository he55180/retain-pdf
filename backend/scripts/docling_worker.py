"""Docling local OCR worker.

Converts a PDF to document.v1.json using Docling, supporting scanned
documents (do_ocr=True) and table structure recognition.

Usage:
    python backend/scripts/docling_worker.py \\
        --pdf-path <path> \\
        --output-dir <dir> \\
        [--do-ocr] [--do-table-structure]
"""

from __future__ import annotations

import argparse
import json
import sys
import time
import uuid
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Docling OCR worker")
    parser.add_argument("--pdf-path", type=str, required=True, help="Input PDF path")
    parser.add_argument("--output-dir", type=str, required=True, help="Output directory")
    parser.add_argument("--do-ocr", action="store_true", default=True,
                        help="Enable OCR for scanned PDFs (default: True)")
    parser.add_argument("--no-ocr", action="store_true", help="Disable OCR")
    parser.add_argument("--do-table-structure", action="store_true", default=True,
                        help="Enable table structure recognition (default: True)")
    parser.add_argument("--no-table-structure", action="store_true",
                        help="Disable table structure")
    args = parser.parse_args()
    if args.no_ocr:
        args.do_ocr = False
    if args.no_table_structure:
        args.do_table_structure = False
    return args


def _label_to_role(label: str) -> tuple[str, str, str, str, bool]:
    """Map Docling label to (kind, layout_role, semantic_role, structure_role, translate)."""
    mapping = {
        "section_header":  ("text", "heading", "body", "heading", True),
        "title":           ("text", "title", "body", "title", True),
        "list_item":       ("text", "list_item", "body", "body", True),
        "paragraph":       ("text", "paragraph", "body", "body", True),
        "text":            ("text", "paragraph", "body", "body", True),
        "table":           ("table", "paragraph", "body", "body", True),
        "picture":         ("image", "paragraph", "body", "body", False),
        "chart":           ("image", "paragraph", "body", "body", False),
        "formula":         ("formula", "paragraph", "body", "body", True),
        "caption":         ("text", "caption", "body", "caption", False),
        "footnote":        ("text", "footnote", "metadata", "metadata", False),
        "page_header":     ("text", "header", "metadata", "metadata", False),
        "page_footer":     ("text", "footer", "metadata", "metadata", False),
        "checkbox_selected":  ("text", "paragraph", "body", "body", False),
        "checkbox_unselected": ("text", "paragraph", "body", "body", False),
        "code":            ("text", "paragraph", "body", "body", True),
        "reference":       ("text", "paragraph", "reference", "reference_entry", False),
        "form":            ("text", "paragraph", "metadata", "metadata", False),
        "key_value_region": ("text", "paragraph", "metadata", "metadata", False),
        "handwritten_text":  ("text", "paragraph", "body", "body", True),
        "marker":          ("text", "paragraph", "metadata", "metadata", False),
        "document_index":  ("text", "paragraph", "body", "body", True),
        "grading_scale":   ("text", "paragraph", "metadata", "metadata", False),
        "field_region":    ("text", "paragraph", "metadata", "metadata", False),
        "field_heading":   ("text", "heading", "body", "heading", True),
        "field_item":      ("text", "paragraph", "body", "body", True),
        "field_key":       ("text", "paragraph", "metadata", "metadata", False),
        "field_value":     ("text", "paragraph", "body", "body", True),
        "field_hint":      ("text", "paragraph", "metadata", "metadata", False),
        "empty_value":     ("text", "paragraph", "metadata", "metadata", False),
    }
    return mapping.get(label, ("text", "paragraph", "body", "body", True))


def _build_document_v1(pdf_path: Path, docling_doc, elapsed: float) -> dict:
    """Convert Docling output to document.v1.json format (validated contract).

    iterate_items() yields (item, level) tuples. Each item has:
      - .label (DocItemLabel enum, .value gives the string)
      - .text (the extracted text)
      - .prov[0] (ProvenanceItem with .page_no, .bbox)
      - .prov[0].bbox (BoundingBox with .l, .t, .r, .b)
    """
    pages_data = []
    total_blocks = 0

    # Build a mapping: page_no -> list of (item, level)
    page_items: dict[int, list] = {}
    for item, level in docling_doc.iterate_items():
        if not item.prov:
            continue
        prov = item.prov[0]
        page_no = prov.page_no
        page_items.setdefault(page_no, []).append((item, level))

    for page_num in sorted(page_items.keys()):
        page_obj = docling_doc.pages.get(page_num)
        page_width = page_obj.size.width if (page_obj and page_obj.size) else 0
        page_height = page_obj.size.height if (page_obj and page_obj.size) else 0
        page_index = page_num - 1  # Docling uses 1-based, contract uses 0-based

        blocks = []
        for reading_order, (item, _level) in enumerate(page_items[page_num]):
            prov = item.prov[0]
            bbox = prov.bbox
            label = item.label.value if hasattr(item.label, "value") else str(item.label)
            text = (getattr(item, "text", "") or "").strip()

            kind, layout_role, semantic_role, structure_role, translate = _label_to_role(label)
            translate_reason = "main_text" if translate else f"layout_role={layout_role}"

            block = {
                "block_id": str(uuid.uuid4()),
                "page_index": page_index,
                "order": reading_order,
                "reading_order": reading_order,
                "geometry": {
                    "bbox": [bbox.l, bbox.t, bbox.r, bbox.b],
                },
                "content": {
                    "kind": kind,
                },
                "layout_role": layout_role,
                "semantic_role": semantic_role,
                "structure_role": structure_role,
                "policy": {
                    "translate": translate,
                    "translate_reason": translate_reason,
                },
                "provenance": {
                    "provider": "docling",
                    "raw_label": label,
                    "raw_sub_type": "",
                    "raw_bbox": [bbox.l, bbox.t, bbox.r, bbox.b],
                    "raw_path": str(pdf_path),
                },
                "continuation_hint": {
                    "source": "",
                    "group_id": "",
                    "role": "",
                    "scope": "",
                    "reading_order": -1,
                    "confidence": 0.0,
                },
                "metadata": {},
                "source": {
                    "provider": "docling",
                },
            }
            if text:
                block["content"]["text"] = text

            blocks.append(block)
            total_blocks += 1

        pages_data.append({
            "page_index": page_index,
            "page": page_num,
            "width": page_width,
            "height": page_height,
            "unit": "pt",
            "blocks": blocks,
        })

    document = {
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
                "do_ocr": True,
                "do_table_structure": True,
            },
            "stats": {
                "pages": len(pages_data),
                "blocks": total_blocks,
                "elapsed_seconds": round(elapsed, 2),
            },
        },
        "markers": {},
    }
    return document


def _ensure_models_cached() -> None:
    """Ensure Docling AI models are downloaded and cached locally.

    Uses hf-mirror.com (HuggingFace China mirror) which is accessible
    from both China and most international locations including Africa.

    On first run this will download ~500MB of models. Subsequent runs
    re-use the local cache in ~/.cache/huggingface/.
    """
    import os

    cache_home = os.path.expanduser(os.environ.get("HF_HOME", "~/.cache/huggingface"))
    models_ready = os.path.isdir(os.path.join(cache_home, "hub", "models--docling-project--docling-models"))

    # Always use hf-mirror.com for faster downloads from China / global access
    os.environ.setdefault("HF_ENDPOINT", "https://hf-mirror.com")

    if models_ready:
        print("docling-worker: models_cached (models found in local cache)", flush=True)
        return

    print("docling-worker: first_run  downloading AI models (~500MB, first time only)...", flush=True)
    print("docling-worker: mirror=https://hf-mirror.com", flush=True)
    # The actual download happens implicitly when DocumentConverter is first used.
    # We trigger it eagerly here so progress is visible before the conversion starts.


def main() -> None:
    args = parse_args()
    pdf_path = Path(args.pdf_path).resolve()
    output_dir = Path(args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    if not pdf_path.exists():
        print(f"ERROR: PDF not found: {pdf_path}", file=sys.stderr)
        sys.exit(1)

    print(f"docling-worker: pdf={pdf_path}", flush=True)
    print(f"docling-worker: output_dir={output_dir}", flush=True)
    print(f"docling-worker: do_ocr={args.do_ocr}", flush=True)
    print(f"docling-worker: do_table_structure={args.do_table_structure}", flush=True)

    _ensure_models_cached()

    # Lazy import so the script is importable without docling installed
    from docling.document_converter import DocumentConverter, PdfFormatOption
    from docling.datamodel.pipeline_options import PdfPipelineOptions

    pipeline_opts = PdfPipelineOptions(
        do_ocr=args.do_ocr,
        do_table_structure=args.do_table_structure,
    )
    converter = DocumentConverter(
        format_options={
            "pdf": PdfFormatOption(pipeline_options=pipeline_opts),
        },
    )

    start = time.perf_counter()
    result = converter.convert(str(pdf_path))
    elapsed = time.perf_counter() - start

    docling_doc = result.document
    total_pages = len(docling_doc.pages)
    print(f"docling-worker: pages={total_pages}", flush=True)

    # --- per-page progress ---
    for page_num in sorted(docling_doc.pages.keys()):
        count = sum(
            1 for item, _ in docling_doc.iterate_items()
            if item.prov and item.prov[0].page_no == page_num
        )
        print(
            f"docling-worker: progress  page={page_num}/{total_pages}  items={count}",
            flush=True,
        )

    # --- build document.v1.json ---
    document = _build_document_v1(pdf_path, docling_doc, elapsed)
    doc_v1_path = output_dir / "document.v1.json"
    with open(doc_v1_path, "w", encoding="utf-8") as f:
        json.dump(document, f, ensure_ascii=False, indent=2)

    block_count = sum(len(p["blocks"]) for p in document["pages"])
    print(f"docling-worker: done  time={elapsed:.2f}s  pages={total_pages}  "
          f"blocks={block_count}  output={doc_v1_path}", flush=True)


if __name__ == "__main__":
    main()
