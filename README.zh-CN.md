# OpenClaw Office Assistant

[English](README.md) | 简体中文

一个正式可发布的 OpenClaw AgentSkill，用于读取、提取、总结、比较 Office 文档，包括 PDF、Word、Excel 和 PowerPoint。

## 能做什么

- 读取常见办公文档格式：PDF、DOCX、DOC、XLSX、XLS、PPTX、PPT
- 使用确定性 Python 库提取现代 Office 文件文本
- 当 PDF 没有内嵌文字层时，自动回退到 OCR
- 输出稳定的 JSON 结构，方便 agent 继续总结或结构化处理
- 适合做摘要、字段提取、结构梳理、多文档对比
- 安装 `tesseract-ocr-chi-sim` 后，对中英 PDF 的处理更稳

## 仓库结构

- `SKILL.md` — OpenClaw 英文技能定义
- `SKILL.zh-CN.md` — 简体中文版本
- `scripts/check_deps.py` — 依赖检查脚本
- `scripts/extract_office_text.py` — 确定性文本提取脚本
- `references/` — 中英双语能力边界与排障文档

## 支持格式

- PDF
- Word：`.docx`、`.doc`
- Excel：`.xlsx`、`.xls`
- PowerPoint：`.pptx`、`.ppt`

## 快速开始

### 一键安装这个 skill

最小依赖安装：

```bash
curl -fsSL https://raw.githubusercontent.com/Windrunner20/openclaw-office-assistant/main/scripts/install.sh | bash -s -- --deps minimal
```

完整依赖安装：

```bash
curl -fsSL https://raw.githubusercontent.com/Windrunner20/openclaw-office-assistant/main/scripts/install.sh | bash -s -- --deps full --yes
```

如果已经有 OpenClaw 工作区，也可以手动 clone 后安装：

```bash
git clone https://github.com/Windrunner20/openclaw-office-assistant.git
cd openclaw-office-assistant
./scripts/install.sh --deps minimal
```

### 直接运行提取脚本

```bash
python3 scripts/extract_office_text.py "/path/to/file.pdf" --json
python3 scripts/extract_office_text.py "/path/to/file.docx" --json
python3 scripts/extract_office_text.py "/path/to/file.xlsx" --json
python3 scripts/extract_office_text.py "/path/to/file.pptx" --json
```

检查依赖：

```bash
python3 scripts/check_deps.py
```

## 推荐环境

### 必需

- `python3`
- Python 包：
  - `pypdf`
  - `python-docx`
  - `openpyxl`
  - `python-pptx`

### 强烈建议

- `poppler-utils`
- `tesseract-ocr`
- `tesseract-ocr-chi-sim`
- `libreoffice`
- `antiword`
- `catdoc`

## 说明

这个项目刻意采用“文本优先”定位。它擅长做提取和总结流程，但不追求 100% 还原原始排版、图表语义或复杂视觉结构。

## 许可证

MIT
