"TODO print messages when on visual mode. I only see VISUAL, not the messages.

"this is how you should view things:
"
"  |BUFFER
"  |
"  |outside any header
"  |
"a-+# a
"  |
"  |inside a
"  |
"a-+
"b-+## b
"  |
"  |inside b
"  |
"b-+
"c-+### c
"  |
"  |inside c
"  |
"c-+
"d-|# d
"  |
"  |inside d
"  |
"d-+

let s:headerExpr = '\v^#'

"0 if not found
fu! b:Markdown_GetLineNumCurHeader()
    retu search( s:headerExpr, 'bcnW' )
endf

"- if inside a header goes to it
"   returns its hashes
"- if on top level outside any headers,
"   print a warning
"   return ''
fu! b:Markdown_GoCurHeaderGetHashes()
    let l:lineNum = b:Markdown_GetLineNumCurHeader()
    if l:lineNum != 0
        cal cursor( l:lineNum, 1 )
        retu matchstr( getline( lineNum ), '\v^#+' )
    el  
        retu ''
    en
endf

"- if inside a header goes to it
"   returns its line number
"- if on top level outside any headers,
"   print a warning
"   return 0
fu! b:Markdown_GoCurHeader()
    let l:lineNum = b:Markdown_GetLineNumCurHeader()
    if l:lineNum != 0
        cal cursor( l:lineNum, 1 )
    el
        ec 'outside any header'
        "norm! gg
    en
    retu l:lineNum
endf

"goes to next header of any level
"
"if no there are no more headers print a warning
fu! b:Markdown_GoNextHeader()
    if search( s:headerExpr, 'W' ) == 0
        "norm! G
        ec 'no next header'
    en
endf

"goes to previous header of any level
"
"if it does not exist, print a warning
fu! b:Markdown_GoPreviousHeader()
    let l:oldPos = getpos('.')
    let l:curHeaderLineNumber = b:Markdown_GoCurHeader()
    if l:curHeaderLineNumber == 0
        cal setpos('.',l:oldPos)
    en
    if search( s:headerExpr, 'bW' ) == 0
        "norm! gg
        cal setpos('.',l:oldPos)
        ec 'no previous header'
    en
endf

"goes to previous header of any level
"
"if it exists, return its lines number
"
"otherwise, print a warning and return 0
fu! b:Markdown_GoHeaderUp()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    if len( l:hashes ) > 1
        cal search( '^' . l:hashes[1:] . '[^#]', 'b' )
    el
        cal setpos('.',l:oldPos)
        ec 'already at top level'
    en
endf

"if no more next siblings, print error message and do nothing.
fu! b:Markdown_GoNextSiblingHeader()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    let l:noSibling = 0

    if l:hashes ==# ''
        let l:noSibling = 1
    el
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
            cal cursor( l:nextSameLevelLine, 1 )
        el
            let l:noSibling = 1
        en
    en

    if l:noSibling
        cal setpos('.',l:oldPos)
        ec 'no next sibling'
    en
endf

"if no more next siblings, print error message and do nothing.
fu! b:Markdown_GoPreviousSiblingHeader()
    let l:oldPos = getpos('.')
    let l:hashes = b:Markdown_GoCurHeaderGetHashes()
    let l:noSibling = 0

    if l:hashes ==# ''
        let l:noSibling = 1
    el
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
            cal cursor( l:prevSameLevelLine, 1 )
        el
            let l:noSibling = 1
        en
    en
    
    if l:noSibling
        cal setpos('.',l:oldPos)
        ec 'no previous sibling'
    en

endf

"wrapper to do move commands in visual mode
fu! s:VisMove(f)
    norm! gv
    cal function(a:f)()
endf

"map in both normal and visual modes
fu! s:MapNormVis(rhs,lhs)
    exe 'nn <buffer><silent> ' . a:rhs . ' :cal ' . a:lhs . '()<cr>'
    exe 'vn <buffer><silent> ' . a:rhs . ' <esc>:cal <sid>VisMove(''' . a:lhs . ''')<cr>'
endf

cal <sid>MapNormVis( ']]', 'b:Markdown_GoNextHeader' )
cal <sid>MapNormVis( '[[', 'b:Markdown_GoPreviousHeader' )
cal <sid>MapNormVis( '][', 'b:Markdown_GoNextSiblingHeader' )
cal <sid>MapNormVis( '[]', 'b:Markdown_GoPreviousSiblingHeader' )
"menmonic: Up
cal <sid>MapNormVis( ']u', 'b:Markdown_GoHeaderUp' )
"menmonic: Current
cal <sid>MapNormVis( ']c', 'b:Markdown_GoCurHeader' )
