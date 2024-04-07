#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Firefox?'; then
		helper.setup "$@"
	fi
}

install.debian() {
	sudo apt-get install firefox
}

install.fedora() {
	sudo dnf -y install firefox
}

install.arch() {
	sudo pacman -S --noconfirm firefox
}

install.opensuse() {
	sudo zypper -y install firefox
}

main "$@"
