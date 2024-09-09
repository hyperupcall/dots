# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/polyglot"

install() {
	git clone 'https://github.com/agkozak/polyglot' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/polyglot.sh"
}
