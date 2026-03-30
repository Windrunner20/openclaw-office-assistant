#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="office-document-assistant"
TARGET_DIR="${OPENCLAW_SKILL_DIR:-${HOME}/.openclaw/workspace/skills/${SKILL_NAME}}"
DEPS_MODE="minimal"
ASSUME_YES="false"

usage() {
  cat <<'EOF'
Install OpenClaw Office Assistant and optional dependencies.

Usage:
  install.sh [--deps minimal|full|none] [--target-dir DIR] [--yes]

Options:
  --deps minimal|full|none  Dependency set to install (default: minimal)
  --target-dir DIR          Skill installation directory
  --yes                     Non-interactive apt install (-y)
  -h, --help                Show help

Examples:
  ./scripts/install.sh --deps minimal
  ./scripts/install.sh --deps full --yes
  curl -fsSL https://raw.githubusercontent.com/Windrunner20/openclaw-office-assistant/main/scripts/install.sh | bash -s -- --deps minimal
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --deps)
      DEPS_MODE="${2:-}"
      shift 2
      ;;
    --target-dir)
      TARGET_DIR="${2:-}"
      shift 2
      ;;
    --yes)
      ASSUME_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! "$DEPS_MODE" =~ ^(minimal|full|none)$ ]]; then
  echo "Invalid --deps value: $DEPS_MODE" >&2
  exit 2
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

need_cmd python3

install_apt_packages() {
  local packages=("$@")
  [[ ${#packages[@]} -eq 0 ]] && return 0

  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not found; skipping system packages: ${packages[*]}" >&2
    return 0
  fi

  local sudo_cmd=()
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
      sudo_cmd=(sudo)
    else
      echo "Need root or sudo to install system packages: ${packages[*]}" >&2
      return 1
    fi
  fi

  local apt_yes=()
  if [[ "$ASSUME_YES" == "true" ]]; then
    apt_yes=(-y)
  fi

  "${sudo_cmd[@]}" apt-get update
  "${sudo_cmd[@]}" apt-get install "${apt_yes[@]}" "${packages[@]}"
}

install_python_packages() {
  local packages=("$@")
  [[ ${#packages[@]} -eq 0 ]] && return 0
  python3 -m pip install --upgrade "${packages[@]}"
}

copy_skill_files() {
  mkdir -p "$TARGET_DIR"
  cp "$REPO_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
  cp "$REPO_DIR/SKILL.zh-CN.md" "$TARGET_DIR/SKILL.zh-CN.md"
  mkdir -p "$TARGET_DIR/scripts" "$TARGET_DIR/references"
  cp "$REPO_DIR"/scripts/*.py "$TARGET_DIR/scripts/"
  cp "$REPO_DIR"/references/* "$TARGET_DIR/references/"
  chmod +x "$TARGET_DIR"/scripts/*.py || true
}

case "$DEPS_MODE" in
  minimal)
    install_python_packages pypdf python-docx openpyxl python-pptx
    ;;
  full)
    install_python_packages pypdf python-docx openpyxl python-pptx
    install_apt_packages poppler-utils tesseract-ocr tesseract-ocr-chi-sim libreoffice antiword catdoc
    ;;
  none)
    ;;
esac

copy_skill_files

echo
printf 'Installed skill to: %s\n' "$TARGET_DIR"
printf 'Dependency mode: %s\n' "$DEPS_MODE"
printf 'Test command: python3 %s/scripts/check_deps.py\n' "$TARGET_DIR"
