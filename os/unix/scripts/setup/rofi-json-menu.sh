#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	local dir="$HOME/.dotfiles/.data/repos/rofi-json-menu"
	util.clone "$dir" 'https://github.com/marvinkreis/rofi-json-menu'

	make
	sudo make install
}

main "$@"
