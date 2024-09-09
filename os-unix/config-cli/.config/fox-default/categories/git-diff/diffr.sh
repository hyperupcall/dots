# shellcheck shell=bash

install() {
	cargo install diffr
}

uninstall() {
	cargo uninstall diffr
}

test() {
	cargo install --list | grep -E '^diffr'
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./diffr.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
