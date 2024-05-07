#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Discord' "$@"
}

install.any() {
	if command -v 'apt' &>/dev/null; then (
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"
		util.req -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
		sudo dpkg -i ./discord.deb
		rm -f ./discord.deb
	) else (
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"
		util.req -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
		tar xf './discord.tar.gz'
		core.print_warn 'Do not know how to handle tarball on non-deb Linux'
		rm -f ./discord.deb
	) fi
}

main "$@"
