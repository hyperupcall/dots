# shellcheck shell=bash

install() {
	cargo install git-delta
}

uninstall() {
	cargo uninstall git-delta
}

test() {
	cargo install --list | grep -E '^git-delta'
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./delta.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
