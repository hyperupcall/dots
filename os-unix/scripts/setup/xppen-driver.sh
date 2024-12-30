#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'XP-Pen Driver' "$@"
}

install.any() {
	cd "$(mktemp -d)" &>/dev/null
	core.print_info 'Downloading'
	curl -K "$CURL_CONFIG" -o './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'

	core.print_info 'Extracting'
	tar xf './xp-pen.tar.gz'

	core.print_info 'Installing'
	bash
}

util.is_executing_as_script && main "$@"
