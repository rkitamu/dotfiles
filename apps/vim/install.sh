#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[vim] Installing vimrc..."
link_file "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc" "vim"
# .vimrc は ~/.vimrc.os があれば読み込む
if [ "$(uname -s)" = Darwin ]; then
  link_file "$SCRIPT_DIR/macos.vimrc" "$HOME/.vimrc.os" "vim"
fi
