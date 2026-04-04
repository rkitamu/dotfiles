#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[git] Installing gitconfig..."
link_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig" "git"
