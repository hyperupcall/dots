# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/sexy-bash-prompt"

install() {
	git clone 'https://github.com/twolfson/sexy-bash-prompt' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/.bash_prompt"
}
