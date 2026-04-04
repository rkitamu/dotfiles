#!/usr/bin/env bash
# Common utility functions for dotfiles installers

# link_file SOURCE TARGET LABEL
#   Creates a symbolic link from TARGET -> SOURCE.
#   If TARGET already exists and is not a symlink, backs it up as TARGET.bak.
link_file() {
  local source="$1"
  local target="$2"
  local label="$3"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  Backing up existing $target -> ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -snf "$source" "$target"
  echo "[$label] Linked $target -> $source"
}
