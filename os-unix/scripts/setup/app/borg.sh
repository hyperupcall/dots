#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Borg' "$@"
}

install.debian() {
	sudo apt-get install -y borgbackup
}

install.fedora() {
	sudo dnf install -y borgbackup
}

install.opensuse() {
	sudo zypper -n install borgbackup
}

install.arch() {
	sudo pacman -Syu --noconfirm borgbackup
}

util.is_executing_as_script && main "$@"
