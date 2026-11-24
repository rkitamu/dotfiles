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

# ログ・ソケット・セッション状態が同居するため、ディレクトリではなくファイルをリンクする
link_file "$SCRIPT_DIR/config.toml" "$HERDR_DIR/config.toml" "herdr"

# レビュー用プラグイン reviewr。インストール済みならスキップ。
# 導入はネットワークに依存するので、失敗しても設定のリンクは残して警告だけ出す
install_reviewr() {
  if ! command -v herdr >/dev/null 2>&1; then
    echo "[herdr] herdr not found. Plugin reviewr skipped."
    return 0
  fi

  local plugins
  if ! plugins="$(herdr plugin list 2>&1)"; then
    echo "[herdr] WARNING: 'herdr plugin list' failed. Plugin reviewr skipped." >&2
    return 0
  fi

  # パイプにすると pipefail と grep -q の早期終了で誤判定しうるので here-string で渡す
  if grep -q 'persiyanov.reviewr' <<<"$plugins"; then
    echo "[herdr] OK plugin persiyanov.reviewr"
    return 0
  fi

  note_change "herdr plugin install persiyanov/herdr-reviewr"
  if is_dry_run; then
    echo "[herdr] (dry-run) herdr plugin install persiyanov/herdr-reviewr --yes"
    return 0
  fi

  if herdr plugin install persiyanov/herdr-reviewr --yes; then
    echo "[herdr] Installed plugin persiyanov/herdr-reviewr"
  else
    echo "[herdr] WARNING: plugin install failed (network?). Re-run install.sh later." >&2
  fi
}

# 以前と同じく、プラグインの導入を先に行ってから設定をリンクする
install_reviewr

# reviewr の設定はプラグインごとのディレクトリに置く
REVIEWR_DIR="$HERDR_DIR/plugins/config/persiyanov.reviewr"
link_file "$SCRIPT_DIR/reviewr.toml" "$REVIEWR_DIR/config.toml" "herdr"
