"TODO print messages when on visual mode. I only see VISUAL, not the messages.

" Function interface phylosophy:
"
" - functions take arbitrary line numbers as parameters.
"    Current cursor line is only a suitable default parameter.
"
" - only functions that bind directly to user actions:
"
"    - print error messages.
"       All intermediate functions limit themselves return `0` to indicate an error.
"
"    - move the cursor. All other functions do not move the cursor.
"
" This is how you should view headers:
"
"   |BUFFER
"   |
"   |Outside any header
"   |
" a-+# a
"   |
"   |Inside a
"   |
" a-+
" b-+## b
"   |
"   |inside b
"   |
" b-+
" c-+### c
"   |
"   |Inside c
"   |
" c-+
" d-|# d
"   |
"   |Inside d
"   |
" d-+
" e-|e
"   |====
"   |
"   |Inside e
"   |
" e-+

" For each level, contains the regexp that matches at that level only.
let s:levelRegexpDict = {
    \ 1: '\v^(#[^#]@=|.+\n\=+$)',
    \ 2: '\v^(##[^#]@=|.+\n-+$)',
    \ 3: '\v^###[^#]@=',
    \ 4: '\v^####[^#]@=',
    \ 5: '\v^#####[^#]@=',
    \ 6: '\v^######[^#]@='
\ }

" Maches any header level of any type.
"
" This could be deduced from `s:levelRegexpDict`, but it is more
" efficient to have a single regexp for this.
"
let s:headersRegexp = '\v^(#|.+\n(\=+|-+)$)'

" Returns the line number of the first header before `line`, called the
" current header.
"
" If there is no current header, return `0`.
"
" @param a:1 The line to look the header of. Default value: `getpos('.')`.
"
function! s:Markdown_GetHeaderLineNum(...)
    if a:0 == 0
        let l:l = line('.')
    else
        let l:l = a:1
    endif
    while(l:l > 0)
        if join(getline(l:l, l:l + 1), "\n") =~ s:headersRegexp
            return l:l
        endif
        let l:l -= 1
    endwhile
    return 0
endfunction

" - if inside a header goes to it.
"    Return its line number.
"
" - if on top level outside any headers,
"    print a warning
"    Return `0`.
"
function! s:Markdown_MoveToCurHeader()
    let l:lineNum = s:Markdown_GetHeaderLineNum()
    if l:lineNum != 0
        call cursor(l:lineNum, 1)
    else
        echo 'outside any header'
        "normal! gg
    endif
    return l:lineNum
endfunction

" Move cursor to next header of any level.
"
" If there are no more headers, print a warning.
"
function! s:Markdown_MoveToNextHeader()
    if search(s:headersRegexp, 'W') == 0
        "normal! G
        echo 'no next header'
    endif
endfunction

" Move cursor to previous header (before current) of any level.
"
" If it does not exist, print a warning.
"
function! s:Markdown_MoveToPreviousHeader()
    let l:curHeaderLineNumber = s:Markdown_GetHeaderLineNum()
    let l:noPreviousHeader = 0
    if l:curHeaderLineNumber <= 1
        let l:noPreviousHeader = 1
    else
        let l:previousHeaderLineNumber = s:Markdown_GetHeaderLineNum(l:curHeaderLineNumber - 1)
        if l:previousHeaderLineNumber == 0
            let l:noPreviousHeader = 1
        else
            call cursor(l:previousHeaderLineNumber, 1)
        endif
    endif
    if l:noPreviousHeader
        echo 'no previous header'
    endif
endfunction

" - if line is inside a header, return the header level (h1 -> 1, h2 -> 2, etc.).
"
" - if line is at top level outside any headers, return `0`.
"
function! s:Markdown_GetHeaderLevel(...)
    if a:0 == 0
        let l:line = line('.')
    else
        let l:line = a:1
    endif
    let l:linenum = s:Markdown_GetHeaderLineNum(l:line)
    if l:linenum != 0
        return s:Markdown_GetLevelOfHeaderAtLine(l:linenum)
    else
        return 0
    endif
endfunction

