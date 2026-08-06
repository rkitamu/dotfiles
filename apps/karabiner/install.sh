#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[karabiner] Installing Karabiner-Elements config..."

# macOS 専用
if [ "$(uname -s)" != "Darwin" ]; then
  echo "[karabiner] Not macOS. Skipped."
  exit 0
fi

# GUI が karabiner.json を atomic rename で書き換えるため、ファイル単位のリンクは剥がれる。
# ディレクトリ丸ごとリンクする (automatic_backups は .gitignore 済み)。
link_file "$SCRIPT_DIR/config" "${XDG_CONFIG_HOME:-$HOME/.config}/karabiner" "karabiner"
