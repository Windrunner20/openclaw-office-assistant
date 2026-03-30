---
name: office-document-assistant
description: 读取、提取、总结、比较 Office 文档，包括 PDF、Word、Excel、PowerPoint。适用于用户上传 .pdf/.doc/.docx/.xls/.xlsx/.ppt/.pptx 后，要求摘要、重点提取、逐页/逐页幻灯片梳理、字段抽取、表格说明或多文档对比的场景。优先使用内置提取脚本保证稳定性；对于没有文字层的 PDF，再回退到 OCR。
---

# Office 文档助手

读取、提取、总结并比较常见办公文档：
- PDF
- Word（`.docx`、`.doc`）
- Excel（`.xlsx`、`.xls`）
- PowerPoint（`.pptx`、`.ppt`）

当用户希望解释、总结、搜索或结构化提取文档内容时，使用这个 skill。

## 何时使用

当用户：
- 上传 `.pdf` / `.doc` / `.docx` / `.xls` / `.xlsx` / `.ppt` / `.pptx`
- 要求总结文档
- 要求抽取日期、金额、联系人、结论、规格、风险、行动项
- 要求逐页 / 逐幻灯片结构梳理
- 想知道某个表格或幻灯片在讲什么
- 在抽取文本后要求对比两份或多份文档

## 何时不适合

不要把这个 skill 描述成高保真版式分析系统。

它**不适合**：
- 精确保留原始版式、格式或分页
- 复杂图表 / 图像 / 设计意图的深度视觉分析
- 带密码或加密文件
- 超重 OCR 的复杂图像理解，仅支持基础文字恢复
- 高级表格公式审计或商业智能级分析
- Office 修订痕迹 / 红线精确重建

## 核心工作流

1. 确认文档路径。
2. 运行内置脚本：
   - `python3 {skill_dir}/scripts/extract_office_text.py <file> --json`
3. 检查 JSON 字段：
   - `type`
   - `extraction`
   - `warning`
   - `truncated`
   - `text`
4. 回复时明确区分：
   - **直接提取出来的内容**
   - **基于提取内容做出的总结 / 推断**
5. 如果提取结果为空或很弱：
   - 对 PDF，先检查 OCR 是否可用
   - 对旧版 Office 格式，检查转换工具
6. 如果用户要摘要，默认输出：
   - 一句话概览
   - 3–8 个关键点
   - 只有在文档里明显存在时再补充日期、人员、风险、数据、结论、联系方式等部分
7. 如果用户要字段提取，优先给结构化字段，而不是长篇 prose。

## 支持格式与策略

### PDF
- 先用 `pypdf` 提取内嵌文字层。
- 如果文字过少，再回退 OCR。
- OCR 优先 `chi_sim+eng`，其次 `chi_sim`，最后 `eng`。
- OCR 依赖 `pdftoppm` 和 `tesseract`。
- 如果环境里有一等 PDF 工具，且任务价值高或涉及多 PDF，可按情况选更合适的工具；否则默认使用本 skill 的脚本。

### Word
- `.docx`：直接提取段落与表格。
- `.doc`：依次尝试 `antiword`、`catdoc`、LibreOffice 转 `.docx`。

### Excel
- 提取工作表名与每个工作表前几行。
- 适合快速理解工作簿结构和核心字段。
- 解释时重点说清每个 sheet 在做什么、关键列、重要数字和明显异常。

### PowerPoint
- 提取形状中的幻灯片文字。
- 如有 speaker notes，一并提取。
- 总结通常应按逐页或主题分组，而不是一股脑原文倾倒。

## 工具与依赖

### 必需运行时
- `python3`

### 必需 Python 包
- `pypdf` — PDF 文字层提取
- `python-docx` — `.docx` 提取
- `openpyxl` — `.xlsx` 提取
- `python-pptx` — `.pptx` 提取

### 可选但强烈建议的系统工具
- `poppler-utils` — 提供 `pdftoppm`，供 PDF OCR 前转图片使用
- `tesseract-ocr` — OCR 引擎
- `tesseract-ocr-chi-sim` — 简体中文 OCR 语言包
- `libreoffice` — 旧版 `.doc` / `.xls` / `.ppt` 转换兜底
- `antiword` — `.doc` 直接提取兜底
- `catdoc` — 补充 `.doc` 直接提取兜底

### 最低可用环境
如果只关心现代文档，最低实用环境为：
- `python3`
- Python 包：`pypdf`、`python-docx`、`openpyxl`、`python-pptx`

### 推荐完整环境
如需现实世界中更稳健的覆盖，请安装：
- `python3`
- Python 包：`pypdf`、`python-docx`、`openpyxl`、`python-pptx`
- 系统工具：`poppler-utils`、`tesseract-ocr`、`tesseract-ocr-chi-sim`、`libreoffice`、`antiword`、`catdoc`

### 依赖检查
可用内置检查器快速查看当前环境缺什么：

```bash
python3 {skill_dir}/scripts/check_deps.py
```

## 常用命令

```bash
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.pdf" --json
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.docx" --json
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.xlsx" --json
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.pptx" --json
```

常用参数：

```bash
# 限制 PDF 扫描 / 提取页数
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.pdf" --page-limit 10 --json

# 限制表格每个 sheet 读取的行数
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.xlsx" --row-limit 30 --json

# 限制输出文本长度
python3 {skill_dir}/scripts/extract_office_text.py "/path/to/file.pdf" --max-chars 30000 --json
```

## 输出风格

默认用紧凑回答：
- **一句话摘要**
- **3–8 个关键点**
- 只有用户明确需要时，再展开：
  - 详细总结
  - 逐页 / 逐幻灯片说明
  - 字段抽取
  - 文档对比

## 失败处理

- 如果 PDF 文本为空，优先怀疑扫描件或 OCR 依赖缺失。
- 如果中文 OCR 差，检查是否安装了 `tesseract-ocr-chi-sim`。
- 如果 `.doc` / `.xls` / `.ppt` 提取失败，检查 `libreoffice`、`antiword`、`catdoc`。
- 如果表格很乱，要明确说明这是“文本优先提取”，不是完整版式重建。
- 如果文件加密或不可读，直接说明，不要猜。

## 参考资料

只有在需要时再读：
- `references/capabilities.md` — 能力边界与适用范围
- `references/troubleshooting.md` — 依赖排查与常见故障
