# Markdown Vim Mode

Syntax highlighting, matching rules and mappings for [the original Markdown](http://daringfireball.net/projects/markdown/) and extensions.

## Installation

If you use [Vundle](https://github.com/gmarik/vundle), add the following line to your `~/.vimrc`:

    Bundle 'plasticboy/vim-markdown'

And then run inside Vim:

    :so ~/.vimrc
    :BundleInstall

If you use [Pathogen](https://github.com/tpope/vim-pathogen), do this:

    $ cd ~/.vim/bundle
    $ git clone https://github.com/plasticboy/vim-markdown.git

To install without Pathogen using the Debian [vim-addon-manager](http://packages.qa.debian.org/v/vim-addon-manager.html), do this:

    $ git clone https://github.com/plasticboy/vim-markdown.git
    $ cd vim-markdown
    $ sudo make install
    $ vim-addon-manager install mkd

If you are not using any package manager, download the [tarball](https://github.com/plasticboy/vim-markdown/archive/master.tar.gz) and do this:

    $ cd ~/.vim
    $ tar --strip=1 -zxf vim-markdown-master.tar.gz

## Options

**Disable Folding**

Add the following line to your `.vimrc` to disable folding.

```vim
let g:vim_markdown_folding_disabled=1
```

**Set Initial Foldlevel**

Add the following line to your `.vimrc` to set the initial foldlevel. This option defaults to 0 (i.e. all folds are closed) and is ignored if folding is disabled.

```vim
let g:vim_markdown_initial_foldlevel=1
```

## Mappings

The following work on normal and visual modes:

- `]]`: go to next header.
- `[[`: go to previous header. Contrast with `]c`.
- `][`: go to next sibling header if any.
- `[]`: go to previous sibling header if any.
- `]c`: go to Current header.
- `]u`: go to parent header (Up).

## Credits

The main contributors of vim-markdown are:

- **Ben Williams** (A.K.A. **platicboy**). The original developer of vim-markdown. [Homepage](http://plasticboy.com/).

If you feel that your name should be on this list, please make a pull request listing your contributions.

## License

The MIT License (MIT)

Copyright (c) 2012 Benjamin D. Williams

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
