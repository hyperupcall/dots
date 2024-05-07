#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'AppImageLauncher' "$@"
}

install.arch() {
	yay -S appimagelauncher
}

install.manjaro() {
	: # Installed by default.
}

install.debian() {
	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"
		util.req -o 'appimagelauncher.deb' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb'
		sudo dpkg -i './appimagelauncher.deb'
		rm -f './appimagelauncher.deb'
	)
}

install.fedora() {
	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"
		util.req -o 'appimagelauncher.rpm' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm'
		sudo rpm -i  'appimagelauncher.rpm'
		rm -f './appimagelauncher.rpm'
	)
}

install.opensuse() {
	install.fedora "$@"
}

main "$@"
