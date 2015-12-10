VIMDIR=$(DESTDIR)/usr/share/vim
ADDONS=${VIMDIR}/addons
REGISTRY=${VIMDIR}/registry

all:

install:
	mkdir -pv ${ADDONS}/ftdetect
	cp -v ftdetect/markdown.vim ${ADDONS}/ftdetect/markdown.vim
	mkdir -pv ${ADDONS}/ftplugin
	cp -v ftplugin/markdown.vim ${ADDONS}/ftplugin/markdown.vim
	mkdir -pv ${ADDONS}/syntax
	cp -v syntax/markdown.vim ${ADDONS}/syntax/markdown.vim
	mkdir -pv ${ADDONS}/after/ftplugin
	cp -v after/ftplugin/markdown.vim ${ADDONS}/after/ftplugin/markdown.vim
	mkdir -pv ${ADDONS}/doc
	cp -v doc/vim-markdown.txt ${ADDONS}/doc/vim-markdown.txt
	mkdir -pv ${REGISTRY}
	cp -v registry/markdown.yaml ${REGISTRY}/markdown.yaml

test: build/tabular build/vader.vim
	test/run-tests.sh
.PHONY: test

update: build/tabular build/vader.vim
	cd build/tabular && git pull
	cd build/vader.vim && git pull
.PHONY: update

build/tabular: | build
	git clone https://github.com/godlygeek/tabular build/tabular

build/vader.vim: | build
	git clone https://github.com/junegunn/vader.vim build/vader.vim

build:
	mkdir build

doc: build/html2vimdoc build/vim-tools
	sed '/^\(\[!\[Build Status\]\|1. \[\)/d' README.md > doc/tmp.md
	build/html2vimdoc/bin/python build/vim-tools/html2vimdoc.py -f vim-markdown \
		doc/tmp.md | \
		sed -e "s/\s*$$//; # remove trailing spaces" \
		    -e "/^- '[^']*':\( \|$$\)/ { # match command lines" \
		    -e "s/^- '\([^']*\)':\( \|$$\)/ \*\1\*\n\0/; # make command references" \
		    -e ":a; s/^\(.\{1,78\}\n\)/ \1/; ta } # right align references" \
		> doc/vim-markdown.txt && rm -f doc/tmp.md
.PHONY: doc

# Prerequire Python and virtualenv.
# $ sudo pip install virtualenv
# Create the virtual environment.
# Install the dependencies.
build/html2vimdoc: | build
	virtualenv build/html2vimdoc
	build/html2vimdoc/bin/pip install beautifulsoup coloredlogs==4.0 markdown

build/vim-tools: | build
	git clone https://github.com/xolox/vim-tools.git build/vim-tools
