#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install AppImageLauncher?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	util.get_os_id
	local os_id="$REPLY"

	case $pkgmngr in
	pacman)
		if [ "$os_id" = 'manjaro' ]; then
			# Installed by default
			:
		else
			yay -S appimagelauncher
		fi
		;;
	apt) (
		util.cd_temp
		util.req -o 'appimagelauncher.deb' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb'
		sudo dpkg -i './appimagelauncher.deb'
		rm -f './appimagelauncher.deb'
		) ;;
	dnf|zypper) (
		util.cd_temp
		util.req -o 'appimagelauncher.rpm' 'https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm'
		sudo rpm -i  'appimagelauncher.rpm'
		rm -f './appimagelauncher.rpm'
		) ;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

main "$@"
