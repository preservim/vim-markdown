"TODO print messages when on visual mode. I only see VISUAL, not the messages.

" This is how you should view things:
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

let s:headerExpr = '\v^(\s*#|.+\n(\=+|-+)$)'

" Return 0 if not found, else the actual line number.
"
function! b:Markdown_GetLineNumCurHeader()
    echo s:headerExpr
    return search(s:headerExpr, 'bcnW')
endfunction

" - if inside a header goes to it.
"    Return its line number.
"
" - if on top level outside any headers,
"    print a warning
"    Return `0`.
"
function! b:Markdown_GoCurHeader()
    let l:lineNum = b:Markdown_GetLineNumCurHeader()
    if l:lineNum != 0
        call cursor(l:lineNum, 1)
    else
        echo 'error: outside any header'
        "normal! gg
    end
    return l:lineNum
endfunction

" Put cursor on next header of any level.
"
" If there are no more headers, print a warning.
"
function! b:Markdown_GoNextHeader()
    if search(s:headerExpr, 'W') == 0
        "normal! G
        echo 'error: no next header'
    end
endfunction

" Put cursor on previous header (before current) of any level.
"
" If it does not exist, print a warning.
"
function! b:Markdown_GoPreviousHeader()
    let l:oldPos = getpos('.')
    let l:curHeaderLineNumber = b:Markdown_GoCurHeader()
    if l:curHeaderLineNumber == 0
        call setpos('.', l:oldPos)
    end
    if search(s:headerExpr, 'bW') == 0
        "normal! gg
        call setpos('.', l:oldPos)
        echo 'error: no previous header'
    end
endfunction

"- if inside a header, cursor goes to it.
"   Return its hashes.
"
"- if on top level outside any headers,
"   print a warning
"   return ''
"
function! b:Markdown_GoCurHeaderGetHashes()
    let l:linenum = b:Markdown_GetLineNumCurHeader()
    if l:linenum != 0
        call cursor(l:linenum, 1)
        return matchlist(getline(linenum), '\v^\s*(#+)')[1]
    else
        return ''
    end
endfunction

" Put cursor on previous header of any level.
"
" If it exists, return its lines number.
"
" Otherwise, print a warning and return `0`.
"
function! b:Markdown_GoHeaderUp()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    if len(l:hashes) > 1
        call search('^\s*' . l:hashes[1:] . '[^#]', 'b')
    else
        call setpos('.', l:oldPos)
        echo 'error: already at top level'
    end
endfunction

" If no more next siblings, print error message and do nothing.
"
function! b:Markdown_GoNextSiblingHeader()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    let l:noSibling = 0
    if l:hashes ==# ''
        let l:noSibling = 1
    else
        let l:nhashes = len(l:hashes)
        if l:nhashes == 1
            "special case, just add the largest possible value
            let l:nextLowerLevelLine = line('$') + 1
        else
            let l:nextLowerLevelLine = search('\v^\s*#{1,' . (l:nhashes - 1) . '}[^#]' , 'nW')
        end
        let l:nextSameLevelLine = search('\v^\s*' . l:hashes . '[^#]', 'nW')
        if (
                \ l:nextSameLevelLine > 0
                \ &&
                \ (
                \   l:nextLowerLevelLine == 0
                \   ||
                \   l:nextLowerLevelLine > l:nextSameLevelLine
                \ )
            \ )
            call cursor(l:nextSameLevelLine, 1)
        else
            let l:noSibling = 1
        end
    end
    if l:noSibling
        call setpos('.', l:oldPos)
        echo 'error: no next sibling'
    end
endfunction

"if no more next siblings, print error message and do nothing.
function! b:Markdown_GoPreviousSiblingHeader()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    let l:noSibling = 0
    if l:hashes ==# ''
        let l:noSibling = 1
    else
        let l:nhashes = len(l:hashes)
        if l:nhashes == 1
            "special case, just add the largest possible value
            let l:prevLowerLevelLine = -1
        else
            let l:prevLowerLevelLine = search('\v^\s*#{1,' . (l:nhashes - 1) . '}[^#]' , 'bnW')
        end
        let l:prevSameLevelLine = search('\v^\s*' . l:hashes . '[^#]', 'bnW')
        if (
                \ l:prevSameLevelLine > 0
                \ &&
                \ (
                \   l:prevLowerLevelLine == 0
                \   ||
                \   l:prevLowerLevelLine < l:prevSameLevelLine
                \ )
            \)
            call cursor(l:prevSameLevelLine, 1)
        else
            let l:noSibling = 1
        end
    end
    if l:noSibling
        call setpos('.', l:oldPos)
        echo 'error: no previous sibling'
    end
endfunction

"wrapper to do move commands in visual mode
function! s:VisMove(f)
    norm! gv
    call function(a:f)()
endfunction

"map in both normal and visual modes
function! s:MapNormVis(rhs,lhs)
    execute 'nn <buffer><silent> ' . a:rhs . ' :call ' . a:lhs . '()<cr>'
    execute 'vn <buffer><silent> ' . a:rhs . ' <esc>:call <sid>VisMove(''' . a:lhs . ''')<cr>'
endfunction

call <sid>MapNormVis(']]', 'b:Markdown_GoNextHeader')
call <sid>MapNormVis('[[', 'b:Markdown_GoPreviousHeader')
call <sid>MapNormVis('][', 'b:Markdown_GoNextSiblingHeader')
call <sid>MapNormVis('[]', 'b:Markdown_GoPreviousSiblingHeader')
"menmonic: Up
call <sid>MapNormVis(']u', 'b:Markdown_GoHeaderUp')
"menmonic: Current
call <sid>MapNormVis(']c', 'b:Markdown_GoCurHeader')
