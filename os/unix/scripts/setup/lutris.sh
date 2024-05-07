#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Lutris' "$@"
}

install.any() {
	local gpg_file="/etc/apt/keyrings/lutris.asc"

	pkg.add_apt_key \
		'https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" \
		'/etc/apt/sources.list.d/lutris.list'
}

main "$@"
