#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Unity Hub?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		local gpg_file="/etc/apt/keyrings/unity.asc"

		pkg.add_apt_key \
			'https://hub.unity3d.com/linux/keys/public' \
			"$gpg_file"

		pkg.add_apt_repository \
			"deb [signed-by=$gpg_file] https://hub.unity3d.com/linux/repos/deb stable main" \
			'/etc/apt/sources.list.d/unityhub.list'

		sudo apt update
		sudo apt-get install -y unityhub
		;;
	esac
}

main "$@"
