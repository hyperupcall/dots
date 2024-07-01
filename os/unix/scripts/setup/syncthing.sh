#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Synthing' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/syncthing-archive-keyring.gpg"

	pkg.add_apt_key \
		'https://syncthing.net/release-key.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://apt.syncthing.net/ syncthing stable" \
		'/etc/apt/sources.list.d/syncthing.list'

	sudo apt-get update -y
	sudo apt-get install -y syncthing
}

main "$@"
