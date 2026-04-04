#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[vscode] Installing VS Code settings..."

# Determine VS Code config directory per OS
case "$(uname -s)" in
  Darwin)
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    ;;
  Linux)
    VSCODE_DIR="$HOME/.config/Code/User"
    ;;
  *)
    echo "[vscode] Unsupported OS: $(uname -s). Use install.ps1 on Windows."
    exit 1
    ;;
esac

mkdir -p "$VSCODE_DIR"

for FILE in settings.json keybindings.json; do
  SOURCE="$SCRIPT_DIR/$FILE"
  if [ ! -f "$SOURCE" ]; then
    echo "  Skipping $FILE (not found)"
    continue
  fi
  link_file "$SOURCE" "$VSCODE_DIR/$FILE" "vscode"
done
