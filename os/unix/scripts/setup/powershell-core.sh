#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Powershell Core?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		printf '%s\n' 'Not implemented'
		;;
	apt)
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
		;;
	dnf)
		printf '%s\n' 'Not implemented'
		;;
	zypper)
		printf '%s\n' 'Not implemented'
		;;
	esac
}

main "$@"
