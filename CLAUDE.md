# dotfiles

- 構成: アプリごとに `apps/<app>/install.sh` を置き、`lib/common.sh` の `link_file` でシンボリックリンクを張る。ルートの `install.sh` に APPS 一覧。
  - `link_file` は、すでに正しいリンクなら何もしない（`OK` と表示）。別のもの（ファイル、ディレクトリ、別の場所へのリンク、切れたリンク）があれば `.bak` に退避してから張る。`.bak` がすでにあれば `.bak.<日時>`（さらに連番）にし、既存の退避は上書きしない。
  - `bash install.sh --dry-run`（または `DOTFILES_DRY_RUN=1`、個別の `apps/*/install.sh --dry-run` も可）は、退避先・リンク先・変更件数を表示するだけで何も書き換えない。
  - gnome（dconf）と alttab（defaults）はリンクではなく import。違うキーだけを書き、書く前の値を `~/.local/state/dotfiles/<app>/` に残す。
  - git の identity は dotfiles に置かない。`apps/git/.gitconfig` は `useConfigOnly = true` と `~/.gitconfig.local` の include だけを持ち、どこでどの identity を使うかはマシンごとに `~/.gitconfig.local`（dotfiles の外）に書く。
- 編集は dotfiles 側のファイルで行い、リンク先（`~/.config` など）を直接触らない。

## 壊さないための決めごと

dotfiles は環境を壊しやすく、過去にも壊している（main の `install.sh` を流して手元の環境を何度も壊した）。次を守る。

- `install.sh` はリンクを張り替えるので、先に `bash install.sh --dry-run` を流して変更点を確かめてから本番を流す。流したあとに `--dry-run` が `0 change(s)` になることも確かめる。
- `install.sh` は何も削除しない。既存のファイルは `.bak` に退避するだけにする。退避された `.bak` の片付けはユーザーが手で行う（インストーラにも Claude にも消させない）。
  - Windows の `install.ps1`（`lib/common.ps1`）はまだこれに沿っていない（既存の `.bak` を `-Force` で上書きし、`--dry-run` も無い）。
- PR の説明は、ほかのマシン（macOS など）からでも経緯が追えるように丁寧に書く。次を入れる。
  - 背景（なぜ変えるか）
  - 変更点
  - 既存の環境での移行の手順（無ければ「不要」と書く）
  - 検証した範囲と、確かめていない範囲（例: macOS、Windows の `install.ps1`）

## デスクトップテーマ（Ubuntu / GNOME Shell 50 / Dash to Panel v73）

- GTK: `apps/gtk/gtk-3.0.css` と `gtk-4.0.css` → `~/.config/gtk-{3,4}.0/gtk.css`。ヘッダーバーの高さだけ調整（47px → 28px）。
  - GTK3 と GTK4 は CSS パーサが違う（`:root` / `var()` は GTK4 のみ）ので分割している。
  - libadwaita のヘッダーバーの高さは `headerbar > windowhandle > box` の padding とボタンサイズで決まる。`headerbar` の min-height ではない。
  - 検証は `Gtk.CssProvider` でのパースチェックと `Adw.HeaderBar` の実測で行う。
- herdr: `apps/herdr/config.toml` の `[theme.custom]` にグリーン配色。`sidebar_bg` / `active_row_bg` / `selection_bg` は herdr 0.9.0 以上が必要。反映は `herdr server reload-config`。
- 壁紙（dotfiles 外）: `~/Pictures/wallpapers/gen.py <style[:purple|:green]> <seeds...>`。シンボルは `symbols.py` と `symbols/fork/`。現在の壁紙は `hexgrid_green/hexgrid_green-1.png`。
- dotfiles 外で gsettings / dconf のみで設定しているもの: accent-color green、titlebar-font "Ubuntu Sans 11"、Dash to Panel のグラデーション色（dconf）。
