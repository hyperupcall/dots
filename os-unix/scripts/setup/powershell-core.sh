#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'PowerShell Core' "$@"
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/microsoft.asc"
	local dist='bullseye'

	pkg.add_apt_key \
		'https://packages.microsoft.com/keys/microsoft.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64 signed-by=$gpg_file] https://packages.microsoft.com/repos/microsoft-debian-$dist-prod $dist main" \
		"/etc/apt/sources.list.d/microsoft.list"

	sudo apt-get -y update
	sudo apt-get -y install powershell
}

util.is_executing_as_script && main "$@"
