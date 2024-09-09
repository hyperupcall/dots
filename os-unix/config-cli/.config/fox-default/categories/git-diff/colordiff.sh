# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./colordiff.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
