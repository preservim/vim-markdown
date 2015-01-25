if exists("b:did_indent") | finish | endif
let b:did_indent = 1

setlocal indentexpr=GetMkdIndent()
setlocal nolisp
setlocal autoindent

" Only define the function once
if exists("*GetMkdIndent") | finish | endif

function! s:is_li_start(line)
    return a:line !~ '^ *\([*-]\)\%( *\1\)\{2}\%( \|\1\)*$' &&
      \    a:line =~ '^\s*[*+-] \+'
endfunction

function! s:is_blank_line(line)
    return a:line =~ '^$'
endfunction

function! s:prevnonblank(lnum)
    let i = a:lnum
    while i > 1 && s:is_blank_line(getline(i))
        let i -= 1
    endwhile
    return i
endfunction

function GetMkdIndent()
    let list_ind = 4
    " Find a non-blank line above the current line.
    let lnum = prevnonblank(v:lnum - 1)
    " At the start of the file use zero indent.
    if lnum == 0 | return 0 | endif
    let ind = indent(lnum)
    let line = getline(lnum)    " Last line
    let cline = getline(v:lnum) " Current line
    if s:is_li_start(cline) 
        " Current line is the first line of a list item, do not change indent
        return indent(v:lnum)
    elseif s:is_li_start(line)
        " Last line is the first line of a list item, increase indent
        return ind + list_ind
    else
        return ind
    endif
endfunction
