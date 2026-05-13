"""OCR engine router.

Routes OCR requests to the selected engine:
  - docling : local Docling OCR worker
  - mineru  : MinerU cloud OCR (existing pipeline)
  - paddle  : PaddleOCR cloud (existing pipeline)

Usage (direct):
    python backend/scripts/ocr_router.py --provider docling --pdf-path <path> --output-dir <dir>

Usage (spec-based, for mineru/paddle):
    python backend/scripts/ocr_router.py --provider mineru --spec <spec.json>
    python backend/scripts/ocr_router.py --provider paddle --spec <spec.json>
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="OCR engine router")
    parser.add_argument("--provider", type=str, required=True,
                        choices=["docling", "mineru", "paddle"],
                        help="OCR engine to use")
    parser.add_argument("--spec", type=str, default="",
                        help="Provider stage spec JSON path (mineru / paddle)")
    parser.add_argument("--pdf-path", type=str, default="",
                        help="Input PDF path (docling direct mode)")
    parser.add_argument("--output-dir", type=str, default="",
                        help="Output directory (docling direct mode)")
    parser.add_argument("--do-ocr", action="store_true", default=True,
                        help="Enable OCR for scanned PDFs (docling)")
    parser.add_argument("--no-ocr", action="store_true",
                        help="Disable OCR (docling)")
    parser.add_argument("--do-table-structure", action="store_true", default=True,
                        help="Enable table structure (docling)")
    parser.add_argument("--no-table-structure", action="store_true",
                        help="Disable table structure (docling)")
    return parser.parse_args()


def _run_docling(args: argparse.Namespace) -> None:
    """Run Docling worker directly."""
    if not args.pdf_path:
        print("ERROR: --pdf-path is required for docling provider", file=sys.stderr)
        sys.exit(1)
    if not args.output_dir:
        print("ERROR: --output-dir is required for docling provider", file=sys.stderr)
        sys.exit(1)

    # Build args that docling_worker.main() expects
    # We call it via subprocess so it runs in its own process
    import subprocess
    this_dir = Path(__file__).resolve().parent
    worker_script = this_dir / "docling_worker.py"
    cmd = [
        sys.executable, str(worker_script),
        "--pdf-path", args.pdf_path,
        "--output-dir", args.output_dir,
    ]
    if args.no_ocr:
        cmd.append("--no-ocr")
    if args.no_table_structure:
        cmd.append("--no-table-structure")

    result = subprocess.run(cmd, check=False)
    sys.exit(result.returncode)


def _run_mineru_paddle(args: argparse.Namespace) -> None:
    """Delegate to the existing provider pipeline for mineru / paddle."""
    if not args.spec:
        print(f"ERROR: --spec is required for {args.provider} provider", file=sys.stderr)
        sys.exit(1)

    spec_path = Path(args.spec).resolve()
    if not spec_path.exists():
        print(f"ERROR: spec not found: {spec_path}", file=sys.stderr)
        sys.exit(1)

    # Import and run the existing provider pipeline
    this_dir = Path(__file__).resolve().parent
    sys.path.insert(0, str(this_dir))

    from services.ocr_provider.provider_pipeline import main as provider_main

    # provider_main() reads sys.argv directly via argparse
    # We need to replace sys.argv and call it
    original_argv = sys.argv
    try:
        sys.argv = ["run_provider_ocr.py", "--spec", str(spec_path)]
        provider_main()
    finally:
        sys.argv = original_argv


def main() -> None:
    args = parse_args()
    provider = args.provider.strip().lower()

    print(f"ocr-router: provider={provider}", flush=True)

    if provider == "docling":
        _run_docling(args)
    elif provider in ("mineru", "paddle"):
        _run_mineru_paddle(args)
    else:
        print(f"ERROR: unsupported provider: {provider}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
