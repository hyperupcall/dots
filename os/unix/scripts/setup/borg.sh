#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Borg' "$@"
}

install.debian() {
	sudo apt-get install -y borgbackup
}

install.opensuse() {
	sudo zypper -n install borgbackup
}

main "$@"
