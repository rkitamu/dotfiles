# =============================================================================
# zsh configuration
#
# 方針: 外部ツールに依存しない。fzf / eza / bat / zoxide / starship などは
#       「インストールされていれば自動で有効化」し、無くても素の zsh で動く。
# =============================================================================

# 対話シェル以外では何もしない
[[ -o interactive ]] || return

# -----------------------------------------------------------------------------
# 基本の環境変数
# -----------------------------------------------------------------------------
export LANG="${LANG:-en_US.UTF-8}"
export EDITOR=vim
export VISUAL="$EDITOR"
export PAGER=less
export LESS='-R -i -M -S -w -z-4'
export LESSHISTFILE=-

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# PATH は重複を自動で除去する
typeset -U path PATH
path=(
  "$HOME/.local/bin"(N)
  "$HOME/bin"(N)
  $path
)

# -----------------------------------------------------------------------------
# 履歴
# -----------------------------------------------------------------------------
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000

setopt share_history          # 複数シェル間で履歴を共有
setopt extended_history       # 実行時刻と所要時間も記録
setopt hist_ignore_all_dups   # 同じコマンドは古い方を捨てる
setopt hist_ignore_space      # 先頭スペースのコマンドは記録しない
setopt hist_reduce_blanks     # 余分な空白を詰めて記録
setopt hist_verify            # 履歴展開は即実行せず一度編集させる
setopt hist_expire_dups_first # 溢れたらまず重複から捨てる
setopt hist_no_store          # history コマンド自体は残さない

# -----------------------------------------------------------------------------
# ディレクトリ移動
# -----------------------------------------------------------------------------
setopt auto_cd                # ディレクトリ名だけで cd
setopt auto_pushd             # cd の履歴をスタックに積む
setopt pushd_ignore_dups
setopt pushd_silent
DIRSTACKSIZE=20

# -----------------------------------------------------------------------------
# その他の挙動
# -----------------------------------------------------------------------------
setopt extended_glob          # ~ ^ # を使った高機能グロブ
setopt glob_dots              # ドットファイルもグロブ対象に
setopt numeric_glob_sort      # 連番を数値順で展開
setopt no_nomatch             # マッチしない glob はそのまま渡す (curl 'a?b=c' 対策)
setopt magic_equal_subst      # --opt=~/path の ~ も展開する
setopt interactive_comments   # 対話シェルでも # 以降をコメント扱い
setopt print_eight_bit        # 補完候補の日本語を化けさせない
setopt no_beep
setopt no_flow_control        # Ctrl-S / Ctrl-Q を潰さない
setopt long_list_jobs
unsetopt correct_all          # 勝手なコマンド訂正はしない

# -----------------------------------------------------------------------------
# 補完
# -----------------------------------------------------------------------------
setopt complete_in_word       # カーソル位置で補完
setopt always_to_end          # 補完後はカーソルを末尾へ
setopt auto_menu              # Tab 連打でメニュー選択
setopt auto_param_slash       # ディレクトリ補完に / を付ける
setopt auto_param_keys        # 対応する括弧などを自動補完
setopt list_packed            # 候補リストを詰めて表示
unsetopt menu_complete        # 一発で確定させず候補を見せる

fpath=(
  "$XDG_DATA_HOME/zsh/completions"(N)
  $fpath
)

