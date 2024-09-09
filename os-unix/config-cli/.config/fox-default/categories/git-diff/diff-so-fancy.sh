# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/diff-so-fancy"

install() {
	git clone 'https://github.com/so-fancy/diff-so-fancy' "$dir"
	ln -sf "$dir/diff-so-fancy" "$HOME/.dotfiles/.data/bin/diff-so-fancy"
}

uninstall() {
	rm -rf "$dir"
	unlink "$HOME/.dotfiles/.data/.bin/diff-so-fancy"
}

test() {
	[ -d "$dir" ]
}

switch() {
	mkdir -p ~/.dotfiles/.home/xdg_config_dir/git/include/diff
	printf '%s' "[include]
	path = ./diff-so-fancy.conf
" > ~/.dotfiles/.home/xdg_config_dir/git/include/diff/_.conf
}