" Returns the level of the header at the given line.
"
" If there is no header at the given line, returns `0`.
"
function! s:Markdown_GetLevelOfHeaderAtLine(linenum)
    let l:lines = join(getline(a:linenum, a:linenum + 1), "\n")
    for l:key in keys(s:levelRegexpDict)
        if l:lines =~ get(s:levelRegexpDict, l:key)
            return l:key
        endif
    endfor
    return 0
endfunction

" Move cursor to parent header of the current header.
"
" If it does not exit, print a warning and do nothing.
"
function! s:Markdown_MoveToParentHeader()
    let l:linenum = s:Markdown_GetParentHeaderLineNumber()
    if l:linenum != 0
        call cursor(l:linenum, 1)
    else
        echo 'no parent header'
    endif
endfunction

" Return the line number of the parent header of line `line`.
"
" If it has no parent, return `0`.
"
function! s:Markdown_GetParentHeaderLineNumber(...)
    if a:0 == 0
        let l:line = line('.')
    else
        let l:line = a:1
    endif
    let l:level = s:Markdown_GetHeaderLevel(l:line)
    if l:level > 1
        let l:linenum = s:Markdown_GetPreviousHeaderLineNumberAtLevel(l:level - 1, l:line)
        return l:linenum
    endif
    return 0
endfunction

" Return the line number of the previous header of given level.
" in relation to line `a:1`. If not given, `a:1 = getline()`
"
" `a:1` line is included, and this may return the current header.
"
" If none return 0.
"
function! s:Markdown_GetNextHeaderLineNumberAtLevel(level, ...)
    if a:0 < 1
        let l:line = line('.')
    else
        let l:line = a:1
    endif
    let l:l = l:line
    while(l:l <= line('$'))
        if join(getline(l:l, l:l + 1), "\n") =~ get(s:levelRegexpDict, a:level)
            return l:l
        endif
        let l:l += 1
    endwhile
    return 0
endfunction

" Return the line number of the previous header of given level.
" in relation to line `a:1`. If not given, `a:1 = getline()`
"
" `a:1` line is included, and this may return the current header.
"
" If none return 0.
"
function! s:Markdown_GetPreviousHeaderLineNumberAtLevel(level, ...)
    if a:0 == 0
        let l:line = line('.')
    else
        let l:line = a:1
    endif
    let l:l = l:line
    while(l:l > 0)
        if join(getline(l:l, l:l + 1), "\n") =~ get(s:levelRegexpDict, a:level)
            return l:l
        endif
        let l:l -= 1
    endwhile
    return 0
endfunction

" Move cursor to next sibling header.
"
" If there is no next siblings, print a warning and don't move.
"
function! s:Markdown_MoveToNextSiblingHeader()
    let l:curHeaderLineNumber = s:Markdown_GetHeaderLineNum()
    let l:curHeaderLevel = s:Markdown_GetLevelOfHeaderAtLine(l:curHeaderLineNumber)
    let l:curHeaderParentLineNumber = s:Markdown_GetParentHeaderLineNumber()
    let l:nextHeaderSameLevelLineNumber = s:Markdown_GetNextHeaderLineNumberAtLevel(l:curHeaderLevel, l:curHeaderLineNumber + 1)
    let l:noNextSibling = 0
    if l:nextHeaderSameLevelLineNumber == 0
        let l:noNextSibling = 1
    else
        let l:nextHeaderSameLevelParentLineNumber = s:Markdown_GetParentHeaderLineNumber(l:nextHeaderSameLevelLineNumber)
        if l:curHeaderParentLineNumber == l:nextHeaderSameLevelParentLineNumber
            call cursor(l:nextHeaderSameLevelLineNumber, 1)
        else
            let l:noNextSibling = 1
        endif
    endif
    if l:noNextSibling
        echo 'no next sibling header'
    endif
endfunction

