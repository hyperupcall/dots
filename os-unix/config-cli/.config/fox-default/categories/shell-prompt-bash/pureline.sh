# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/pureline"

install() {
	git clone 'https://github.com/chris-marsh/pureline'  "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/pureline"
}
