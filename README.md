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
- インストーラはシンボリックリンクを張るだけで、ソフトウェアのインストールはしない

## zsh

以下は入っていれば自動でいい感じに有効化される

| ツール | 効果 |
|--------|------|
| `fzf` | Ctrl-R 履歴検索 / Ctrl-T ファイル選択 / Alt-C ディレクトリ移動 |
| `zoxide` | `z` で頻度順のディレクトリジャンプ |
| `eza` | `ls` `ll` `la` `lt` をアイコン + git 状態付きに差し替え |
| `bat` | man ページのシンタックスハイライト、fzf のプレビュー |
| `fd` | fzf の検索バックエンド (`.git` などを除外) |
| `zsh-autosuggestions` | 履歴からのゴーストテキスト補完 (Ctrl-Space で確定) |
| `zsh-syntax-highlighting` | 入力行のシンタックスハイライト |

```bash
# 任意ツール (Ubuntu)
sudo apt install fzf zoxide eza bat fd-find

# 任意プラグイン
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.local/share/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.local/share/zsh/plugins/zsh-syntax-highlighting

# ログインシェルを zsh にする
chsh -s "$(command -v zsh)"
```

環境固有の設定は `~/.zshrc.local` に書けば読み込まれる (git 管理外)。

## vscode

Syncの関係で新しくprofileを作る事
