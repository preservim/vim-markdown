if exists("b:did_indent") | finish | endif
let b:did_indent = 1

setlocal indentexpr=GetMarkdownIndent()
setlocal nolisp
setlocal autoindent

" Automatically insert bullets
setlocal formatoptions+=r
" Do not automatically insert bullets when auto-wrapping with text-width
setlocal formatoptions-=c
" Accept various markers as bullets
setlocal comments=b:*,b:+,b:-

" Automatically continue blockquote on line break
setlocal comments+=b:>

" Only define the function once
if exists("*GetMarkdownIndent") | finish | endif

function! s:is_mkdCode(lnum)
    let name = synIDattr(synID(a:lnum, 1, 0), 'name')
    return (name =~ '^mkd\%(Code$\|Snippet\)' || name != '' && name !~ '^\%(mkd\|html\)')
endfunction

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

function GetMarkdownIndent()
    if v:lnum > 2 && s:is_blank_line(getline(v:lnum - 1)) && s:is_blank_line(getline(v:lnum - 2))
        return 0
    endif
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
        if s:is_mkdCode(lnum)
            return ind
        else
            " Last line is the first line of a list item, increase indent
            return ind + list_ind
        end
    else
        return ind
    endif
endfunction
