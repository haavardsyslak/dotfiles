#!/usr/bin/env python3
"""Cache PDF text by page and return only targeted datasheet excerpts."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile


def need(command: str) -> str:
    path = shutil.which(command)
    if not path:
        raise SystemExit(f"Missing required command: {command}")
    return path


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def cache_root() -> Path:
    configured = os.environ.get("DATASHEET_CACHE_DIR")
    if configured:
        return Path(configured).expanduser()
    xdg = os.environ.get("XDG_CACHE_HOME")
    return Path(xdg).expanduser() / "pi-datasheets" if xdg else Path.home() / ".cache" / "pi-datasheets"


def resolve_pdf(raw: str) -> Path:
    path = Path(raw).expanduser().resolve()
    if not path.is_file():
        raise SystemExit(f"PDF not found: {path}")
    if path.suffix.lower() != ".pdf":
        raise SystemExit(f"Not a PDF path: {path}")
    return path


def cache_for(pdf: Path) -> tuple[Path, str]:
    sha = digest(pdf)
    return cache_root() / sha[:16], sha


def run(args: list[str], *, capture: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, text=True, capture_output=capture, check=False)


def build_index(pdf: Path, force: bool = False) -> tuple[Path, dict]:
    need("pdftotext")
    directory, sha = cache_for(pdf)
    manifest_path = directory / "manifest.json"

    if not force and manifest_path.is_file():
        try:
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            if manifest.get("sha256") == sha:
                return directory, manifest
        except (OSError, json.JSONDecodeError):
            pass

    directory.mkdir(parents=True, exist_ok=True)
    pages_dir = directory / "pages"
    pages_dir.mkdir(exist_ok=True)

    with tempfile.NamedTemporaryFile(prefix="datasheet-", suffix=".txt", delete=False) as temporary:
        text_path = Path(temporary.name)
    try:
        result = run([need("pdftotext"), "-layout", "-enc", "UTF-8", str(pdf), str(text_path)])
        if result.returncode != 0:
            message = (result.stderr or result.stdout).strip()
            raise SystemExit(f"pdftotext failed: {message}")
        text = text_path.read_text(encoding="utf-8", errors="replace")
    finally:
        text_path.unlink(missing_ok=True)

    pages = text.split("\f")
    if pages and not pages[-1].strip():
        pages.pop()
    if not pages:
        pages = [""]

    for stale in pages_dir.glob("*.txt"):
        stale.unlink()

    page_stats = []
    total_chars = 0
    for number, content in enumerate(pages, start=1):
        content = content.rstrip() + "\n"
        page_path = pages_dir / f"{number:04d}.txt"
        page_path.write_text(content, encoding="utf-8")
        chars = len(content.strip())
        total_chars += chars
        page_stats.append({"page": number, "chars": chars, "lines": content.count("\n")})

    manifest = {
        "source": str(pdf),
        "sha256": sha,
        "pages": len(pages),
        "text_chars": total_chars,
        "likely_scanned": total_chars < len(pages) * 40,
        "page_stats": page_stats,
    }
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return directory, manifest


def page_file(directory: Path, page: int, subdir: str = "pages") -> Path:
    return directory / subdir / f"{page:04d}.txt"


def command_index(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf, args.force)
    print(f"cache: {directory}")
    print(f"pages: {manifest['pages']}")
    print(f"text characters: {manifest['text_chars']}")
    print(f"likely scanned: {'yes' if manifest['likely_scanned'] else 'no'}")


def command_info(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf)
    print(f"source: {manifest['source']}")
    print(f"sha256: {manifest['sha256']}")
    print(f"cache: {directory}")
    print(f"pages: {manifest['pages']}")
    print(f"text characters: {manifest['text_chars']}")
    print(f"likely scanned: {'yes' if manifest['likely_scanned'] else 'no'}")
    if shutil.which("pdfinfo"):
        result = run(["pdfinfo", str(pdf)])
        wanted = {"Title", "Subject", "Author", "Creator", "Producer", "CreationDate", "ModDate", "Pages", "Page size", "Encrypted", "PDF version"}
        for line in result.stdout.splitlines():
            key = line.split(":", 1)[0]
            if key in wanted:
                print(line)


def compile_pattern(raw: str, literal: bool) -> re.Pattern[str]:
    try:
        return re.compile(re.escape(raw) if literal else raw, re.IGNORECASE)
    except re.error as error:
        raise SystemExit(f"Invalid regular expression: {error}")


def merge_ranges(indices: list[int], context: int, line_count: int) -> list[tuple[int, int]]:
    ranges: list[tuple[int, int]] = []
    for index in indices:
        start = max(0, index - context)
        end = min(line_count, index + context + 1)
        if ranges and start <= ranges[-1][1]:
            ranges[-1] = (ranges[-1][0], max(ranges[-1][1], end))
        else:
            ranges.append((start, end))
    return ranges


def command_query(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf)
    pattern = compile_pattern(args.query, args.literal)
    emitted = 0
    characters = 0
    truncated = False

    for page in range(1, manifest["pages"] + 1):
        normal = page_file(directory, page)
        ocr = page_file(directory, page, "ocr-pages")
        normal_text = normal.read_text(encoding="utf-8", errors="replace")
        source = ocr if len(normal_text.strip()) < 40 and ocr.is_file() else normal
        text = source.read_text(encoding="utf-8", errors="replace") if source == ocr else normal_text
        lines = text.splitlines()
        matches = [index for index, line in enumerate(lines) if pattern.search(line)]
        for start, end in merge_ranges(matches, args.context, len(lines)):
            block = f"--- PDF page {page}, lines {start + 1}-{end} ({source.parent.name}) ---\n"
            block += "\n".join(f"{number + 1}: {lines[number]}" for number in range(start, end)) + "\n"
            if emitted >= args.max_results or characters + len(block) > args.max_chars:
                truncated = True
                break
            print(block, end="")
            emitted += 1
            characters += len(block)
        if truncated:
            break

    if emitted == 0:
        print("No matches.")
        if manifest["likely_scanned"]:
            print("PDF has little extractable text. OCR selected likely pages.")
    elif truncated:
        print(f"[Truncated after {emitted} excerpt(s), {characters} characters. Tighten query or raise limits explicitly.]")


def valid_page(page: int, manifest: dict) -> None:
    if page < 1 or page > manifest["pages"]:
        raise SystemExit(f"Page must be 1..{manifest['pages']}")


def command_page(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf)
    valid_page(args.page, manifest)
    normal = page_file(directory, args.page)
    ocr = page_file(directory, args.page, "ocr-pages")
    selected = ocr if args.ocr and ocr.is_file() else normal
    print(selected)


def render_page(pdf: Path, directory: Path, page: int, dpi: int) -> Path:
    need("pdftoppm")
    images = directory / "images"
    images.mkdir(exist_ok=True)
    prefix = images / f"page-{page:04d}-{dpi}dpi"
    output = Path(f"{prefix}.png")
    if not output.is_file():
        result = run([
            "pdftoppm", "-f", str(page), "-l", str(page), "-singlefile",
            "-r", str(dpi), "-png", str(pdf), str(prefix),
        ])
        if result.returncode != 0:
            raise SystemExit(f"pdftoppm failed: {(result.stderr or result.stdout).strip()}")
    return output


def command_render(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf)
    valid_page(args.page, manifest)
    print(render_page(pdf, directory, args.page, args.dpi))


def command_ocr(args: argparse.Namespace) -> None:
    pdf = resolve_pdf(args.pdf)
    directory, manifest = build_index(pdf)
    valid_page(args.page, manifest)
    need("tesseract")
    image = render_page(pdf, directory, args.page, args.dpi)
    output_dir = directory / "ocr-pages"
    output_dir.mkdir(exist_ok=True)
    output = page_file(directory, args.page, "ocr-pages")
    result = run(["tesseract", str(image), "stdout", "-l", args.language])
    if result.returncode != 0:
        raise SystemExit(f"tesseract failed: {(result.stderr or result.stdout).strip()}")
    output.write_text(result.stdout.rstrip() + "\n", encoding="utf-8")
    print(output)


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(description=__doc__)
    commands = root.add_subparsers(dest="command", required=True)

    index = commands.add_parser("index", help="cache layout-preserving text by physical PDF page")
    index.add_argument("pdf")
    index.add_argument("--force", action="store_true")
    index.set_defaults(handler=command_index)

    info = commands.add_parser("info", help="show compact PDF and cache metadata")
    info.add_argument("pdf")
    info.set_defaults(handler=command_info)

    query = commands.add_parser("query", help="return capped matching excerpts with page and line numbers")
    query.add_argument("pdf")
    query.add_argument("query", help="case-insensitive regular expression")
    query.add_argument("--literal", action="store_true")
    query.add_argument("--context", type=int, default=2)
    query.add_argument("--max-results", type=int, default=8)
    query.add_argument("--max-chars", type=int, default=6000)
    query.set_defaults(handler=command_query)

    page = commands.add_parser("page", help="print cached page-text path without dumping its content")
    page.add_argument("pdf")
    page.add_argument("page", type=int)
    page.add_argument("--ocr", action="store_true", help="prefer existing OCR text")
    page.set_defaults(handler=command_page)

    render = commands.add_parser("render", help="render one physical PDF page to PNG")
    render.add_argument("pdf")
    render.add_argument("page", type=int)
    render.add_argument("--dpi", type=int, default=160, choices=range(72, 301), metavar="72..300")
    render.set_defaults(handler=command_render)

    ocr = commands.add_parser("ocr", help="OCR one physical PDF page")
    ocr.add_argument("pdf")
    ocr.add_argument("page", type=int)
    ocr.add_argument("--dpi", type=int, default=200, choices=range(100, 301), metavar="100..300")
    ocr.add_argument("--language", default="eng")
    ocr.set_defaults(handler=command_ocr)
    return root


def main() -> None:
    args = parser().parse_args()
    if hasattr(args, "context") and args.context < 0:
        raise SystemExit("--context must be non-negative")
    if hasattr(args, "max_results") and args.max_results < 1:
        raise SystemExit("--max-results must be positive")
    if hasattr(args, "max_chars") and args.max_chars < 256:
        raise SystemExit("--max-chars must be at least 256")
    args.handler(args)


if __name__ == "__main__":
    main()
