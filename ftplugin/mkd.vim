"TODO get working on visual mode

"- if inside a header
"    goes to the nearest head before current position
"    returns its initial hashes (#)
"- else
"    goes to beginning of document
"    returns ''
fu! b:Markdown_GoCurHeader()
    if search( '^#', 'bcW' ) != 0
        return matchstr( getline('.'), '\v^#+' )
    el
        norm! gg
        ec 'outside any header'
        return ''
    en
endf

"same as `b:Markdown_GoCurHeader`:function: but does not change cursor position
fu! b:Markdown_GetHashesCurHeader()
    let line = search( '\v^#', 'nW' ) != 0
    retu matchstr( getline(line) '\v^#+' )
endf

"goes to next header of any level
"returns its hashes
fu! b:Markdown_GoNextHeader()
    if search( '\v^#', 'W' ) != 0
        return matchstr( getline('.'), '\v^#+' )
    el
        "norm! G
        ec 'no more headers'
        return ''
    en
endf

"goes to previous header of any level
"
"if there is no previous header, only print a warning
"
"if the cursor is not exactly at the header,
"it goes to exactly the header. So this could be used
"if you want to go to the current header line.
fu! b:Markdown_GoPreviousHeader()
    if search( '^#', 'bW' ) != 0
        return matchstr( getline('.'), '\v^#+' )
    el
        "norm! gg
        ec 'no more headers'
        return ''
    en
endf

"if already at top level, go to beginning of buffer
fu! b:Markdown_GoHeaderUp()
    let l:hashes = b:Markdown_GoCurHeader()
    if len( l:hashes ) > 1
        cal search( '^' . l:hashes[1:] . '[^#]', 'b' )
    el
        norm! gg
    en
endf

fu! b:Markdown_GoNextHeaderSameLevel()

    let l:hashes = b:Markdown_GoCurHeader()
    
    "go to next occurrence of that number of hashes
    cal search( '^' . l:hashes . '[^#]', 'W' )

endf

"if no more next siblings, print error message and do nothing.
fu! b:Markdown_GoNextSiblingHeader()

    let l:hashes = b:Markdown_GoCurHeader()

    if l:hashes ==# ''
        retu
    en

    let l:nhashes = len(l:hashes)
    if l:nhashes == 1
        "special case, just add the largest possible value
        let l:nextLowerLevelLine  = line('$') + 1
    el
        let l:nextLowerLevelLine  = search( '\v^#{1,' . ( l:nhashes - 1 ) . '}[^#]' , 'nW' )
    en

    let l:nextSameLevelLine   = search( '\v^' . l:hashes . '[^#]', 'nW' )

    if (
            \ l:nextSameLevelLine > 0
            \ &&
            \ (
            \   l:nextLowerLevelLine == 0
            \   ||
            \   l:nextLowerLevelLine > l:nextSameLevelLine
            \ )
        \ )
        cal cursor( l:nextSameLevelLine, 0 )
    el
        ec 'no more siblings'
    en

endf

fu! b:Markdown_GoPreviousHeaderSameLevel()

    let l:hashes = b:Markdown_GoCurHeader()

    "go to next occurrence of that number of hashes
    cal search( '^' . l:hashes . '[^#]', 'bW' )

endf

"if no more next siblings, print error message and do nothing.
fu! b:Markdown_GoPreviousSiblingHeader()

    let l:hashes = b:Markdown_GoCurHeader()

    if l:hashes ==# ''
        retu
    en

    let l:nhashes = len(l:hashes)
    if l:nhashes == 1
        "special case, just add the largest possible value
        let l:prevLowerLevelLine  = -1
    el
        let l:prevLowerLevelLine  = search( '\v^#{1,' . ( l:nhashes - 1 ) . '}[^#]' , 'bnW' )
    en

    let l:prevSameLevelLine   = search( '\v^' . l:hashes . '[^#]', 'bnW' )

    if (
            \ l:prevSameLevelLine > 0
            \ &&
            \ (
            \   l:prevLowerLevelLine == 0
            \   ||
            \   l:prevLowerLevelLine < l:prevSameLevelLine
            \ )
        \ )
        cal cursor( l:prevSameLevelLine, 0 )
    el
        ec 'no more siblings'
    en

endf

"mnemonics: ']' next (like a right arrow)
nn <buffer><silent> ]] :cal b:Markdown_GoNextHeader()<cr>
"vnoremap <buffer><silent> ]] /^#<cr><esc>:nohl<cr>gv

"mnemonics: '[' next (like a left arrow)
nn <buffer><silent> ][ :cal b:Markdown_GoNextSiblingHeader()<cr>
"vnoremap <buffer><silent> ][ <esc>:cal b:Markdown_GoNextHeaderSameLevel()<cr>

nn <buffer><silent> [] :cal b:Markdown_GoPreviousSiblingHeader()<cr>

nn <buffer><silent> [[ :cal b:Markdown_GoPreviousHeader()<cr>
"vnoremap <buffer><silent> [[ ?^#<cr><esc>:nohl<cr>gv

"go up one level. Menmonic: Up.
nn <buffer><silent> ]u :cal b:Markdown_GoHeaderUp()<cr>