" Move cursor to previous sibling header.
"
" If there is no previous siblings, print a warning and do nothing.
"
function! s:Markdown_MoveToPreviousSiblingHeader()
    let l:curHeaderLineNumber = s:Markdown_GetHeaderLineNum()
    let l:curHeaderLevel = s:Markdown_GetLevelOfHeaderAtLine(l:curHeaderLineNumber)
    let l:curHeaderParentLineNumber = s:Markdown_GetParentHeaderLineNumber()
    let l:previousHeaderSameLevelLineNumber = s:Markdown_GetPreviousHeaderLineNumberAtLevel(l:curHeaderLevel, l:curHeaderLineNumber - 1)
    let l:noPreviousSibling = 0
    if l:previousHeaderSameLevelLineNumber == 0
        let l:noPreviousSibling = 1
    else
        let l:previousHeaderSameLevelParentLineNumber = s:Markdown_GetParentHeaderLineNumber(l:previousHeaderSameLevelLineNumber)
        if l:curHeaderParentLineNumber == l:previousHeaderSameLevelParentLineNumber
            call cursor(l:previousHeaderSameLevelLineNumber, 1)
        else
            let l:noPreviousSibling = 1
        endif
    endif
    if l:noPreviousSibling
        echo 'no previous sibling header'
    endif
endfunction

