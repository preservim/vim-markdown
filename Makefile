VIMDIR=/usr/share/vim
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
