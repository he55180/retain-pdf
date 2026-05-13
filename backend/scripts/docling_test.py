"""Docling PDF conversion test.

Usage:
    python backend/scripts/docling_test.py <path-to-pdf>

If no PDF path is given, creates a minimal test PDF automatically.
"""

import sys
import time
from pathlib import Path


def check_python_runtime():
    """Check Python version meets Docling requirement (3.10+)."""
    ok = sys.version_info >= (3, 10)
    print(f"[Python Runtime]")
    print(f"  Executable : {sys.executable}")
    print(f"  Version    : {sys.version.split()[0]}")
    print(f"  3.10+      : {'YES' if ok else 'NO - Docling requires Python >= 3.10'}")
    print()
    if not ok:
        sys.exit(1)
    return ok


def create_test_pdf(path: Path):
    """Create a minimal test PDF using reportlab."""
    try:
        from reportlab.pdfgen import canvas
    except ImportError:
        print("reportlab not installed, installing...")
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "reportlab"])
        from reportlab.pdfgen import canvas

    c = canvas.Canvas(str(path))
    c.setFont("Helvetica", 12)
    lines = [
        "Docling PDF Conversion Test",
        "=" * 40,
        "",
        "This is a test document for evaluating the Docling document conversion pipeline.",
        "Docling can parse PDFs, extract layout, recognize text, and export to Markdown.",
        "",
        "Features demonstrated in this test:",
        "  - PDF text extraction",
        "  - Markdown export",
        "  - Conversion time measurement",
        "",
        "Docling supports multiple output formats including Markdown, JSON, and DocTags.",
    ]
    y = 750
    for line in lines:
        c.drawString(50, y, line)
        y -= 20
    c.save()
    print(f"  Created test PDF: {path}")
    return path


def main():
    # --- resolve input PDF ---
    if len(sys.argv) > 1:
        pdf_path = Path(sys.argv[1])
        if not pdf_path.exists():
            print(f"ERROR: file not found: {pdf_path}")
            sys.exit(1)
    else:
        pdf_path = Path.home() / ".docling_test_input.pdf"
        create_test_pdf(pdf_path)

    print(f"[Input]  {pdf_path.resolve()}")
    print()

    # --- runtime check ---
    check_python_runtime()

    # --- convert ---
    from docling.document_converter import DocumentConverter

    print("[Conversion]")
    converter = DocumentConverter()

    start = time.perf_counter()
    result = converter.convert(str(pdf_path))
    elapsed = time.perf_counter() - start

    # --- output ---
    md = result.document.export_to_markdown()

    print(f"  Time     : {elapsed:.2f}s")
    print(f"  Pages    : {len(result.document.pages)}")
    print(f"  Markdown : {len(md)} chars")
    print()
    print("--- First 500 characters ---")
    print(md[:500])

    # Clean up auto-created test PDF
    if len(sys.argv) == 1:
        pdf_path.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
