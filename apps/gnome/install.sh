#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[gnome] Installing GNOME settings (power / mouse)..."

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

# dconf はバイナリ DB なのでシンボリックリンクではなく load で流し込む。
# settings.ini に書かれたキーだけを上書きし、他のキーには触れない。
dconf load / < "$SCRIPT_DIR/settings.ini"

echo "[gnome] Loaded $SCRIPT_DIR/settings.ini"
