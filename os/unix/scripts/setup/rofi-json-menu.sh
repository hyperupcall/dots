#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	util.clone ~/.dotfiles/.data/repos/rofi-json-menu 'https://github.com/marvinkreis/rofi-json-menu'
	cd ~/.dotfiles/.data/repos/rofi-json-menu
	make
	sudo make install
}

main "$@"
