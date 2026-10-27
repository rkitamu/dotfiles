#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$SCRIPT_DIR/settings.ini"

# 管理対象のサブツリー。settings.ini のセクションと揃えること。
PATHS=(
  /org/gnome/settings-daemon/plugins/power/
  /org/gnome/desktop/session/
  /org/gnome/desktop/peripherals/mouse/
)

# 拡張機能の設定は必要なキーだけを管理する。
KEYS=(
  /org/gnome/shell/extensions/tiling-assistant/toggle-maximize-tophalf-timer
)

if ! command -v dconf >/dev/null 2>&1; then
  echo "[gnome] dconf not found." >&2
  exit 1
fi

{
  echo "# GNOME settings (power / mouse / tiling)"
  echo "#"
  echo "# このファイルは apps/gnome/export.sh の生成物。直接編集しないこと。"
  echo "# 値を変えるときは GNOME の設定 UI か gsettings で変更してから export.sh を実行する。"
  echo "# 各キーの意味は README.md の gnome セクションを参照。"
  echo "#"
  echo "# 反映: bash apps/gnome/install.sh"

  for p in "${PATHS[@]}"; do
    body="$(dconf dump "$p" | tail -n +2)"   # 先頭の "[/]" 行を落とす
    [ -n "$body" ] || continue
    echo ""
    # /org/gnome/.../ -> [org/gnome/...]
    section="${p#/}"
    echo "[${section%/}]"
    printf '%s\n' "$body"
  done
  for key in "${KEYS[@]}"; do
    value="$(dconf read "$key")"
    [ -n "$value" ] || continue
    section="${key%/*}"
    echo ""
    echo "[${section#/}]"
    printf '%s=%s\n' "${key##*/}" "$value"
  done
} > "$OUT"

echo "[gnome] Wrote $OUT"
