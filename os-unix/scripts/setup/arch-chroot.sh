#!/usr/bin/env bash

source "${0%/*}/../source.sh"

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

main "$@"

