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
| `gnome/` | dconf (power / mouse) | GNOME セッションのみ。リンクではなく `dconf load` |
| `karabiner/` | `~/.config/karabiner` | macOS のみ。ディレクトリごとリンク |
| `alttab/` | AltTab (defaults) | macOS のみ。リンクではなく `defaults import` |
| `herdr/` | `~/.config/herdr/config.toml` | Linux / macOS |
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

## gnome

GNOME の設定は dconf (バイナリ DB) にあるためシンボリックリンクできない。
`apps/gnome/settings.ini` をテキストの正として `dconf load` / `dconf dump` でやり取りする。

```bash
bash apps/gnome/install.sh   # settings.ini -> システム
bash apps/gnome/export.sh    # システム -> settings.ini (git diff で確認)
```

`settings.ini` は `export.sh` の生成物なので直接編集しない。値を変えるときは GNOME の
設定 UI か `gsettings` で変更してから `export.sh` を実行する。
対象キーを増やすときは `export.sh` の `PATHS` に追記してから `export.sh` を実行する。

管理対象は以下のみ。他のキーには一切触れない。

| キー | 意味 |
|------|------|
| `settings-daemon/plugins/power/sleep-inactive-ac-type` | 電源接続時の自動サスペンド動作 (`nothing` で無効) |
| `settings-daemon/plugins/power/sleep-inactive-ac-timeout` | 同上のタイムアウト秒数 (`type='nothing'` の間は未使用) |
| `desktop/session/idle-delay` | 画面のブランク表示までの秒数。設定 UI の「電源」パネル内 |
| `desktop/peripherals/mouse/speed` | ポインタ速度 (-1.0 〜 1.0) |

`dconf dump /` の全体をコミットしないこと。通知許可やウィンドウ位置など、
アプリを起動するたびに増える状態値が混ざって diff が読めなくなる。

## karabiner

GUI が `karabiner.json` を atomic rename で書き換えるため、ファイル単位のリンクは剥がれる。
`~/.config/karabiner` をディレクトリごとリンクしており、GUI での変更はそのままリポジトリの
diff に現れる (`automatic_backups/` は gitignore 済み)。

## alttab

AltTab の設定は defaults (plist) にあるため gnome と同じ export/import 方式。

```bash
bash apps/alttab/install.sh   # settings.plist -> システム (起動中なら AltTab を再起動)
bash apps/alttab/export.sh    # システム -> settings.plist (git diff で確認)
```

`settings.plist` は `export.sh` の生成物なので直接編集しない。AltTab の設定 UI で変更して
から `export.sh` を実行する。テレメトリ・ウィンドウ位置・アップデータ記録などの状態値は
export 時に除外される。

## vscode

Syncの関係で新しくprofileを作る事
