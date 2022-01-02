" Basic {{{
let &t_ut=''
filetype plugin indent on
syntax on
set encoding=utf-8
set shell=/bin/bash
set updatetime=300

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
set whichwrap+=<,>,h,l
" }}}

" Split {{{
set splitright
" }}}
" Display Preferences {{{
set background=light
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
nnoremap <silent> <leader>bl :set background=light<cr>

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
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
if has("autocmd")
    autocmd FileType python set complete+=k~/.vim/autocomplete/pydiction textwidth=79 commentstring=#\ %s
    autocmd FileType python match ErrorMsg '\%>79v.\+'
    autocmd FileType python nnoremap gd /\<\(def\\|class\) <C-r><C-w>\><cr>
    autocmd FileType make set noexpandtab
    autocmd FileType gitconfig set noexpandtab
    autocmd FileType objc,coffee,html,css,scss,ruby,eruby,yaml set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType lisp let b:delimitMate_quotes = "\""
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.go set filetype=go
    autocmd FileType go nnoremap <C-w>x <C-w>v:GoAlternate<cr>
    autocmd BufWritePre *.py :call <SID>StripTrailingWhitespaces()
    autocmd FileType beancount nnoremap <leader>. :AlignCommodity<CR>
    autocmd FileType beancount vnoremap <leader>. :AlignCommodity<CR>
endif
" }}}
" Tweaks {{{

" save files using sudo
cnoremap w!! %!sudo tee > /dev/null %

" }}}
" plugin configurations {{{
call plug#begin()

Plug 'ervandew/supertab'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'windwp/nvim-autopairs'
Plug 'vim-scripts/YankRing.vim'
Plug 'vim-airline/vim-airline'
Plug 'tmhedberg/SimpylFold'
Plug 'altercation/vim-colors-solarized'
Plug 'wwwjfy/numbered-tabline'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'jlanzarotta/bufexplorer'
Plug 'ruanyl/vim-gh-line'
Plug 'tpope/vim-fugitive'
Plug 'nathangrigg/vim-beancount'

" FileType
Plug 'aliva/vim-fish'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'vim-syntastic/syntastic'
Plug 'keith/swift.vim'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'

call plug#end()

colorscheme solarized

" indent guides color setting
hi IndentGuidesOdd ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
let indent_guides_guide_size=1
let indent_guides_start_level=2
let indent_guides_enable_on_vim_startup=1

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 0

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
                           \ 'active_filetypes': ['python', 'terraform'],
                           \ 'passive_filetypes': []}
let g:syntastic_python_checkers = ['pyflakes']

let g:UltiSnipsSnippetDirectories = ["ultisnips"]
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:yankring_replace_n_pkey = ''
let g:yankring_history_dir = '$HOME/.vim'
nnoremap <silent> <F2> :YRShow<CR>

let g:delimitMate_expand_cr = 1

let g:SimpylFold_fold_docstring = 0

if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif
cnoreabbrev Ack Ack!
nnoremap <Leader>a. :Ack!<Space>
nnoremap <Leader>ad :Ack!<Space><Space>%:p:h<left><left><left><left><left><left>

"let g:AutoPairsShortcutToggle = ''

set rtp+=/usr/local/opt/fzf
nmap <C-p> :Files<cr>
nnoremap <M-p> :Files %:h<cr>
let g:fzf_preview_window = ''

let g:go_def_mapping_enabled = 0
let g:go_imports_autosave = 0
let g:go_gopls_enabled = 0

let g:terraform_completion_keys = 1
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_registry_module_completion = 0

let g:rustfmt_autosave = 1

let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'

lua <<EOF
require('nvim-autopairs').setup({
    fast_wrap = {},
})
EOF

" }}}
" Tab {{{
function! s:PreviousTab_StoreState()
    let s:tab_current = tabpagenr()
    let s:tab_last = tabpagenr('$')
endfunction
function! s:PreviousTab_TabClosed()
    if s:tab_current > 1 && s:tab_current < s:tab_last
        exec 'tabp'
    endif
endfunction
autocmd TabEnter,TabLeave * call s:PreviousTab_StoreState()
autocmd TabClosed * call s:PreviousTab_TabClosed()
" }}}
" LSP {{{
lua <<EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gdd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gdt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gds', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>vsplit | lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'cn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    })
end


nvim_lsp.gopls.setup{
  on_attach = on_attach,
}

local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false,
    completeopt = "menu,noselect",
    keyword_length = 2,
  },
  preselect = "none",
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
  }
}

_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.on_text_changed = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  if string.sub(line, cursor[2], cursor[2]) == "." then
    cmp.complete()
  end
end
EOF
autocmd TextChanged,TextChangedI,TextChangedP * call luaeval('vimrc.cmp.on_text_changed()')
" }}}
