#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[herdr] Installing herdr config..."

case "$(uname -s)" in
  Darwin|Linux)
    HERDR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
    ;;
  *)
    echo "[herdr] Unsupported OS: $(uname -s). Skipped."
    exit 0
    ;;
esac

mkdir -p "$HERDR_DIR"

# ログ・ソケット・セッション状態が同居するため、ディレクトリではなくファイルをリンクする
link_file "$SCRIPT_DIR/config.toml" "$HERDR_DIR/config.toml" "herdr"
