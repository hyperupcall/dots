# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/trueline"

install() {
	git clone 'https://github.com/petobens/trueline'  "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/trueline.sh"
}
