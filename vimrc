" Basic {{{
set nocompatible
set t_Co=256

call pathogen#infect()

filetype plugin indent on
syntax on
set encoding=utf-8
set shell=/bin/bash

" Input Mode {{{
let mapleader=","
let maplocalleader="\\"
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
set cursorline
set cursorcolumn
set colorcolumn=+0

" always show tabline
set showtabline=2

highlight WhiteSpaceEOL ctermbg=red
call matchadd("WhiteSpaceEOL", "\\s\\+$")

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
nnoremap <Up> gk
nnoremap <Down> gj
vnoremap <Up> gk
vnoremap <Down> gj
inoremap <Up> <C-o>gk
inoremap <Down> <C-o>gj

nnoremap <silent> <leader><space> :noh<cr>

nnoremap <silent> <leader>p m'ggVG"*y''

nnoremap <silent> <C-t> :tabnew<cr>

nnoremap <C-s> :w<cr>
inoremap <C-s> <esc>:w<cr>

" Emacs-compatible keys {{{
cnoremap <C-a> <home>
cnoremap <C-e> <end>
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-k> <C-o>D
inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l
inoremap <C-d> <C-o>x
" }}}

" }}}
" File Type {{{
if has("autocmd")
    autocmd FileType python set complete+=k~/.vim/autocomplete/pydiction textwidth=79 commentstring=#\ %s
    autocmd FileType python match ErrorMsg '\%>79v.\+'
    autocmd FileType python nnoremap gd /\<\(def\\|class\) <C-r><C-w>\><cr>
    autocmd FileType make set noexpandtab
    autocmd FileType gitconfig set noexpandtab
    autocmd FileType objc,coffee,html,css,scss,ruby,eruby set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType lisp let b:delimitMate_quotes = "\""
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.go set filetype=go
endif
" }}}
" Tweaks {{{

" save files using sudo
cnoremap w!! %!sudo tee > /dev/null %

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

let g:airline_powerline_fonts = 1

set runtimepath^=~/.vim/bundle/ctrlp.vim

au VimEnter * RainbowParenthesesActivate
au Syntax * RainbowParenthesesLoadRound

let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_virtualenv = 0
let g:pymode_run = 0
let g:pymode_breakpoint = 0

let g:syntastic_check_on_open = 1
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['python'],
                           \ 'passive_filetypes': []}

let g:UltiSnipsSnippetDirectories = ["ultisnips"]
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:yankring_replace_n_pkey = ''
let g:yankring_history_dir = '$HOME/.vim'
nnoremap <silent> <F2> :YRShow<CR>

let g:delimitMate_expand_cr = 1

" }}}
