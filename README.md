# OpenClaw Office Assistant

[中文](README.zh-CN.md) | English

A production-ready OpenClaw skill for reading, extracting, summarizing, and comparing office documents, including PDF, Word, Excel, and PowerPoint files.

## What it does

- Reads common office formats: PDF, DOCX, DOC, XLSX, XLS, PPTX, PPT
- Extracts text from modern Office files with deterministic Python libraries
- Falls back to OCR for scanned PDFs when embedded text is missing
- Returns stable JSON output that agents can summarize or post-process
- Works well for summaries, field extraction, rough structure recovery, and multi-document comparison
- Handles Chinese/English PDFs better when `tesseract-ocr-chi-sim` is installed

## Repository layout

- `SKILL.md` — English skill definition for OpenClaw
- `SKILL.zh-CN.md` — Simplified Chinese version
- `scripts/check_deps.py` — dependency checker
- `scripts/extract_office_text.py` — deterministic extractor
- `references/` — capability notes and troubleshooting guides in English and Chinese

## Supported formats

- PDF
- Word: `.docx`, `.doc`
- Excel: `.xlsx`, `.xls`
- PowerPoint: `.pptx`, `.ppt`

## Quick start

### Install the skill

Minimal install:

```bash
curl -fsSL https://raw.githubusercontent.com/Windrunner20/openclaw-office-assistant/main/scripts/install.sh | bash -s -- --deps minimal
```

Full install:

```bash
curl -fsSL https://raw.githubusercontent.com/Windrunner20/openclaw-office-assistant/main/scripts/install.sh | bash -s -- --deps full --yes
```

Manual copy into an existing OpenClaw workspace:

```bash
git clone https://github.com/Windrunner20/openclaw-office-assistant.git
cd openclaw-office-assistant
./scripts/install.sh --deps minimal
```

### Run the extractor directly

```bash
python3 scripts/extract_office_text.py "/path/to/file.pdf" --json
python3 scripts/extract_office_text.py "/path/to/file.docx" --json
python3 scripts/extract_office_text.py "/path/to/file.xlsx" --json
python3 scripts/extract_office_text.py "/path/to/file.pptx" --json
```

Check dependencies:

```bash
python3 scripts/check_deps.py
```

## Recommended environment

### Required

- `python3`
- Python packages:
  - `pypdf`
  - `python-docx`
  - `openpyxl`
  - `python-pptx`

### Strongly recommended

- `poppler-utils`
- `tesseract-ocr`
- `tesseract-ocr-chi-sim`
- `libreoffice`
- `antiword`
- `catdoc`

## Notes

This project is intentionally text-first. It is strong at extraction and summarization workflows, but it does not try to perfectly preserve layout, chart semantics, or full visual structure.

## License

MIT
