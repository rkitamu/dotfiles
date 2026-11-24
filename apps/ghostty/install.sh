#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[ghostty] Installing ghostty config..."

# Ghostty reads the XDG path on both Linux and macOS
case "$(uname -s)" in
  Darwin)
    GHOSTTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
    OS_CONFIG="macos.config"
    ;;
  Linux)
    GHOSTTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
    OS_CONFIG="linux.config"
    ;;
  *)
    echo "[ghostty] Unsupported OS: $(uname -s)."
    exit 1
    ;;
esac

link_file "$SCRIPT_DIR/config" "$GHOSTTY_DIR/config" "ghostty"
# config の `config-file = ?config.os` はリンク先ではなくこのディレクトリ基準で解決される
link_file "$SCRIPT_DIR/$OS_CONFIG" "$GHOSTTY_DIR/config.os" "ghostty"
