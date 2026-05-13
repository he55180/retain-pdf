from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from types import SimpleNamespace

import fitz

sys.path.append(str(Path(__file__).resolve().parents[2]))

from foundation.shared.job_dirs import add_explicit_job_dir_args
from foundation.shared.job_dirs import job_dirs_from_explicit_args
from foundation.shared.stage_specs import NormalizeStageSpec
from services.document_schema import DOCUMENT_SCHEMA_REPORT_FILE_NAME
from services.document_schema import adapt_path_to_document_v1_with_report
from services.document_schema import validate_saved_document_path
from services.document_schema.reporting import build_normalization_summary
from services.document_schema.provider_adapters.paddle.content_extract import build_lines as build_paddle_lines
from services.document_schema.provider_adapters.paddle.content_extract import tighten_text_bbox as tighten_paddle_text_bbox


def _save_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def _scale_bbox(value: list[float], scale_x: float, scale_y: float) -> list[float]:
    if not isinstance(value, list) or len(value) != 4:
        return value
    return [
        round(float(value[0]) * scale_x, 3),
        round(float(value[1]) * scale_y, 3),
        round(float(value[2]) * scale_x, 3),
        round(float(value[3]) * scale_y, 3),
    ]


def _scale_point_list(value: list, scale_x: float, scale_y: float) -> list:
    if not isinstance(value, list):
        return value
    scaled = []
    for item in value:
        if isinstance(item, (list, tuple)) and len(item) == 2:
            scaled.append([round(float(item[0]) * scale_x, 3), round(float(item[1]) * scale_y, 3)])
        else:
            scaled.append(item)
    return scaled


def _rescale_document_geometry_to_pdf(document: dict, source_pdf_path: Path) -> dict:
    pdf = fitz.open(source_pdf_path)
    try:
        pages = document.get("pages", []) or []
        for page_index, page in enumerate(pages):
            if page_index >= len(pdf):
                break
            pdf_page = pdf[page_index]
            pdf_w = float(pdf_page.rect.width)
            pdf_h = float(pdf_page.rect.height)
            raw_w = float(page.get("width", 0) or 0)
            raw_h = float(page.get("height", 0) or 0)
            if raw_w <= 0 or raw_h <= 0:
                page["width"] = pdf_w
                page["height"] = pdf_h
                continue
            scale_x = pdf_w / raw_w
            scale_y = pdf_h / raw_h
            if abs(scale_x - 1.0) < 0.01 and abs(scale_y - 1.0) < 0.01:
                page["width"] = pdf_w
                page["height"] = pdf_h
                continue

            page["width"] = pdf_w
            page["height"] = pdf_h
            for block in page.get("blocks", []) or []:
                block["bbox"] = _scale_bbox(block.get("bbox", []), scale_x, scale_y)
                for line in block.get("lines", []) or []:
                    line["bbox"] = _scale_bbox(line.get("bbox", []), scale_x, scale_y)
                    for span in line.get("spans", []) or []:
                        span["bbox"] = _scale_bbox(span.get("bbox", []), scale_x, scale_y)
                for segment in block.get("segments", []) or []:
                    if isinstance(segment, dict):
                        segment["bbox"] = _scale_bbox(segment.get("bbox", []), scale_x, scale_y)
                source = block.get("source") or {}
                if source:
                    source["raw_bbox"] = _scale_bbox(source.get("raw_bbox", []), scale_x, scale_y)
                metadata = block.get("metadata") or {}
                if metadata:
                    metadata["raw_polygon"] = _scale_point_list(metadata.get("raw_polygon", []), scale_x, scale_y)
                    metadata["layout_det_polygon"] = _scale_point_list(metadata.get("layout_det_polygon", []), scale_x, scale_y)
    finally:
        pdf.close()
    return document


def _post_rescale_rebuild_paddle_text_geometry(document: dict) -> dict:
    source = document.get("source") or {}
    if str(source.get("provider", "") or "").strip().lower() != "paddle":
        return document

    for page in document.get("pages", []) or []:
        for block in page.get("blocks", []) or []:
            block_type = str(block.get("type", "") or "")
            sub_type = str(block.get("sub_type", "") or "")
            text = str(block.get("text", "") or "")
            raw_label = str((block.get("source") or {}).get("raw_type", "") or "")
            original_bbox = list(block.get("bbox", []) or [])
            tightened_bbox = tighten_paddle_text_bbox(
                bbox=original_bbox,
                text=text,
                block_type=block_type,
                sub_type=sub_type,
            )
            if tightened_bbox != original_bbox:
                block["bbox"] = tightened_bbox
                source_payload = block.get("source") or {}
                if source_payload:
                    source_payload["raw_bbox"] = tightened_bbox
                metadata = block.get("metadata") or {}
                metadata["provider_bbox_tightened"] = True
                metadata["provider_bbox_original"] = original_bbox
                block["metadata"] = metadata
            rebuilt_lines = build_paddle_lines(
                bbox=block.get("bbox", []),
                segments=block.get("segments", []) or [],
                text=text,
                raw_label=raw_label,
                block_type=block_type,
                sub_type=sub_type,
            )
            if rebuilt_lines:
                block["lines"] = rebuilt_lines
    return document


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Normalize an already-downloaded OCR provider payload into document.v1 artifacts.",
    )
    parser.add_argument("--spec", type=str, default="", help="Path to normalize stage spec JSON.")
    parser.add_argument("--provider", type=str, default="", help="OCR provider name, e.g. mineru/paddle")
    parser.add_argument("--source-json", type=str, default="", help="Path to raw provider JSON")
    parser.add_argument("--source-pdf", type=str, default="", help="Path to source PDF")
    add_explicit_job_dir_args(parser, required=False)
    parser.add_argument("--provider-version", type=str, default="", help="Optional provider version")
    parser.add_argument("--provider-result-json", type=str, default="", help="Existing provider result summary JSON path")
    parser.add_argument("--provider-zip", type=str, default="", help="Existing provider bundle zip path")
    parser.add_argument("--provider-raw-dir", type=str, default="", help="Existing provider unpacked raw dir path")
    return parser.parse_args()


