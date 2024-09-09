# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/liquidprompt"

install() {
	git clone 'https://github.com/nojhan/liquidprompt' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/liquidprompt"
}
