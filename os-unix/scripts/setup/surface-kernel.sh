#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	if ! util.confirm "Are all your kernel modules installed as DKMS?"; then
		exit 0
	fi

	helper.setup 'Surface Kernel' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/linux-surface.asc"

	pkg.add_apt_key \
		'https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64 signed-by=$gpg_file] https://pkg.surfacelinux.com/debian release main" \
		'/etc/apt/sources.list.d/linux-surface.list'

	sudo apt-get update -y
	sudo apt-get install -y linux-image-surface linux-headers-surface libwacom-surface iptsd
}

util.is_executing_as_script && main "$@"
