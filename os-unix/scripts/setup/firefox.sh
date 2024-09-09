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
	sudo pacman -Syu --noconfirm firefox
}

install.opensuse() {
	sudo zypper -n install firefox
}

main "$@"