def _args_from_spec(spec: NormalizeStageSpec) -> SimpleNamespace:
    job_dirs = spec.job_dirs
    return SimpleNamespace(
        provider=spec.inputs.provider,
        source_json=str(spec.inputs.source_json),
        source_pdf=str(spec.inputs.source_pdf),
        job_root=str(job_dirs.root),
        source_dir=str(job_dirs.source_dir),
        ocr_dir=str(job_dirs.ocr_dir),
        translated_dir=str(job_dirs.translated_dir),
        rendered_dir=str(job_dirs.rendered_dir),
        artifacts_dir=str(job_dirs.artifacts_dir),
        logs_dir=str(job_dirs.logs_dir),
        provider_version=spec.inputs.provider_version,
        provider_result_json=str(spec.inputs.provider_result_json or ""),
        provider_zip=str(spec.inputs.provider_zip or ""),
        provider_raw_dir=str(spec.inputs.provider_raw_dir or ""),
    )


def _run_docling_ocr_for_normalize(
    source_pdf_path: Path,
    layout_json_path: Path,
    ocr_dir: Path,
) -> None:
    """Run Docling local OCR, save document.v1.json and minimal layout.json metadata."""
    import os
    import time

    print("[DOCLING] normalize worker running OCR", flush=True)

    os.environ["HF_ENDPOINT"] = "https://hf-mirror.com"
    os.environ["HF_HUB_OFFLINE"] = "0"
    os.environ["HF_HUB_VERBOSITY"] = "error"
    os.environ.setdefault("HF_HOME", os.path.expanduser("~/.cache/huggingface"))

    cache_home = os.environ["HF_HOME"]
    models_cached = (
        os.path.isdir(os.path.join(cache_home, "hub", "models--docling-project--docling-models"))
        and os.path.isdir(os.path.join(cache_home, "hub", "models--docling-project--docling-layout-heron"))
    )
    if not models_cached:
        print("docling: first_run  downloading AI models (~500MB, first time only)...", flush=True)
        print("docling: mirror=https://hf-mirror.com", flush=True)
        print("docling: this may take several minutes depending on network speed", flush=True)

    from docling_worker import _build_document_v1

    try:
        from docling.document_converter import DocumentConverter, PdfFormatOption
        from docling.datamodel.pipeline_options import PdfPipelineOptions
    except ImportError as exc:
        raise RuntimeError(
            "Docling is not installed in the Python runtime. "
            "Please ensure docling is included in the desktop application package. "
            f"Original error: {exc}"
        ) from exc

    pipeline_opts = PdfPipelineOptions(do_ocr=True, do_table_structure=True)
    try:
        converter = DocumentConverter(
            format_options={"pdf": PdfFormatOption(pipeline_options=pipeline_opts)},
        )
        start = time.perf_counter()
        result = converter.convert(str(source_pdf_path))
        elapsed = time.perf_counter() - start
    except Exception as exc:
        msg = str(exc).lower()
        if "offline" in msg or "connection" in msg or "download" in msg:
            raise RuntimeError(
                "Docling AI models could not be downloaded. "
                "Please check your network connection and ensure hf-mirror.com is accessible. "
                "The models will be cached locally after the first successful download. "
                f"Original error: {exc}"
            ) from exc
        raise

    docling_doc = result.document
    total_pages = len(docling_doc.pages)
    print(f"docling: pages={total_pages} elapsed={elapsed:.1f}s", flush=True)

    for page_num in sorted(docling_doc.pages.keys()):
        count = sum(1 for item, _ in docling_doc.iterate_items()
                    if item.prov and item.prov[0].page_no == page_num)
        print(f"docling: progress  page={page_num}/{total_pages}  items={count}", flush=True)

    document = _build_document_v1(source_pdf_path, docling_doc, elapsed)
    doc_v1_path = ocr_dir / "document.v1.json"
    doc_v1_path.parent.mkdir(parents=True, exist_ok=True)
    with open(doc_v1_path, "w", encoding="utf-8") as f:
        json.dump(document, f, ensure_ascii=False, indent=2)

    layout_json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(layout_json_path, "w", encoding="utf-8") as f:
        json.dump({
            "provider": "docling",
            "document_v1_path": str(doc_v1_path),
            "elapsed_seconds": round(elapsed, 2),
        }, f, ensure_ascii=False)

    block_count = sum(len(p["blocks"]) for p in document["pages"])
    print(
        f"docling: done  pages={total_pages}  blocks={block_count}  output={doc_v1_path}",
        flush=True,
    )


