#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Discord' "$@"
}

install.debian() {
	local temp_dir=
	temp_dir=$(mktemp -d)
	cd "$temp_dir"

	curl -K "$CURL_CONFIG" -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
	sudo dpkg -i ./discord.deb
	rm -f ./discord.deb
}

install.any() {
	local temp_dir=
	temp_dir=$(mktemp -d)
	cd "$temp_dir"
	curl -K "$CURL_CONFIG" -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
	tar xf './discord.tar.gz'
	core.print_warn 'Do not know how to handle tarball on non-deb Linux'
}

main "$@"
