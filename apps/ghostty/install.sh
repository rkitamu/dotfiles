#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[ghostty] Installing ghostty config..."

# Ghostty reads the XDG path on both Linux and macOS
case "$(uname -s)" in
  Darwin|Linux)
    GHOSTTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
    ;;
  *)
    echo "[ghostty] Unsupported OS: $(uname -s)."
    exit 1
    ;;
esac

mkdir -p "$GHOSTTY_DIR"

link_file "$SCRIPT_DIR/config" "$GHOSTTY_DIR/config" "ghostty"
