#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/settings.plist"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "[alttab] Not macOS." >&2
  exit 1
fi

# 状態値 (テレメトリ・ウィンドウ位置・アップデータの記録) を落とし、設定値だけを書き出す。
defaults export com.lwouis.alt-tab-macos - | python3 -c '
import plistlib, sys

DROP_PREFIXES = ("MSAppCenter", "MSAC", "NSWindow Frame")
DROP_KEYS = {"SULastCheckTime", "SUHasLaunchedBefore", "SUUpdateGroupIdentifier"}

prefs = plistlib.loads(sys.stdin.buffer.read())
prefs = {k: v for k, v in prefs.items()
         if not k.startswith(DROP_PREFIXES) and k not in DROP_KEYS}
plistlib.dump(prefs, sys.stdout.buffer, sort_keys=True)
' > "$OUT"

echo "[alttab] Wrote $OUT"
