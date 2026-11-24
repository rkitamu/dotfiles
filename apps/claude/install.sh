#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../../lib/common.sh
source "$SCRIPT_DIR/../../lib/common.sh"

echo "[claude] Installing Claude Code user CLAUDE.md..."
# ~/.claude にはセッションの履歴や認証情報が同居するので、ファイルだけをリンクする
link_file "$SCRIPT_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" "claude"