def _materialize_docling_source_for_normalize(
    ocr_dir: Path,
    layout_json_path: Path,
) -> Path:
    """Resolve the actual document.v1.json path from docling metadata."""
    if layout_json_path.exists():
        try:
            meta = json.loads(layout_json_path.read_text(encoding="utf-8"))
            if meta.get("provider") == "docling":
                doc_v1_str = meta.get("document_v1_path", "")
                if doc_v1_str:
                    doc_v1_path = Path(doc_v1_str)
                    if doc_v1_path.exists():
                        return doc_v1_path
        except (json.JSONDecodeError, OSError, ValueError):
            pass
    doc_v1_path = ocr_dir / "document.v1.json"
    if doc_v1_path.exists():
        return doc_v1_path
    return layout_json_path


def main() -> None:
    args = parse_args()
    if not args.spec.strip():
        raise RuntimeError("normalize worker now requires --spec <normalize.spec.json>")
    args = _args_from_spec(NormalizeStageSpec.load(Path(args.spec)))
    provider = args.provider.strip().lower()
    source_json_path = Path(args.source_json).resolve()
    source_pdf_path = Path(args.source_pdf).resolve()

    job_dirs = job_dirs_from_explicit_args(args)
    ocr_dir = job_dirs.ocr_dir
    normalized_dir = ocr_dir / "normalized"
    normalized_json_path = normalized_dir / "document.v1.json"
    normalized_report_json_path = normalized_dir / DOCUMENT_SCHEMA_REPORT_FILE_NAME

    if provider == "docling":
        if not source_json_path.exists():
            if not source_pdf_path.exists():
                raise RuntimeError(f"source pdf not found: {source_pdf_path}")
            _run_docling_ocr_for_normalize(source_pdf_path, source_json_path, ocr_dir)
        source_json_path = _materialize_docling_source_for_normalize(
            ocr_dir, source_json_path
        )

    if not source_json_path.exists():
        raise RuntimeError(f"source json not found: {source_json_path}")
    if not source_pdf_path.exists():
        raise RuntimeError(f"source pdf not found: {source_pdf_path}")

    normalized_document, normalization_report = adapt_path_to_document_v1_with_report(
        source_json_path=source_json_path,
        document_id=job_dirs.root.name,
        provider=provider,
        provider_version=str(args.provider_version or ""),
    )
    normalized_document = _rescale_document_geometry_to_pdf(normalized_document, source_pdf_path)
    normalized_document = _post_rescale_rebuild_paddle_text_geometry(normalized_document)
    _save_json(normalized_json_path, normalized_document)
    _save_json(normalized_report_json_path, normalization_report)

    report = validate_saved_document_path(normalized_json_path)
    normalization_summary = build_normalization_summary(normalization_report)
    print(f"job root: {job_dirs.root}", flush=True)
    print(f"source pdf: {source_pdf_path}", flush=True)
    print(f"layout json: {source_json_path}", flush=True)
    print(f"normalized document json: {normalized_json_path}", flush=True)
    print(f"normalization report json: {normalized_report_json_path}", flush=True)
    print(f"provider raw dir: {args.provider_raw_dir.strip() or ocr_dir}", flush=True)
    print(f"provider zip: {args.provider_zip.strip()}", flush=True)
    print(f"provider summary json: {args.provider_result_json.strip() or source_json_path}", flush=True)
    print(
        "normalized document validated: "
        f"schema={report['schema']} "
        f"version={report['schema_version']} "
        f"pages={report['page_count']} "
        f"blocks={report['block_count']} "
        f"path={normalized_json_path}",
        flush=True,
    )
    print(
        "normalized document report: "
        f"provider={normalization_summary['provider']} "
        f"detected={normalization_summary['detected_provider']} "
        f"pages_observed={normalization_summary['pages_observed']} "
        f"blocks_observed={normalization_summary['blocks_observed']} "
        f"defaulted_document_fields={normalization_summary['defaulted_document_fields']} "
        f"defaulted_page_fields={normalization_summary['defaulted_page_fields']} "
        f"defaulted_block_fields={normalization_summary['defaulted_block_fields']} "
        f"path={normalized_report_json_path}",
        flush=True,
    )
    print("schema version: document.v1", flush=True)
