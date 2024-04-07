#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install btrfs?'; then
		helper.setup "$@"
	fi
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
	sudo zypper -y install btrfs-progs
}

install.arch() {
	yay -Syu --noconfirm btrfs-progs
}

main "$@"
