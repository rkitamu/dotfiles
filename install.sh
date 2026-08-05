#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== dotfiles installer ==="
echo "OS: $(uname -s)"
echo ""

# List of app directories with install scripts
APPS=(git vim vscode ghostty zsh gnome)

for APP in "${APPS[@]}"; do
  INSTALLER="$SCRIPT_DIR/apps/$APP/install.sh"
  if [ -f "$INSTALLER" ]; then
    echo "--- $APP ---"
    bash "$INSTALLER"
    echo ""
  else
    echo "--- $APP --- (skipped: no install.sh found)"
  fi
done

echo "=== Done ==="
