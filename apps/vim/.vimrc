set number

set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

set termguicolors
" OS 別の設定。install.sh が macos.vimrc を ~/.vimrc.os としてリンクする
if filereadable(expand('~/.vimrc.os'))
  source ~/.vimrc.os
endif
colorscheme habamax
" NOTE: Ghostty の背景透過を活かすため、カラースキームの背景色を外す
highlight Normal guibg=NONE ctermbg=NONE