function! s:Markdown_Toc(...)
    if a:0 > 0
        let l:window_type = a:1
    else
        let l:window_type = 'vertical'
    endif

    try
        silent lvimgrep /\(^\S.*\(\n[=-]\+\n\)\@=\|^#\+\)/ %
    catch /E480/
        echom "Toc: No headers."
        return
    endtry

    if l:window_type ==# 'horizontal'
        lopen
    elseif l:window_type ==# 'vertical'
        vertical lopen
        let &winwidth=(&columns/2)
    elseif l:window_type ==# 'tab'
        tab lopen
    else
        lopen
    endif
    setlocal modifiable
    for i in range(1, line('$'))
        " this is the location-list data for the current item
        let d = getloclist(0)[i-1]
        " atx headers
        if match(d.text, "^#") > -1
            let l:level = len(matchstr(d.text, '#*', 'g'))-1
            let d.text = substitute(d.text, '\v^#*[ ]*', '', '')
            let d.text = substitute(d.text, '\v[ ]*#*$', '', '')
        " setex headers
        else
            let l:next_line = getbufline(bufname(d.bufnr), d.lnum+1)
            if match(l:next_line, "=") > -1
                let l:level = 0
            elseif match(l:next_line, "-") > -1
                let l:level = 1
            endif
        endif
        call setline(i, repeat('  ', l:level). d.text)
    endfor
    setlocal nomodified
    setlocal nomodifiable
    normal! gg
endfunction

" Wrapper to do move commands in visual mode.
"
function! s:VisMove(f)
    norm! gv
    call function(a:f)()
endfunction

" Map in both normal and visual modes.
"
function! s:MapNormVis(rhs,lhs)
    execute 'nn <buffer><silent> ' . a:rhs . ' :call ' . a:lhs . '()<cr>'
    execute 'vn <buffer><silent> ' . a:rhs . ' <esc>:call <sid>VisMove(''' . a:lhs . ''')<cr>'
endfunction

" Convert Setex headers in range `line1 .. line2` to Atx.
" Returns the number of conversions.
function! s:SetexToAtx(line1, line2)
    let l:originalNumLines = line('$')
    execute 'silent! ' . a:line1 . ',' . a:line2 . 'substitute/\v(.*\S.*)\n\=+$/# \1/'
    execute 'silent! ' . a:line1 . ',' . a:line2 . 'substitute/\v(.*\S.*)\n-+$/## \1/'
    return l:originalNumLines - line('$')
endfunction

" If `a:1` is 0, decrease the level of all headers in range `line1 .. line2`.
" Otherwise, increase the level. `a:1` defaults to `0`.
function! s:HeaderDecrease(line1, line2, ...)
    if a:0 > 0
        let l:increase = a:1
    else
        let l:increase = 0
    endif
    if l:increase
        let l:forbiddenLevel = 6
        let l:replaceLevels = [5, 1]
        let l:levelDelta = 1
    else
        let l:forbiddenLevel = 1
        let l:replaceLevels = [2, 6]
        let l:levelDelta = -1
    endif
    for l:line in range(a:line1, a:line2)
        if join(getline(l:line, l:line + 1), "\n") =~ s:levelRegexpDict[l:forbiddenLevel]
            echomsg 'There is an h' . l:forbiddenLevel . ' at line ' . l:line . '. Aborting.'
            return
        endif
    endfor
    let l:numSubstitutions = s:SetexToAtx(a:line1, a:line2)
    for l:level in range(replaceLevels[0], replaceLevels[1], -l:levelDelta)
        execute 'silent! ' . a:line1 . ',' . (a:line2 - l:numSubstitutions) . 'substitute/' . s:levelRegexpDict[l:level] . '/' . repeat('#', l:level + l:levelDelta) . '/g'
    endfor
endfunction

" Format table under cursor.
" Depends on Tabularize.
function! s:TableFormat()
  let l:pos = getpos('.')
  normal! {
  " Search instead of `normal! j` because of the table at beginning of file edge case.
  call search('|')
  normal! j
  " Remove everything that is not a pipe othewise well formated tables would grow
  " because of addition of 2 spaces on the separator line by Tabularize /|.
  s/[^|]//g
  Tabularize /|
  s/ /-/g
  call setpos('.', l:pos)
endfunction

call <sid>MapNormVis('<Plug>(Markdown_MoveToNextHeader)', '<sid>Markdown_MoveToNextHeader')
call <sid>MapNormVis('<Plug>(Markdown_MoveToPreviousHeader)', '<sid>Markdown_MoveToPreviousHeader')
call <sid>MapNormVis('<Plug>(Markdown_MoveToNextSiblingHeader)', '<sid>Markdown_MoveToNextSiblingHeader')
call <sid>MapNormVis('<Plug>(Markdown_MoveToPreviousSiblingHeader)', '<sid>Markdown_MoveToPreviousSiblingHeader')
" Menmonic: Up
call <sid>MapNormVis('<Plug>(Markdown_MoveToParentHeader)', '<sid>Markdown_MoveToParentHeader')
" Menmonic: Current
call <sid>MapNormVis('<Plug>(Markdown_MoveToCurHeader)', '<sid>Markdown_MoveToCurHeader')

if !get(g:, 'vim_markdown_no_default_key_mappings', 0)
    nmap <buffer> ]] <Plug>(Markdown_MoveToNextHeader)
    nmap <buffer> [[ <Plug>(Markdown_MoveToPreviousHeader)
    nmap <buffer> ][ <Plug>(Markdown_MoveToNextSiblingHeader)
    nmap <buffer> [] <Plug>(Markdown_MoveToPreviousSiblingHeader)
    nmap <buffer> ]u <Plug>(Markdown_MoveToParentHeader)
    nmap <buffer> ]c <Plug>(Markdown_MoveToCurHeader)

    vmap <buffer> ]] <Plug>(Markdown_MoveToNextHeader)
    vmap <buffer> [[ <Plug>(Markdown_MoveToPreviousHeader)
    vmap <buffer> ][ <Plug>(Markdown_MoveToNextSiblingHeader)
    vmap <buffer> [] <Plug>(Markdown_MoveToPreviousSiblingHeader)
    vmap <buffer> ]u <Plug>(Markdown_MoveToParentHeader)
    vmap <buffer> ]c <Plug>(Markdown_MoveToCurHeader)
endif

command! -buffer -range=% HeaderDecrease call s:HeaderDecrease(<line1>, <line2>)
command! -buffer -range=% HeaderIncrease call s:HeaderDecrease(<line1>, <line2>, 1)
command! -buffer -range=% SetexToAtx call s:SetexToAtx(<line1>, <line2>)
command! -buffer TableFormat call s:TableFormat()
command! -buffer Toc call s:Markdown_Toc()
command! -buffer Toch call s:Markdown_Toc('horizontal')
command! -buffer Tocv call s:Markdown_Toc('vertical')
command! -buffer Toct call s:Markdown_Toc('tab')
