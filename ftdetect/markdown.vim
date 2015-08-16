" The plugin originally used mkd, but then we've added markdown
" because that is what the default syntax and third party plugins use.
" We won't remove mkd to maintain backwards compatibility,
" but markdown is the preferred form.
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=mkd.markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=mkd.markdown
