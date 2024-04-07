#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Borg?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	apt)
		sudo apt-get install -y borgbackup
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
		;;
	esac
}

main "$@"
