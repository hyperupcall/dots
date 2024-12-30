#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'btrfs' "$@"
}

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y install btrfs-progs
}

install.fedora() {
	sudo dnf -y update
	sudo dnf -y install btrfs-progs
}

install.opensuse() {
	sudo zypper refresh
	sudo zypper -n install btrfs-progs
}

install.arch() {
	yay -Syu --noconfirm btrfs-progs
}

util.is_executing_as_script && main "$@"
