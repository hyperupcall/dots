#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Sublime Text' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/sublimehq-archive.asc"

	pkg.add_apt_key \
		'https://download.sublimetext.com/sublimehq-pub.gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://download.sublimetext.com/ apt/stable/" \
		'/etc/apt/sources.list.d/sublime-text.list'

	sudo apt-get update
	sudo apt-get install -y sublime-text
}

main "$@"
