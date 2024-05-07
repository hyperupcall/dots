#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Firefox' "$@"
}

install.debian() {
	sudo apt-get install -y firefox
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