autoload -Uz compinit
_zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
# 24 時間以内に生成済みなら整合性チェックを省いて起動を速くする
if [[ -n "$_zcompdump"(#qN.mh-24) ]]; then
  compinit -C -d "$_zcompdump"
else
  compinit -d "$_zcompdump"
fi
unset _zcompdump

# ls と同じ配色を補完候補にも使う
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
# 小文字→大文字、途中一致、区切り記号の揺れを吸収する
zstyle ':completion:*' matcher-list \
  'm:{a-z-}={A-Z_}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '%F{yellow}%B-- %d --%b%f'
zstyle ':completion:*:messages'     format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:(rm|cp|mv):*' ignore-line other
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:manuals' separate-sections true

# -----------------------------------------------------------------------------
# キーバインド (emacs)
# -----------------------------------------------------------------------------
bindkey -e

# Ctrl-W をパス区切りで止める
WORDCHARS="${WORDCHARS//[\/._-]}"

# 途中まで打ってから ↑↓ / Ctrl-P Ctrl-N で前方一致の履歴検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
bindkey '^[OA' history-beginning-search-backward-end
bindkey '^[OB' history-beginning-search-forward-end

# Home / End / Delete などを端末非依存で効かせる
bindkey '^[[H' beginning-of-line; bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line;       bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word    # Ctrl-Right
bindkey '^[[1;5D' backward-word   # Ctrl-Left

# Ctrl-X Ctrl-E で $EDITOR を開いてコマンドを編集
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# 貼り付けたテキストを勝手に展開させない
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# 空行で Ctrl-Z を押したら直前のジョブを前面に戻す
_foreground-last-job() {
  if [[ -z $BUFFER ]]; then
    BUFFER='fg'
    zle accept-line
  else
    zle push-input
  fi
}
zle -N _foreground-last-job
bindkey '^Z' _foreground-last-job

# -----------------------------------------------------------------------------
# エイリアス
# -----------------------------------------------------------------------------
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto --git --time-style=long-iso'
  alias la='ll --all'
  alias lt='eza --tree --level=2 --group-directories-first --icons=auto'
elif (( $+commands[gls] )); then
  # macOS + coreutils (brew install coreutils)
  alias ls='gls --color=auto --group-directories-first'
  alias ll='ls -lh'
  alias la='ls -lha'
  alias lt='ls -R'
elif command ls --version >/dev/null 2>&1; then
  # GNU coreutils の ls
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -lh'
  alias la='ls -lha'
  alias lt='ls -R'
else
  # BSD の ls (macOS 標準) は --group-directories-first を持たない
  alias ls='ls -G'
  alias ll='ls -lh'
  alias la='ls -lha'
  alias lt='ls -R'
fi

# Debian/Ubuntu の bat は batcat という名前で入る
if (( ! $+commands[bat] )) && (( $+commands[batcat] )); then
  alias bat='batcat'
fi
if (( $+commands[bat] || $+commands[batcat] )); then
  export BAT_THEME='Monokai Extended'
  export MANPAGER="sh -c 'col -bx | ${commands[bat]:-batcat} -l man -p'"
  export MANROFFOPT='-c'
fi

# fd も Ubuntu では fdfind
if (( ! $+commands[fd] )) && (( $+commands[fdfind] )); then
  alias fd='fdfind'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias reload='exec zsh'
alias path='print -l $path'

alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gco='git switch'
alias gb='git branch'
alias gp='git push'
alias gpl='git pull --rebase'

# 拡張子だけで開けるようにする
alias -s {md,txt,json,yml,yaml,toml}=$EDITOR

# MCP Inspector
alias mcpi='npx @modelcontextprotocol/inspector'

# カレントの mcp-inspector.json と最初のサーバーをデフォルトに起動
mcpic() {
  local cfg=${1:-mcp-inspector.json}
  npx @modelcontextprotocol/inspector \
    --config "$cfg" \
    --server "$(jq -r '.mcpServers | keys[0]' "$cfg")"
}

# -----------------------------------------------------------------------------
# 関数
# -----------------------------------------------------------------------------

# ディレクトリを作ってそこへ移動
mkcd() {
  [[ -n $1 ]] || { print -u2 'usage: mkcd <dir>'; return 1 }
  mkdir -p -- "$1" && cd -- "$1"
}

# git リポジトリのルートへ移動
cdg() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    print -u2 'not a git repository'; return 1
  }
  cd -- "$root"
}

# -----------------------------------------------------------------------------
# 外部ツール連携 (入っていれば有効化)
# -----------------------------------------------------------------------------

# fzf: Ctrl-R で履歴、Ctrl-T でファイル、Alt-C でディレクトリ
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS='
    --height 60% --layout=reverse --border=rounded --info=inline
    --prompt="❯ " --pointer="▶" --marker="✓"
    --bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'

  _fzf_find="${commands[fd]:-$commands[fdfind]}"
  if [[ -n $_fzf_find ]]; then
    export FZF_DEFAULT_COMMAND="$_fzf_find --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$_fzf_find --type d --hidden --follow --exclude .git"
  fi
  unset _fzf_find

  if (( $+commands[bat] || $+commands[batcat] )); then
    export FZF_CTRL_T_OPTS="--preview '${commands[bat]:-batcat} --color=always --style=numbers --line-range=:200 {}'"
  fi
  if (( $+commands[eza] )); then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons=auto --color=always {}'"
  fi

  # fzf 0.48+ は自身でキーバインドを出力できる。古い版は配布物を直接読む。
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] &&
      source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] &&
      source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

