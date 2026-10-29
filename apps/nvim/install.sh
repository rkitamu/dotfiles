#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[nvim] Installing init.lua..."

NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
mkdir -p "$NVIM_DIR"

link_file "$SCRIPT_DIR/init.lua" "$NVIM_DIR/init.lua" "nvim"
