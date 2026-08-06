#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[alttab] Installing AltTab settings..."

# macOS 専用
if [ "$(uname -s)" != "Darwin" ]; then
  echo "[alttab] Not macOS. Skipped."
  exit 0
fi

if [ ! -f "$SCRIPT_DIR/settings.plist" ]; then
  echo "[alttab] settings.plist not found. Run export.sh first." >&2
  exit 1
fi

# defaults は plist をマージ書き込みするのでリンクではなく import で流し込む
defaults import com.lwouis.alt-tab-macos "$SCRIPT_DIR/settings.plist"

# 起動中なら再起動して反映
if pgrep -xq AltTab; then
  killall AltTab
  open -a AltTab
fi

echo "[alttab] Imported $SCRIPT_DIR/settings.plist"
