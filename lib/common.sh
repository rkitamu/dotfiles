#!/usr/bin/env bash
# Common utility functions for dotfiles installers
#
# 方針:
#   - すでに正しい状態なら何もしない
#   - 既存のファイル・リンク・ディレクトリは消さずに退避する。既存の退避先も上書きしない
#   - 何も削除しない
#   - --dry-run (または DOTFILES_DRY_RUN=1) なら、変更予定を表示するだけで何も書き換えない

DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-0}"
for _arg in "$@"; do
  case "$_arg" in
    -n|--dry-run) DOTFILES_DRY_RUN=1 ;;
  esac
done
unset _arg
export DOTFILES_DRY_RUN

is_dry_run() {
  [ "$DOTFILES_DRY_RUN" = 1 ]
}

# 変更 (予定) を 1 件記録する。ルートの install.sh が件数を集計する
note_change() {
  if [ -n "${DOTFILES_CHANGE_LOG:-}" ]; then
    echo "$1" >> "$DOTFILES_CHANGE_LOG"
  fi
  return 0
}

# 退避先は ${path}.bak。すでにあれば ${path}.bak.<日時>、それもあれば末尾に連番を付ける
backup_path() {
  local path="$1"
  local candidate="${path}.bak"
  if [ -e "$candidate" ] || [ -L "$candidate" ]; then
    local base
    base="${path}.bak.$(date +%Y%m%d%H%M%S)"
    candidate="$base"
    local n=1
    while [ -e "$candidate" ] || [ -L "$candidate" ]; do
      candidate="${base}.${n}"
      n=$((n + 1))
    done
  fi
  echo "$candidate"
}

# 表示用に $HOME を ~ にする
tildify() {
  case "$1" in
    "$HOME"/*) echo "~${1#"$HOME"}" ;;
    *) echo "$1" ;;
  esac
}

describe_path() {
  local path="$1"
  if [ -L "$path" ]; then
    echo "symlink -> $(tildify "$(readlink "$path")")"
  elif [ -d "$path" ]; then
    echo "directory"
  else
    echo "file"
  fi
}

# 既存の path を消さずに退避する
backup_existing() {
  local path="$1"
  local label="$2"
  local bak
  bak="$(backup_path "$path")"
  if is_dry_run; then
    echo "[$label] (dry-run) back up $(tildify "$path") ($(describe_path "$path")) -> $(tildify "$bak")"
    return 0
  fi
  mv -n "$path" "$bak"
  if [ -e "$path" ] || [ -L "$path" ] || { [ ! -e "$bak" ] && [ ! -L "$bak" ]; }; then
    echo "[$label] Failed to back up $path -> $bak" >&2
    return 1
  fi
  echo "[$label] Backed up $(tildify "$path") -> $(tildify "$bak")"
}

# link_file SOURCE TARGET LABEL
#   TARGET -> SOURCE のシンボリックリンクを張る。
#   すでに SOURCE を指していれば何もしない。
#   TARGET に別のもの (ファイル・ディレクトリ・別の場所へのリンク・切れたリンク) があれば退避してから張る。
link_file() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "[$label] OK $(tildify "$target")"
    return 0
  fi

  if [ ! -e "$source" ]; then
    echo "[$label] Source not found: $source" >&2
    return 1
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_existing "$target" "$label"
  fi

  note_change "link $target"
  if is_dry_run; then
    echo "[$label] (dry-run) link $(tildify "$target") -> $(tildify "$source")"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "[$label] Linked $(tildify "$target") -> $(tildify "$source")"
}
