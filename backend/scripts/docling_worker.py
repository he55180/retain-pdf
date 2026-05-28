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
        "footnote":        ("text", "footnote", "metadata", "metadata", True),
        "page_header":     ("text", "header", "metadata", "metadata", False),
        "page_footer":     ("text", "footer", "metadata", "metadata", False),
        "checkbox_selected":  ("text", "paragraph", "body", "body", True),
        "checkbox_unselected": ("text", "paragraph", "body", "body", True),
        "code":            ("text", "paragraph", "body", "body", True),
        "reference":       ("text", "paragraph", "reference", "reference_entry", True),
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
                    "bbox": [bbox.l, page_height - bbox.t, bbox.r, page_height - bbox.b],
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
                    "raw_bbox": [bbox.l, page_height - bbox.t, bbox.r, page_height - bbox.b],
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

            # P3 Table adaptation: expand non-empty cells into independent text blocks
            # for cell-level translation and background cover overlay, while keeping 
            # the parent table block empty for scheme C border redraw.
            if label in ("table", "document_index") and hasattr(item, "data") and getattr(item.data, "table_cells", None):
                # P5.1 Scene-2: Detect signature tables and skip cell expansion
                # If table text contains signature keywords, mark as non-translatable
                # so the entire table region is preserved as-is (image pass-through).
                _SIGNATURE_KEYWORDS = {
                    "signed by", "signature", "签署", "签名", "sign here",
                    "authorized signatory", "witnessed by", "approved by",
                    "countersigned", "signatories",
                }
                _all_cell_texts = []
                for _sc in item.data.table_cells:
                    _ct = (getattr(_sc, "text", "") or "").strip()
                    if _ct:
                        _all_cell_texts.append(_ct)
                _combined_table_text = " ".join(_all_cell_texts).lower()
                _is_signature_table = any(kw in _combined_table_text for kw in _SIGNATURE_KEYWORDS)
                if _is_signature_table:
                    # Mark parent table block as non-translatable (image pass-through)
                    block["policy"]["translate"] = False
                    block["policy"]["translate_reason"] = "signature_table_passthrough"
                    print(
                        f"docling-worker: signature table detected on page {page_num}, "
                        f"skipping cell expansion for block {block['block_id']}",
                        flush=True,
                    )
                    # Skip cell expansion entirely for signature tables
                    # (parent block already appended at line 157)
                    continue  # skip to next item

                for cell_idx, cell in enumerate(item.data.table_cells):
                    cell_text = (getattr(cell, "text", "") or "").strip()
                    if not cell_text:
                        continue
                    cell_bbox = getattr(cell, "bbox", None)
                    if not cell_bbox:
                        continue
                    
                    col_index = getattr(cell, "col_start", -1)
                    if col_index == -1:
                        col_index = getattr(cell, "col_index", -1)
                    row_index = getattr(cell, "row_start", -1)
                    if row_index == -1:
                        row_index = getattr(cell, "row_index", -1)
                    
                    cell_block = {
                        "block_id": f"{block['block_id']}-cell-{cell_idx}",
                        "page_index": page_index,
                        "order": reading_order,
                        "reading_order": reading_order,
                        "geometry": {
                            "bbox": [cell_bbox.l, page_height - cell_bbox.t, cell_bbox.r, page_height - cell_bbox.b],
                        },
                        "content": {
                            "kind": "text",
                            "text": cell_text,
                        },
                        "layout_role": "paragraph",
                        "semantic_role": "body",
                        "structure_role": "body",
                        "policy": {
                            "translate": True,
                            "translate_reason": "table_cell",
                        },
                        "provenance": {
                            "provider": "docling",
                            "raw_label": "table_cell",
                            "raw_sub_type": "",
                            "raw_bbox": [cell_bbox.l, page_height - cell_bbox.t, cell_bbox.r, page_height - cell_bbox.b],
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
                        "metadata": {
                            "parent_block_id": block["block_id"],
                            "row_index": row_index,
                            "col_index": col_index,
                        },
                        "source": {
                            "provider": "docling",
                        }
                    }
                    blocks.append(cell_block)
                    total_blocks += 1

        # P5.1+ Failed Table Detection & Appended Translation:
        # Determine if the current page contains a table that failed structure parsing.
        import re
        para_blocks = []
        for b in blocks:
            if b.get("layout_role") == "paragraph" and (b.get("content") or {}).get("text"):
                # 条款段落（形如 6.1, 2.3）不作为失败表格识别候选，防止其被误抹除
                if re.match(r'^\d+\.\d*\s', b["content"]["text"].strip()):
                    continue
                para_blocks.append(b)
        
        def cluster_by_threshold(values, threshold=15.0):
            clusters_list = []
            for val in sorted(values):
                found_cluster = False
                for cluster in clusters_list:
                    avg = sum(cluster) / len(cluster)
                    if abs(val - avg) <= threshold:
                        cluster.append(val)
                        found_cluster = True
                        break
                if not found_cluster:
                    clusters_list.append([val])
            return clusters_list

        def is_failed_table_region(para_blocks, page_num):
            x_positions = [b.get("geometry", {}).get("bbox", [0])[0] for b in para_blocks]
            clusters = cluster_by_threshold(x_positions, threshold=15.0)
            all_text = " ".join([b.get("content", {}).get("text", "") for b in para_blocks])
            TABLE_KEYWORDS = ["HIV Intervention", "Primary Responsibility", "Main Content", "No.", "Service Provider"]

            # [DEBUG LOG STAGE]
            print(f"[DEBUG] Page {page_num} para_blocks count: {len(para_blocks)}", flush=True)
            print(f"[DEBUG] x clusters: {len(clusters)}", flush=True)
            print(f"[DEBUG] all_text sample: {all_text[:200]}", flush=True)
            print(f"[DEBUG] keyword match: {any(kw in all_text for kw in TABLE_KEYWORDS)}", flush=True)

            # 条件1：散乱段落块数量足够多
            if len(para_blocks) < 7:
                return False
            # 条件2：x坐标形成3-8列聚类（代表表格列对齐）
            if len(clusters) < 3 or len(clusters) > 8:
                return False
            # 条件3：必须匹配责任矩阵特征关键词
            if not any(kw in all_text for kw in TABLE_KEYWORDS):
                return False
            # 条件4：排除第1页
            if page_num == 1:
                return False
            return True

        def find_safe_insert_position(all_blocks, region_bbox):
            # 找到表格区域底边之下的第一个段落块
            post_table_blocks = [
                b for b in all_blocks
                if b.get("geometry", {}).get("bbox", [0, 0, 0, 0])[1] > region_bbox[3]
                and b.get("layout_role") == "paragraph"
            ]
            if post_table_blocks:
                sorted_post = sorted(post_table_blocks, key=lambda x: x.get("geometry", {}).get("bbox", [0, 0, 0, 0])[1])
                first_post_y = sorted_post[0].get("geometry", {}).get("bbox", [0, 0, 0, 0])[1]
                # 在表格底和后续段落顶之间居中偏下插入，或保底在表格底下 8pt 处
                return max(region_bbox[3] + 8.0, first_post_y - 45.0)
            return region_bbox[3] + 8.0

        if is_failed_table_region(para_blocks, page_num):
            xs = []
            ys = []
            for b in para_blocks:
                bbox = b.get("geometry", {}).get("bbox", [])
                if len(bbox) == 4:
                    xs.extend([bbox[0], bbox[2]])
                    ys.extend([bbox[1], bbox[3]])
            if xs and ys:
                region_bbox = [min(xs), min(ys), max(xs), max(ys)]
                texts = [b["content"]["text"].strip() for b in para_blocks if b.get("content", {}).get("text")]

                # 标记该区域的原始段落块为不翻译（图像直通）
                for b in para_blocks:
                    b["policy"]["translate"] = False
                    b["policy"]["translate_reason"] = "failed_table_passthrough"

                # 寻找安全的位置插入附加译文块
                insert_y = find_safe_insert_position(blocks, region_bbox)
                estimated_height = max(60.0, len(texts) * 14.0)
                max_order = max([b.get("order", 0) for b in blocks]) if blocks else 0
                max_r_order = max([b.get("reading_order", 0) for b in blocks]) if blocks else 0

                margin = 54.0
                left_x = margin if page_width > 0 else region_bbox[0]
                right_x = (page_width - margin) if page_width > 0 else region_bbox[2]

                appended_block = {
                    "block_id": f"appended-table-translation-{uuid.uuid4()}",
                    "page_index": page_index,
                    "order": max_order + 1,
                    "reading_order": max_r_order + 1,
                    "geometry": {
                        "bbox": [left_x, insert_y, right_x, insert_y + estimated_height],
                    },
                    "content": {
                        "kind": "text",
                        "text": "\n\n".join(texts),
                    },
                    "layout_role": "paragraph",
                    "semantic_role": "body",
                    "structure_role": "body",
                    "policy": {
                        "translate": True,
                        "translate_reason": "appended_table_translation",
                    },
                    "provenance": {
                        "provider": "docling",
                        "raw_label": "appended_table_translation",
                        "raw_sub_type": "",
                        "raw_bbox": region_bbox,
                        "raw_path": str(pdf_path),
                    },
                    "continuation_hint": {
                        "source": "", "group_id": "", "role": "", "scope": "", "reading_order": -1, "confidence": 0.0
                    },
                    "is_appended_table_translation": True,
                    "metadata": {},
                    "source": {
                        "provider": "docling",
                    }
                }
                blocks.append(appended_block)
                total_blocks += 1

        # P5.1+ Post-signature block protection:
        # If current page contains a signature table passthrough, prevent translation for all blocks below it.
        sig_table_bottom_ys = []
        for block in blocks:
            if (
                block.get("layout_role") == "table"
                and block.get("policy", {}).get("translate") is False
                and block.get("policy", {}).get("translate_reason") == "signature_table_passthrough"
            ):
                bbox = block.get("geometry", {}).get("bbox", [])
                if len(bbox) == 4:
                    sig_table_bottom_ys.append(bbox[3])

        if sig_table_bottom_ys:
            min_sig_table_bottom_y = min(sig_table_bottom_ys)
            for block in blocks:
                bbox = block.get("geometry", {}).get("bbox", [])
                if len(bbox) == 4 and bbox[1] >= min_sig_table_bottom_y - 2.0:
                    # 豁免检查：如果是以 数字.数字 开头的条款，保持翻译
                    b_text = (block.get("content", {}).get("text") or "").strip()
                    if re.match(r'^\d+\.\d*\s', b_text):
                        continue
                    block["policy"]["translate"] = False
                    block["policy"]["translate_reason"] = "post_signature_passthrough"

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

    # 1. Calculate PDF MD5 for caching
    import hashlib
    hasher = hashlib.md5()
    try:
        with open(pdf_path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                hasher.update(chunk)
        pdf_md5 = hasher.hexdigest()
    except Exception as e:
        pdf_md5 = ""
        print(f"docling-worker: failed to compute PDF MD5: {e}", file=sys.stderr)

    backend_dir = Path(__file__).resolve().parent.parent
    cache_dir = backend_dir / "workspace" / ".cache" / "ocr"
    cache_file = cache_dir / f"{pdf_md5}.json" if pdf_md5 else None
    doc_v1_path = output_dir / "document.v1.json"

    # 2. Check cache hit
    if cache_file and cache_file.exists():
        print(f"docling-worker: cache hit! loading cached OCR result from {cache_file}", flush=True)
        try:
            with open(cache_file, "r", encoding="utf-8") as sf:
                cached_data = json.load(sf)
            with open(doc_v1_path, "w", encoding="utf-8") as df:
                json.dump(cached_data, df, ensure_ascii=False, indent=2)
            block_count = sum(len(p["blocks"]) for p in cached_data.get("pages", []))
            total_pages = cached_data.get("page_count", 0)
            print(f"docling-worker: done (cached)  pages={total_pages}  "
                  f"blocks={block_count}  output={doc_v1_path}", flush=True)
            sys.exit(0)
        except Exception as e:
            print(f"docling-worker: error reading cache, falling back to full OCR: {e}", file=sys.stderr)

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
    with open(doc_v1_path, "w", encoding="utf-8") as f:
        json.dump(document, f, ensure_ascii=False, indent=2)

    # 3. Save to cache
    if cache_file:
        try:
            cache_dir.mkdir(parents=True, exist_ok=True)
            with open(cache_file, "w", encoding="utf-8") as cf:
                json.dump(document, cf, ensure_ascii=False, indent=2)
            print(f"docling-worker: saved OCR result to cache: {cache_file}", flush=True)
        except Exception as e:
            print(f"docling-worker: error saving cache: {e}", file=sys.stderr)

    block_count = sum(len(p["blocks"]) for p in document["pages"])
    print(f"docling-worker: done  time={elapsed:.2f}s  pages={total_pages}  "
          f"blocks={block_count}  output={doc_v1_path}", flush=True)


if __name__ == "__main__":
    main()
