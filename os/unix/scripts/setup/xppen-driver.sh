#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Install XP-Pen Driver?' "$@"
}

install.any() {
	cd "$(mktemp -d)" &>/dev/null
	core.print_info 'Downloading'
	curl -fsSLo './xp-pen.tar.gz' 'https://www.xp-pen.com/download/file/id/1936/pid/421/ext/gz.html'

	core.print_info 'Extracting'
	tar xf './xp-pen.tar.gz'

	core.print_info 'Installing'
	bash
	# TODO: sudo XPPenLinux*/install.sh
}

main "$@"
