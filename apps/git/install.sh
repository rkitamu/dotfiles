#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[git] Installing gitconfig..."
link_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig" "git"

# .gitconfig は ~/personal 配下で ~/.config/git/personal.gitconfig を読む。
# identity を持つ personal.gitconfig は git 管理外なので、無ければ作らずに案内だけする。
PERSONAL_SOURCE="$SCRIPT_DIR/personal.gitconfig"
PERSONAL_TARGET="$HOME/.config/git/personal.gitconfig"
if [ -f "$PERSONAL_SOURCE" ]; then
  link_file "$PERSONAL_SOURCE" "$PERSONAL_TARGET" "git"
else
  echo "[git] $PERSONAL_SOURCE not found. ~/personal 配下では identity が無いためコミットできません。"
  echo "[git]   [user] の name と email を書いた personal.gitconfig をそこに手で置き、install.sh を流し直してください。"
fi
