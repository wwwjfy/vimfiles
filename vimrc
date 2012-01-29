set nocompatible
set t_Co=256

call pathogen#infect()

filetype plugin indent on
" enable mouse only in normal mode
" set mouse=n

syntax on

let mapleader=","

set nobackup
set autoread
set background=dark
color solarized

set ff=unix
set so=4
set wildmenu
set wildmode=longest,list
set wildignore+=*.pyc
set ruler
set nu
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

set ignorecase smartcase
set incsearch

set magic

set noerrorbells
set novisualbell
set t_vb=

set showmatch
set showcmd

set mat=2

set hlsearch

set laststatus=2
"set statusline=%F%y%m%r

set enc=utf-8

if has("autocmd")
    autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4 complete+=k~/.vim/autocomplete/pydiction textwidth=79 commentstring=#\ %s
    autocmd FileType make set noexpandtab
    autocmd FileType gitconfig set noexpandtab
    autocmd FileType objc set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType coffee set tabstop=2 softtabstop=2 shiftwidth=2
endif

" use Ctrl+j/h/k/l to move the cursor when editing
imap <C-h> <C-o>h
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l

map <Up> gk
map <Down> gj
imap <Up> <C-o>gk
imap <Down> <C-o>gj

" save when insert or not, for <C-s> does not work for some unknown reason.
" not work in Mac
"map <F2> <Esc>:w<CR>
"imap <F2> <Esc><F2>

imap <C-e> <C-x><C-e>
imap <C-y> <C-x><C-y>

" vimwiki start
let g:vimwiki_list = [
\	{'path': '$HOME/Documents/vimwiki', 'path_html': '$HOME/Documents/vimwiki/html'}
\]

" indent guides color setting
hi IndentGuidesOdd ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
let indent_guides_guide_size=1
let indent_guides_start_level=2
let indent_guides_enable_on_vim_startup=1

" show page number on tab line
set showtabline=2
set tabline=%!MyTabLine()

function MyTabLine1()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' ' . (i + 1) . ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLine#%999Xclose'
  " endif

  return s
endfunction

"function MyTabLabel(n)
"  let buflist = tabpagebuflist(a:n)
"  let winnr = tabpagewinnr(a:n)
"  let label = bufname(buflist[winnr - 1])
"  for bufnr in buflist
"      if getbufvar(bufnr, '&modified')
"          let label .= ' [+]'
"      endif
"  endfor
"  return label
"endfunction
"function MyTabLine()
" let nr_current = tabpagenr() - 1
" let nr_total = tabpagenr('$')
" let labels = []
"    for i in range(nr_total)
"        let is_selected = (i==nr_current ? 'Sel' : '')
"        let label = is_selected ? '%#TabLineSel#' : '%#TabLine#'
"        call add(labels, MyTabLabel(i+1))
"    endfor
" let available = &columns - 2 * nr_total - strlen(labels[nr_current])
" " TODO available < 0
" let need = 0
"    for i in range(nr_total)
"        if i != nr_current
"            let need += strlen(labels[i])
"        endif
"    endfor
" let first = 0
" let last = nr_total - 1
"    while need > available && first < last
"        let one = abs(first - nr_current) > abs(nr_current - last) ? first : last
"        if one == nr_current
"            break
"        endif
"        let old_length = strlen(labels[one])
"        let new_length = float2nr(1.0 * old_length * available / need)
"        let labels[one] = strpart(labels[one], 0, new_length)
"        let need -= old_length
"        let available -= new_length
"        if one == first
"            let first += 1
"        else
"            let last -= 1
"        endif
"    endwhile
"
" let s = ''
"    for i in range(nr_total)
"        " select the highlighting
"        let s .= i==nr_current ? '%#TabLineSel#' : '%#TabLine#'
"        let s .= ' ' . labels[i] . ' '
"    endfor
"
" " after the last tab fill with TabLineFill and reset tab page nr
" let s .= '%#TabLineFill#%T'
" return s
"endfunction
"
let s:MIN_WIDTH_OF_TAB = 10 " config, better > 5

