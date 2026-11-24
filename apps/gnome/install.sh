#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[gnome] Installing GNOME settings (power / mouse / tiling)..."

# GNOME 以外 (macOS / 他 DE / CI) では何もしない
case "${XDG_CURRENT_DESKTOP:-}" in
  *GNOME*|*Unity*) ;;
  *)
    echo "[gnome] Not a GNOME session (XDG_CURRENT_DESKTOP='${XDG_CURRENT_DESKTOP:-}'). Skipped."
    exit 0
    ;;
esac

if ! command -v dconf >/dev/null 2>&1; then
  echo "[gnome] dconf not found. Skipped."
  exit 0
fi

# dconf はバイナリ DB なのでシンボリックリンクではなく、settings.ini のキーを 1 つずつ書き込む。
# settings.ini に書かれたキーだけを扱い、他のキーには触れない。
# 今の値と同じキーは書かない。違うキーは、書く前に今の値を退避ファイルに残す。
SETTINGS="$SCRIPT_DIR/settings.ini"

KEYS=()
NEW_VALUES=()
OLD_VALUES=()
section=""
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|'#'*) continue ;;
    '['*']')
      section="${line#[}"
      section="${section%]}"
      ;;
    *=*)
      if [ -z "$section" ]; then
        echo "[gnome] Key outside of a section in $SETTINGS: $line" >&2
        exit 1
      fi
      key="/$section/${line%%=*}"
      new="${line#*=}"
      old="$(dconf read "$key")"
      if [ "$old" = "$new" ]; then
        echo "[gnome] OK $key = $new"
        continue
      fi
      KEYS+=("$key")
      NEW_VALUES+=("$new")
      OLD_VALUES+=("$old")
      ;;
  esac
done < "$SETTINGS"

if [ "${#KEYS[@]}" -eq 0 ]; then
  exit 0
fi

for i in "${!KEYS[@]}"; do
  note_change "dconf ${KEYS[$i]}"
  if is_dry_run; then
    echo "[gnome] (dry-run) change ${KEYS[$i]}"
  else
    echo "[gnome] change ${KEYS[$i]}"
  fi
  echo "          current: ${OLD_VALUES[$i]:-(unset; default)}"
  echo "          new:     ${NEW_VALUES[$i]}"
done

if is_dry_run; then
  exit 0
fi

# 今の値を dconf load で戻せる形で残す。未設定だったキーは dconf reset で戻す
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/gnome"
mkdir -p "$STATE_DIR"
BACKUP="$STATE_DIR/dconf-$(date +%Y%m%d%H%M%S).ini"
n=1
while [ -e "$BACKUP" ]; do
  BACKUP="$STATE_DIR/dconf-$(date +%Y%m%d%H%M%S).$n.ini"
  n=$((n + 1))
done
{
  echo "# Values before apps/gnome/install.sh on $(date)"
  echo "# Restore: dconf load / < this file (keys marked unset: dconf reset KEY)"
  for i in "${!KEYS[@]}"; do
    key="${KEYS[$i]}"
    if [ -n "${OLD_VALUES[$i]}" ]; then
      dir="${key%/*}"
      echo ""
      echo "[${dir#/}]"
      echo "${key##*/}=${OLD_VALUES[$i]}"
    else
      echo ""
      echo "# unset: $key"
    fi
  done
} > "$BACKUP"
echo "[gnome] Saved current values to $BACKUP"

for i in "${!KEYS[@]}"; do
  dconf write "${KEYS[$i]}" "${NEW_VALUES[$i]}"
done

echo "[gnome] Wrote ${#KEYS[@]} key(s) from $SETTINGS"
