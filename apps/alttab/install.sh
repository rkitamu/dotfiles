#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

DOMAIN=com.lwouis.alt-tab-macos

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

# 今の設定を export.sh と同じ形にそろえて比べ、同じなら何もしない
CURRENT="$(defaults export "$DOMAIN" - 2>/dev/null | python3 -I "$SCRIPT_DIR/filter.py" 2>/dev/null || true)"
DIFF="$(diff -u --label current <(printf '%s\n' "$CURRENT") --label settings.plist "$SCRIPT_DIR/settings.plist" || true)"
if [ -z "$DIFF" ]; then
  echo "[alttab] OK $DOMAIN"
  exit 0
fi

note_change "defaults import $DOMAIN"
printf '%s\n' "$DIFF" | sed 's/^/          /'
if is_dry_run; then
  echo "[alttab] (dry-run) defaults import $DOMAIN $SCRIPT_DIR/settings.plist"
  if pgrep -xq AltTab; then
    echo "[alttab] (dry-run) AltTab is running: quit before import and reopen after"
  fi
  exit 0
fi

# import の前に、今の domain を丸ごと退避する (戻すときは defaults import DOMAIN FILE)
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/alttab"
mkdir -p "$STATE_DIR"
BACKUP="$STATE_DIR/$DOMAIN-$(date +%Y%m%d%H%M%S).plist"
n=1
while [ -e "$BACKUP" ]; do
  BACKUP="$STATE_DIR/$DOMAIN-$(date +%Y%m%d%H%M%S).$n.plist"
  n=$((n + 1))
done
if defaults export "$DOMAIN" "$BACKUP" 2>/dev/null; then
  echo "[alttab] Saved current settings to $BACKUP"
else
  echo "[alttab] No current settings for $DOMAIN. Nothing to back up."
fi

# 起動中の AltTab は終了時に手元の設定を書き戻しうるので、import より前に終了させる
WAS_RUNNING=0
if pgrep -xq AltTab; then
  WAS_RUNNING=1
  osascript -e 'quit app "AltTab"' >/dev/null 2>&1 || killall AltTab || true
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    pgrep -xq AltTab || break
    sleep 0.5
  done
  if pgrep -xq AltTab; then
    echo "[alttab] AltTab did not quit. Import skipped." >&2
    exit 1
  fi
fi

defaults import "$DOMAIN" "$SCRIPT_DIR/settings.plist"
echo "[alttab] Imported $SCRIPT_DIR/settings.plist"

if [ "$WAS_RUNNING" = 1 ]; then
  open -a AltTab
fi
