" macOS 用 (.vimrc から ~/.vimrc.os として読み込まれる)
" NOTE: 編集中のファイルの隣に .swp を作るとリポジトリの git status に出るため、1か所にまとめる
call mkdir(expand('~/.vim/swap'), 'p')
set directory=~/.vim/swap//

syntax on
filetype plugin indent on
