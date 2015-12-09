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
