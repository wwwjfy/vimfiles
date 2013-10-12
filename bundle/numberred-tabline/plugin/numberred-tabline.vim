set tabline=%!MyTabLine()

" config, better > 5
let s:MIN_WIDTH_OF_TAB = 10

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
 let filename = bufname(buflist[winnr - 1])
 let label = a:n . ' ' . (filename == '' ? '[No Name]' : fnamemodify(filename, ':t')) . ' '
 if getbufvar(buflist[winnr - 1], '&modified')
     let label .= '[+]'
 endif
 return label
endfunction