function MyTabLine()
    let nr_current = tabpagenr() - 1
    let nr_total = tabpagenr('$')
    let mark_left = ''
    let mark_right = ''
    let labels = []
    let lengths = []
    let total_length = 0
    let flexibility = 0 " how many cols can get if shrink all tabs to min
    let flexible = [] " index of tabs that can be shrinked
    for i in range(nr_total)
        let label = MyTabLabel(i+1)
        call add(labels, label)
        let length = len(label)
        call add(lengths, length)
        let total_length += length
        if length > s:MIN_WIDTH_OF_TAB
            let flexibility += length - s:MIN_WIDTH_OF_TAB
            call add(flexible, i)
        endif
    endfor
    let limits = copy(lengths)
    if total_length <= &columns " can fit in one line
        " do nothing
    elseif total_length - flexibility <= &columns " else shrink some tabs
        let last_width = s:MIN_WIDTH_OF_TAB
        let next_width = last_width + (&columns - total_length + flexibility) / len(flexible)
        let new_flexible = []
        for i in flexible
            let possible = lengths[i]
            if possible <= next_width
                let limits[i] = possible
            else
                let total_length += next_width - limits[i]
                let limits[i] = next_width
                call add(new_flexible, i)
            endif
        endfor
        " expend some of them to use all space
        let flexible = new_flexible
        while total_length < &columns && len(flexible) > 0
            let step = (&columns - total_length) / len(flexible)
            let next_width += step > 0 ? step : 1
            let new_flexible = []
            for i in flexible
                let possible = lengths[i]
                if possible <= next_width
                    let total_length += possible - limits[i]
                    let limits[i] = possible
                else
                    let total_length += next_width - limits[i]
                    let limits[i] = next_width
                    if total_length >= &columns
                        break
                    endif
                    call add(new_flexible, i)
                endif
            endfor
            let flexible = new_flexible
        endwhile
    else " need shrink all tabs and shift the position to show current one
        " first, shrink all tabs to min
        let total_length = 0
        for i in range(nr_total)
            let l = lengths[i]
            if l > s:MIN_WIDTH_OF_TAB
                let l = s:MIN_WIDTH_OF_TAB
            endif
            let limits[i] = l
            let total_length += l
        endfor
        " second, remove some tabs completely
        let first = 0
        let last = nr_total - 1
        while total_length > &columns && first <= last
            let one = abs(first - nr_current) > abs(nr_current - last) ? first : last
            if one == nr_current
                let need = total_length - &columns
                let limits[one] -= need
                let total_length -= need
                break
            endif
            let total_length -= limits[one]
            let limits[one] = 0
            if one == first
                let first += 1
                let total_length += len('<') - len(mark_left)
                let mark_left = '<'
            else
                let last -= 1
                let total_length += len('>') - len(mark_right)
                let mark_right = '>'
            endif
        endwhile
        " third, expand the remain tabs to use all space
        while total_length < &columns && len(flexible) > 0
            let new_flexible = []
            for i in flexible
                if limits[i] == 0 || limits[i] >= lengths[i]
                    continue
                endif
                let limits[i] += 1
                let total_length += 1
                call add(new_flexible, i)
                if total_length >= &columns
                    break
                endif
            endfor
            let flexible = new_flexible
        endwhile
    endif

    let s = '%#TabLine#' . mark_left
    for i in range(nr_total)
        if limits[i] < 4
            continue
        endif
        " select the highlighting
        let s .= i==nr_current ? '%#TabLineSel#' : '%#TabLine#'
        let l = limits[i]
        if l >= lengths[i] - 1
            let s .= strpart(labels[i], 0, l)
        else
            let s .= strpart(labels[i], 0, l-2) . '~ '
        endif
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= len(mark_right) ? '%#TabLine#' . mark_right : '%#TabLineFill#%T'
    return s
endfunction

function MyTabLabel(n)
 let buflist = tabpagebuflist(a:n)
 let winnr = tabpagewinnr(a:n)
 let pathname = bufname(buflist[winnr - 1])
 let label = ' '
 for bufnr in buflist
     if getbufvar(bufnr, '&modified')
         let label = ' [+]'
     endif
 endfor
 let label = a:n . ' ' . fnamemodify(pathname, ':t') . label
 return label
endfunction

