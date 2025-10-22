set ignore-comments := true
set unstable := true

just := just_executable()
vim := which('vim')
nvim := which('nvim')

[default]
[private]
@help:
    {{ just }} --list --unsorted

[no-cd]
preview-vim *ARGS: (preview vim + ' -N -u NORC -i NONE -c "filetype plugin on | syntax on"' ARGS)

[no-cd]
preview-nvim *ARGS: (preview nvim + ' --clean' ARGS)

[no-cd]
[private]
preview vimcmd *ARGS:
    {{ vimcmd }} \
    	-c {{ quote("let &runtimepath=\"" + justfile_directory() + ",\" . &runtimepath") }} \
    	-c 'filetype detect' \
    	{{ ARGS }}