# zoxide: z / zi で頻度順のディレクトリジャンプ
# cd 自体を置き換えたい場合は `zoxide init zsh --cmd cd`
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# Ubuntu の command-not-found ハンドラ
[[ -f /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# -----------------------------------------------------------------------------
# プラグイン (置かれていれば読み込む / 無くても動く)
#   git clone https://github.com/zsh-users/zsh-autosuggestions \
#     "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions"
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting \
#     "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting"
# -----------------------------------------------------------------------------
_load_plugin() {
  local name="$1" file
  for file in \
    "$XDG_DATA_HOME/zsh/plugins/$name/$name.zsh" \
    "/usr/share/$name/$name.zsh" \
    "/usr/share/zsh/plugins/$name/$name.zsh"
  do
    [[ -f $file ]] && { source "$file"; return 0 }
  done
  return 1
}

if _load_plugin zsh-autosuggestions; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  bindkey '^ ' autosuggest-accept   # Ctrl-Space で候補を確定
fi

# syntax-highlighting は他の zle 設定より後に読む必要がある
_load_plugin zsh-syntax-highlighting

# -----------------------------------------------------------------------------
# プロンプト
#   zsh 組み込みの vcs_info だけで組む 2 行プロンプト (外部バイナリ不要)
#
#     ~/dotfiles [main+]
#     ❯
# -----------------------------------------------------------------------------
autoload -Uz vcs_info add-zsh-hook
zmodload zsh/datetime

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true   # 遅い巨大リポジトリでは false に
zstyle ':vcs_info:git:*' stagedstr   '%F{green}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{yellow}+%f'
zstyle ':vcs_info:git:*' formats       ' %F{magenta}[%b%f%c%u%F{magenta}]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}[%b%f|%F{red}%a%f%c%u%F{magenta}]%f'

# 2 秒以上かかったコマンドは所要時間を右プロンプトに出す
_prompt_timer_start() { _prompt_timer=$EPOCHREALTIME }
_prompt_timer_stop() {
  _prompt_elapsed=''
  if (( ${_prompt_timer:-0} )); then
    local -F elapsed=$(( EPOCHREALTIME - _prompt_timer ))
    (( elapsed >= 2 )) && _prompt_elapsed="%F{yellow}$(printf '%.1fs' $elapsed)%f "
    unset _prompt_timer
  fi
}
add-zsh-hook preexec _prompt_timer_start
add-zsh-hook precmd  _prompt_timer_stop
add-zsh-hook precmd  vcs_info

setopt prompt_subst
# SSH 接続時だけ user@host を出す
_prompt_host=''
[[ -n $SSH_CONNECTION ]] && _prompt_host='%F{green}%n@%m%f '

PROMPT='
${_prompt_host}%F{cyan}%~%f${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '
RPROMPT='${_prompt_elapsed}%(1j.%F{8}[%j]%f.)'

# -----------------------------------------------------------------------------
# ローカル上書き (git 管理しない環境固有の設定)
# -----------------------------------------------------------------------------
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# 最後の判定結果を終了ステータスとして残さない (初回プロンプトが赤くなるのを防ぐ)
true
