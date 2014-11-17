VIMDIR=/usr/share/vim
ADDONS=${VIMDIR}/addons
REGISTRY=${VIMDIR}/registry

all:

install:
	mkdir -pv ${ADDONS}/ftdetect
	cp -v ftdetect/mkd.vim ${ADDONS}/ftdetect/mkd.vim
	mkdir -pv ${ADDONS}/ftplugin
	cp -v ftplugin/mkd.vim ${ADDONS}/ftplugin/mkd.vim
	mkdir -pv ${ADDONS}/syntax
	cp -v syntax/mkd.vim ${ADDONS}/syntax/mkd.vim
	mkdir -pv ${ADDONS}/after/ftplugin
	cp -v after/ftplugin/mkd.vim ${ADDONS}/after/ftplugin/mkd.vim
	mkdir -pv ${REGISTRY}
	cp -v registry/mkd.yaml ${REGISTRY}/mkd.yaml

test: build/tabular build/vader.vim
	test/run-tests.sh
.PHONY: test

build/tabular: | build
	git clone https://github.com/godlygeek/tabular build/tabular

build/vader.vim: | build
	git clone https://github.com/junegunn/vader.vim build/vader.vim

build:
	mkdir build
