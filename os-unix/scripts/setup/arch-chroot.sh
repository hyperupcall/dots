#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'arch-chroot' "$@"
}

install.any() {
	local dir="$HOME/.dotfiles/.data/repos/arch-install-scripts"
	util.clone "$dir" https://github.com/archlinux/arch-install-scripts

	cd "$dir"
	make arch-chroot
	cp ./arch-chroot ~/.local/bin
}

util.is_executing_as_script && main "$@"
