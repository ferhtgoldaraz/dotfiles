"=================================================================
" GENERAL
"=================================================================

" should not be necessary, but it may fix obscure issues                                   
set nocompatible

" set encoding to utf-8
" if something breaks, it will be THEIR fault :D
set encoding=utf-8

" enable fileteype detection, use plugin and indent files too
if has('autocmd')
    filetype plugin indent on
endif

" set python runtime executables
let g:python_host_prog = '/Users/Fer/.virtualenvs/neovim/bin/python'
let g:python3_host_prog = '/Users/Fer/.virtualenvs/neovim3/bin/python'

" set true color support
if has('termguicolors')
    set termguicolors
endif

" enable syntax highlighting 
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" use 4 spaces for indentation. A true tab is left unmodified,
" but it would have to be inserted by arcane means
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent

" allow unrestricted backspacing in insert mode
set backspace=indent,start,eol

" highlight current line
set cursorline

" no delay with esc
set ttimeout
set ttimeoutlen=10

" highlight search
set hlsearch

" incremental search, visually see what's matching
set incsearch

" match (e.g. search) case-insensitive unless upper caps are used
set smartcase

" Use <C-L> to clear the highlighting of :set hlsearch.
" It will NOT ovrride Ctrl+l, but prepend :noh, witch in turn
" does NOT disable the search, e.g. pressing n will higlight
" the next occurrence again
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" always draw status line
set laststatus=2

" show line and column, where we are as a percent of the file
set ruler

" copletion for command mode (awesome)
set wildmenu

" autoreload file if change outside vim (collaborative, ssh...)
set autoread

" dont cut long lines with '@" symbols
set display+=lastline

" set history to a higher value
if &history < 10000
  set history=10000
endif

" set number of tabs to something decent
if &tabpagemax < 50
  set tabpagemax=50
endif

" not used in nvim (shada files), persist session stuff
if !empty(&viminfo)
  set viminfo^=!
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" characters used to reperesent tabs and the like (when shown)
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" sesion creation, from sensible vim, not shure
set sessionoptions-=options

" make un-undoable deletions undoable
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" always see one line above/bwlow the cursor
if !&scrolloff
  set scrolloff=1
endif

" not shure, maybe show some context when scrolling horizontally
if !&sidescrolloff
  set sidescrolloff=5
endif

" set line numbers
set relativenumber
set number

" set leader key for own custom keybindings
let mapleader=","

" see what commands are being issued
set showcmd

"=================================================================
" VIM PLUG PLUGINS
"=================================================================

call plug#begin('~/.config/nvim/plugged')

" nice color scheme
Plug 'whatyouhide/vim-gotham'

call plug#end()

"=================================================================
" POST-PLUGIN OPTIONS
"=================================================================

" set color scheme
colorscheme gotham

