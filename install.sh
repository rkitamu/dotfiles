#!/usr/bin/env bash
# 使い方: bash install.sh [--dry-run]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

echo "=== dotfiles installer ==="
echo "OS: $(uname -s)"
echo "dotfiles: $SCRIPT_DIR"
if is_dry_run; then
  echo "Mode: dry-run (nothing will be changed)"
fi
echo ""

# List of app directories with install scripts
APPS=(git vim nvim vscode ghostty zsh gnome gtk karabiner alttab herdr)

DOTFILES_CHANGE_LOG="$(mktemp "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")"
export DOTFILES_CHANGE_LOG
trap 'rm -f "$DOTFILES_CHANGE_LOG"' EXIT

# macOS の bash 3.2 は set -u で空配列を参照するとエラーになるので文字列で持つ
FAILED=""
for APP in "${APPS[@]}"; do
  INSTALLER="$SCRIPT_DIR/apps/$APP/install.sh"
  if [ -f "$INSTALLER" ]; then
    echo "--- $APP ---"
    # 1 つのアプリが失敗しても残りは続ける。失敗は最後にまとめて報告する
    if ! bash "$INSTALLER"; then
      FAILED="$FAILED $APP"
    fi
    echo ""
  else
    echo "--- $APP --- (skipped: no install.sh found)"
  fi
done

CHANGES="$(wc -l < "$DOTFILES_CHANGE_LOG" | tr -d ' ')"
if is_dry_run; then
  echo "=== Done (dry-run): $CHANGES change(s) planned ==="
else
  echo "=== Done: $CHANGES change(s) ==="
fi

if [ -n "$FAILED" ]; then
  echo "Failed:$FAILED" >&2
  exit 1
fi
