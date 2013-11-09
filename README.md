# Markdown Vim Mode

Syntax highlighting, matching rules and mappings for [Markdown](http://daringfireball.net/projects/markdown/).

## Installation

If you use [Pathogen](http://www.vim.org/scripts/script.php?script_id=2332)(and you should), do this:

    $ cd ~/.vim/bundle
    $ git clone https://github.com/plasticboy/vim-markdown.git

To install without Pathogen, download the [tarball](https://github.com/plasticboy/vim-markdown/archive/master.tar.gz) and do this:

    $ cd ~/.vim
    $ tar --strip=1 -zxf vim-markdown-master.tar.gz

[Homepage](http://plasticboy.com/markdown-vim-mode/)

## Options

**Disable Folding**

Add the following line to your `.vimrc` to disable folding.

```vim
let g:vim_markdown_folding_disabled=1
```

**Set Initial Foldlevel**

Add the following line to your `.vimrc` to set the initial foldlevel.  This
option defaults to 0 (i.e. all folds are closed) and is ignored if folding
is disabled.

```vim
let g:vim_markdown_initial_foldlevel=1
```

## Mappings

the following work on normal and visual modes:

- `]]`: go to next header
- `[[`: go to previous header
- `][`: go to next sibling header if any
- `[]`: go to previous sibling header if any
- `]c`: go to Current header
- `]u`: go to parent header (Up)

## License

The MIT License (MIT)

Copyright (c) 2012 Benjamin D. Williams

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
