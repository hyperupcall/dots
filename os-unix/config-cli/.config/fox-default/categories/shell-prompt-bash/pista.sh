# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/pista"

install() {
	cargo install pista
}

uninstall() {
	cargo uninstall pista
}

test() {
	[ -d "$dir" ]
}

launch() {
	printf '%s\n' "PS1='$(pista -m)'"
}
