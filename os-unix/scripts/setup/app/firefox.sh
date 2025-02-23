#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

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

util.is_executing_as_script && main "$@"
