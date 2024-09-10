#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Unity Hub' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/unity.asc"

	pkg.add_apt_key \
		'https://hub.unity3d.com/linux/keys/public' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://hub.unity3d.com/linux/repos/deb stable main" \
		'/etc/apt/sources.list.d/unityhub.list'

	sudo apt-get update -y 
	sudo apt-get install -y unityhub
}

main "$@"
