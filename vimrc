set nocompatible
set t_Co=256

call pathogen#infect()

filetype plugin indent on

syntax on

let mapleader=","

set nobackup
set autoread
set background=dark
colorscheme solarized

set fileformat=unix
set scrolloff=4
set wildmenu
set wildmode=longest,list
set wildignore+=*.pyc
set ruler
set number
set expandtab
set textwidth=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set nowrap
set backspace=indent,eol,start
set foldmethod=marker
set foldlevel=0
"set clipboard+=unnamed

set whichwrap+=<,>,h,l

set ignorecase
set smartcase
set incsearch
set hlsearch

set magic

set noerrorbells
set novisualbell
set t_vb=

set showmatch
set showcmd

" always show tabline
set showtabline=2

set matchtime=2

set laststatus=2
set statusline=%f%y%m%r%=%-14.(%l,%c%V%)\ %P

set encoding=utf-8

highlight WhiteSpaceEOL ctermbg=red
match WhiteSpaceEOL /\s\+$/

if has("autocmd")
    autocmd FileType python set complete+=k~/.vim/autocomplete/pydiction textwidth=79 commentstring=#\ %s
    autocmd FileType make set noexpandtab
    autocmd FileType gitconfig set noexpandtab
    autocmd FileType objc set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType coffee set tabstop=2 softtabstop=2 shiftwidth=2
endif

" use arrow keys <Up> <Down> to move between
" lines in a wrapped long line
map <Up> gk
map <Down> gj
imap <Up> <C-o>gk
imap <Down> <C-o>gj

imap <C-e> <C-x><C-e>
imap <C-y> <C-x><C-y>

""""""""
" tweaks
""""""""
" save files using sudo
cmap w!! %!sudo tee > /dev/null %

"""""""""""""""""""""""
" plugin configurations
"""""""""""""""""""""""
let g:vimwiki_list = [
\  {'path': '$HOME/Documents/vimwiki', 'path_html': '$HOME/Documents/vimwiki/html'}
\]

" indent guides color setting
hi IndentGuidesOdd ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
let indent_guides_guide_size=1
let indent_guides_start_level=2
let indent_guides_enable_on_vim_startup=1

" taglist
"let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
