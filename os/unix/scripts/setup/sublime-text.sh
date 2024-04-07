#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Sublime Text?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		local gpg_file="/etc/apt/keyrings/sublimehq-archive.asc"

		pkg.add_apt_key \
			'https://download.sublimetext.com/sublimehq-pub.gpg' \
			"$gpg_file"

		pkg.add_apt_repository \
			"deb [signed-by=$gpg_file] https://download.sublimetext.com/ apt/stable/" \
			'/etc/apt/sources.list.d/sublime-text.list'

		sudo apt update
		sudo apt-get install -y sublime-text
		;;
	esac
}

main "$@"
