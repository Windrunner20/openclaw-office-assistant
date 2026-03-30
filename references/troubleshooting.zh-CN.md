# 排障指南

当提取结果很弱、为空或失败时，使用这个文档。

## 快速依赖检查

优先使用：

```bash
python3 {skill_dir}/scripts/check_deps.py
```

必要时也可以手动检查：

### Python 包

```bash
python3 - <<'PY'
import importlib
mods = ["pypdf", "docx", "openpyxl", "pptx"]
for m in mods:
    try:
        importlib.import_module(m)
        print(f"OK {m}")
    except Exception as e:
        print(f"MISS {m}: {e}")
PY
```

### 系统工具

```bash
command -v pdftoppm || true
command -v tesseract || true
command -v libreoffice || true
command -v antiword || true
command -v catdoc || true
```

### Tesseract 语言包

```bash
tesseract --list-langs
```

确认至少能看到：
- `chi_sim`
- `eng`

## 常见问题

### 1. PDF 几乎提不出文字
常见原因：
- 扫描版 PDF，没有内嵌文字层
- 缺 `pdftoppm`
- 缺 `tesseract`
- 缺 OCR 语言包

处理方式：
- 安装 `poppler-utils`
- 安装 `tesseract-ocr`
- 中文 PDF 再安装 `tesseract-ocr-chi-sim`
- 重新提取

### 2. 中文 OCR 效果差
常见原因：
- 没装 `chi_sim`
- 扫描质量差
- 页面旋转
- 对比度低或字号太小

处理方式：
- 检查 `tesseract --list-langs` 是否包含 `chi_sim`
- 明确告知用户 OCR 质量受原始扫描质量限制

### 3. 老 `.doc` 文件失败
常见原因：
- 缺 `antiword`
- 缺 `catdoc`
- 缺 `libreoffice`

处理方式：
- 安装 `antiword`
- 安装 `catdoc`
- 安装 `libreoffice`
- 重试

### 4. 老 `.xls` 或 `.ppt` 文件失败
常见原因：
- 缺 `libreoffice`

处理方式：
- 安装 `libreoffice`
- 重试

### 5. 表格看起来很乱
这对“文本优先提取”来说是正常现象。
脚本的目标是把内容暴露出来，不是完整重建样式、合并单元格语义或布局。
这时应当用文字解释表格，而不是假装它已经被完美还原。

### 6. 输出被截断
脚本支持 `--max-chars`。
如果输出不够，按需调大重新跑。

## 回复时的实践建议

当提取成功但不完美时：
- 明确哪些内容是直接提取出来的
- 明确哪些部分可能受 OCR 噪声影响
- 不要过度声称确定性

当提取失败时：
- 直接说出缺的依赖或最可能原因
- 给出最小下一步
- 不要臆测文档内容
