# dotfiles

## Install

### All settings (root installer)

```bash
# Linux / macOS
bash install.sh

# Windows (PowerShell as Administrator)
powershell -ExecutionPolicy Bypass -File install.ps1
```

### Individual app

```bash
# Linux / macOS
bash vscode/install.sh

# Windows (PowerShell as Administrator)
powershell -ExecutionPolicy Bypass -File vscode\install.ps1
```

## Structure

| Directory | Target | Note |
|-----------|--------|------|
| `git/` | `~/.gitconfig` | |
| `vim/` | `~/.vimrc` | |
| `vscode/` | OS-dependent VS Code User dir | |
| `ghostty/` | `~/.config/ghostty/config` | Linux / macOS のみ |
| `zsh/` | `~/.zshrc` | Linux / macOS のみ |
| `hhkb/` | - | HHKB keyboard layout (manual) |

## Note

- Windows ではシンボリックリンク作成に管理者権限が必要
- 既存ファイルがある場合は `.bak` にバックアップされる

## vscode

Syncの関係で新しくprofileを作る事
