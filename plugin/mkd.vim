" Heavily based on vim-notes - http://peterodding.com/code/vim/notes/
function! s:Markdown_highlight_sources()
    " Syntax highlight source code embedded in notes.
    " Look for code blocks in the current file
    let filetypes = {}
    for line in getline(1, '$')
        let ft = matchstr(line, '```\zs\w*\>')
        if !empty(ft) && ft !~ '^\d*$' | let filetypes[ft] = 1 | endif
    endfor
    if !exists('b:mkd_known_filetypes')
        let b:mkd_known_filetypes = {}
    endif
    if b:mkd_known_filetypes == filetypes || empty(filetypes)
        return
    endif

    " Now we're ready to actually highlight the code blocks.
    let startgroup = 'mkdCodeStart'
    let endgroup = 'mkdCodeEnd'
    for ft in keys(filetypes)
        if !has_key(b:mkd_known_filetypes, ft)

            let group = 'mkdSnippet' . toupper(ft)
            let include = s:syntax_include(ft)
            let command = 'syntax region %s matchgroup=%s start="```%s" matchgroup=%s end="```" keepend contains=%s%s'
            execute printf(command, group, startgroup, ft, endgroup, include, has('conceal') ? ' concealends' : '')
            execute printf('syntax cluster mkdNonListItem add=%s', group)

            let b:mkd_known_filetypes[ft] = 1
        endif
    endfor
endfunction

function! s:syntax_include(filetype)
    " Include the syntax highlighting of another {filetype}.
    let grouplistname = '@' . toupper(a:filetype)
    " Unset the name of the current syntax while including the other syntax
    " because some syntax scripts do nothing when "b:current_syntax" is set
    if exists('b:current_syntax')
        let syntax_save = b:current_syntax
        unlet b:current_syntax
    endif
    try
        execute 'syntax include' grouplistname 'syntax/' . a:filetype . '.vim'
        execute 'syntax include' grouplistname 'after/syntax/' . a:filetype . '.vim'
    catch /E484/
        " Ignore missing scripts
    endtry
    " Restore the name of the current syntax
    if exists('syntax_save')
        let b:current_syntax = syntax_save
    elseif exists('b:current_syntax')
        unlet b:current_syntax
    endif
    return grouplistname
endfunction


function! s:Markdown_refresh_syntax()
    if &filetype == 'mkd' && line('$') > 1
        call s:Markdown_highlight_sources()
    endif
endfunction

augroup Mkd
    autocmd!
    au BufReadPost * call s:Markdown_refresh_syntax()
    au BufReadPost,BufWritePost * call s:Markdown_refresh_syntax()
    au InsertEnter,InsertLeave * call s:Markdown_refresh_syntax()
    au CursorHold,CursorHoldI * call s:Markdown_refresh_syntax()
augroup END
