# shellcheck shell=bash

install() {
	npm install -g git-split-diffs
}

uninstall() {
	npm uninstall -g git-split-diffs
}

test() {
	npm list -g git-split-diffs &>/dev/null
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./git-split-diffs.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
