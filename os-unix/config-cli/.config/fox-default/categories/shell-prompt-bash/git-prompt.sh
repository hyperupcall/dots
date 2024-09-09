# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/git-prompt"

install() {
	git clone 'https://github.com/lvv/git-prompt'  "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/git-prompt.sh"
}
