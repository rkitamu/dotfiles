#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

[ "$(uname -s)" = Linux ] || { echo "[gtk] Linux only. Skipped."; exit 0; }

echo "[gtk] Installing user gtk.css (gtk-3.0 / gtk-4.0)..."
for v in gtk-3.0 gtk-4.0; do
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/$v"
  link_file "$SCRIPT_DIR/$v.css" "${XDG_CONFIG_HOME:-$HOME/.config}/$v/gtk.css" "gtk/$v"
done
