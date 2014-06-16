" folding for Markdown headers, both styles (atx- and setex-)
" http://daringfireball.net/projects/markdown/syntax#header
"
" this code can be placed in file
"   $HOME/.vim/after/ftplugin/markdown.vim
"
" original version from Steve Losh's gist: https://gist.github.com/1038710

func! Foldexpr_markdown(lnum)
    if (a:lnum == 1)
        let l0 = ''
    else
        let l0 = getline(a:lnum-1)
    endif

    let l1 = getline(a:lnum)

    let l2 = getline(a:lnum+1)

    if  l2 =~ '^==\+\s*'
        " next line is underlined (level 1)
        return '>1'
    elseif l2 =~ '^--\+\s*'
        " next line is underlined (level 2)
        return '>2'
    elseif l1 =~ '^#'
        " don't include the section title in the fold
        return '-1'
    elseif l0 =~ '^#'
        " current line starts with hashes
        return '>'.matchend(l0, '^#\+')
    else
        " keep previous foldlevel
        return '='
    endif
endfunc


if !get(g:, "vim_markdown_folding_disabled", 0)
  setlocal foldexpr=Foldexpr_markdown(v:lnum)
  setlocal foldmethod=expr

  " allow the initial foldlevel to be configured in .vimrc
  if !exists("g:vim_markdown_initial_foldlevel")
    let g:vim_markdown_initial_foldlevel=0
  endif
  let &l:foldlevel=g:vim_markdown_initial_foldlevel

  "---------- everything after this is optional -----------------------
  " change the following fold options to your liking
  " see ':help fold-options' for more
  setlocal foldenable
  setlocal foldcolumn=0
  set foldmethod=expr
  set foldopen-=search
endif
