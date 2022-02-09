augroup VimMarkdown
    autocmd!
augroup END

if !has('patch-7.4.480')
    " Before this patch, vim used modula2 for .md.
    au! VimMarkdown filetypedetect BufRead,BufNewFile *.md
endif

" markdown filetype file
au VimMarkdown BufRead,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setfiletype markdown
au VimMarkdown BufRead,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setfiletype markdown
