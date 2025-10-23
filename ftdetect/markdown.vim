" SPDX-FileCopyrightText: © 2022 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Benjamin D. Williams <benw@plasticboy.com>
" SPDX-License-Identifier: MIT

scriptencoding utf-8

if !has('patch-7.4.480')
    " Before this patch, vim used modula2 for .md.
    autocmd! filetypedetect BufRead,BufNewFile *.md
endif

" vint: -ProhibitAutocmdWithNoGroup
autocmd BufRead,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setfiletype markdown
autocmd BufRead,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setfiletype markdown
