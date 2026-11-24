#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/settings.plist"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "[alttab] Not macOS." >&2
  exit 1
fi

# 状態値を落とし、設定値だけを書き出す (filter.py)
defaults export com.lwouis.alt-tab-macos - | python3 -I "$SCRIPT_DIR/filter.py" > "$OUT"

echo "[alttab] Wrote $OUT"
