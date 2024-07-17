#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Steam' "$@"
}

install.debian() {
	local temp_dir=
	temp_dir="$(mktemp -d)"
	cd "$temp_dir"

	curl -K "$CURL_CONFIG" -o ./steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
	sudo apt-get install -y ./steam.deb
}

main "$@"
