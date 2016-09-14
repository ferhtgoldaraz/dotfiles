"==========================================================================
" GENERAL
"==========================================================================

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
let g:python_host_prog = '/home/fer/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/fer/.pyenv/versions/neovim3/bin/python'

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

" always see one line above/below the cursor
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

" see what commands are being issued
set showcmd

" set ruler at 80 chars
set colorcolumn=80

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" move by ROW instead of by LINE
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>
vnoremap <Up> g<Up>
vnoremap <Down> g<Down>

" let move by LINE as it would be for ROW
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k
nnoremap g<Up> <Up>
nnoremap g<Down> <Down>
vnoremap g<Up> <Up>
vnoremap g<Down> <Down>

" allow moving past end of line one character's worth
set virtualedit=onemore 

" allow the cursor to be moved from end of line to beginning of next
" when using vim as other editors (with arrow keys)
set whichwrap+=<,>,[,]

"==========================================================================
" MAPPINGS
"==========================================================================

" map leader, this way showcmd works
map <Space> <Leader>
map <Leader><Space> <Leader><Leader>

" bigger key to write commands
nmap <Return> :

" better buffer navigation
nmap <Leader><Up> <C-W><C-K>
nmap <Leader><Left> <C-W><C-H>
nmap <Leader><Down> <C-W><C-J>
nmap <Leader><Right> <C-W><C-L>

"==========================================================================
" VIM PLUG PLUGINS
"==========================================================================

call plug#begin('~/.config/nvim/plugged')

Plug 'whatyouhide/vim-gotham' " color scheme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-easyoperator-line'
Plug 'haya14busa/vim-easyoperator-phrase'
Plug 'godlygeek/tabular'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-endwise'
Plug 'cohama/lexima.vim'
Plug 'rking/ag.vim'
Plug 'Yggdroot/indentLine'
Plug 'tomtom/tcomment_vim'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/deoplete.nvim'

" let vim-airline use powerline patched font symbols
let g:airline_powerline_fonts=1

call plug#end()

" toggle nerdTree
map <Leader>k :NERDTreeToggle<CR>

" use ag instead of ack
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" enable deoplete at startup
let g:deoplete#enable_at_startup=1

"---- options --------------------------------------

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following
" code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting
" a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"----- sync NERTree view to current buffer ------------------------

" " returns true iff is NERDTree open/active
" function! RC:isNTOpen()
"     return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction
"
" " calls NERDTreeFind iff NERDTree is active, current window contains a
" " modifiable file, and we're not in vimdiff
" function! RC:syncTree()
"     if &modifiable && rc:isNTOpen() && strlen(expand('%')) > 0 && !&diff
"         NERDTreeFind
"         wincmd p
"     endif
" endfunction
"
" autocmd BufEnter * call rc:syncTree()

"==========================================================================
" POST-PLUGIN OPTIONS
"==========================================================================

" set color scheme
colorscheme gotham

