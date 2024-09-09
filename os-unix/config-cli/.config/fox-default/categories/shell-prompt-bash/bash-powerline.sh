# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/bash-powerline"

install() {
	git clone 'https://github.com/riobard/bash-powerline' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/bash-powerline.sh"
}
