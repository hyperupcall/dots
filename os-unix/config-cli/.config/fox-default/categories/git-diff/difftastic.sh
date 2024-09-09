# shellcheck shell=bash

install() {
	cargo install difftastic
}

uninstall() {
	cargo uninstall difftastic
}

test() {
	cargo install --list | grep -E '^difftastic'
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./difftastic.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
