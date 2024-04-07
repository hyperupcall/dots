#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm "Install Discord?"; then
		helper.setup "$@"
	fi
}

install.any() {
	if util.is_cmd 'apt'; then (
		util.cd_temp
		util.req -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
		sudo dpkg -i ./discord.deb
		rm -f ./discord.deb
	) else (
		util.cd_temp
		util.req -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
		tar xf './discord.tar.gz'
		core.print_warn 'Do not know how to handle tarball on non-deb Linux'
		rm -f ./discord.deb
	) fi
}

main "$@"
