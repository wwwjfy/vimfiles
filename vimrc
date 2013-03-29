" Basic {{{
set nocompatible
set t_Co=256

call pathogen#infect()

filetype plugin indent on
syntax on
set encoding=utf-8

" Input Mode {{{
let mapleader=","
set nobackup
set autoread
set fileformat=unix
set expandtab
set autoindent
set backspace=indent,eol,start
set foldmethod=marker
set foldlevel=0
"set clipboard+=unnamed
set whichwrap+=<,>,h,l
" }}}
" Display Preferences {{{
set background=dark
colorscheme solarized
set scrolloff=4
set ruler
set number
set textwidth=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set nowrap
set showmatch
set showcmd

" always show tabline
set showtabline=2

highlight WhiteSpaceEOL ctermbg=red
match WhiteSpaceEOL /\s\+$/

" avoid "Press ENTER or type command to continue"
set cmdheight=2

set matchtime=2
set laststatus=2
" set statusline=%f%y%m%r%=%-14.(%l,%c%V%)\ %P
" }}}
" Command Mode {{{
set wildmenu
set wildmode=longest,list
set wildignore+=*.pyc
" }}}
" Search {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set magic
" }}}
" Bell {{{
set noerrorbells
set novisualbell
set t_vb=
" }}}

" }}}
" Mapping {{{
" use arrow keys <Up> <Down> to move between
" lines in a wrapped long line
map <Up> gk
map <Down> gj
imap <Up> <C-o>gk
imap <Down> <C-o>gj

" Emacs-compatible keys {{{
cnoremap <C-a> <home>
cnoremap <C-e> <end>
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A
inoremap <C-k> <esc>lC
" }}}

" }}}
" File Type {{{
if has("autocmd")
    autocmd FileType python set complete+=k~/.vim/autocomplete/pydiction textwidth=79 commentstring=#\ %s
    autocmd FileType make set noexpandtab
    autocmd FileType gitconfig set noexpandtab
    autocmd FileType objc,coffee,html,css,scss,ruby,eruby set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.go set filetype=go
endif
" }}}
" Tweaks {{{

" save files using sudo
cmap w!! %!sudo tee > /dev/null %

" }}}
" plugin configurations {{{

let g:vimwiki_list = [
\  {'path': '$HOME/Documents/vimwiki', 'path_html': '$HOME/Documents/vimwiki/html'}
\]

" indent guides color setting
hi IndentGuidesOdd ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
let indent_guides_guide_size=1
let indent_guides_start_level=2
let indent_guides_enable_on_vim_startup=1

let g:Powerline_symbols = 'fancy'

" taglist
"let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"

set runtimepath^=~/.vim/bundle/ctrlp.vim

" }}}
