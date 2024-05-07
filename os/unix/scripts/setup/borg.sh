#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Borg?'; then
		helper.setup "$@"
	fi
}

install.debian() {
	sudo apt-get install -y borgbackup
}

main "$@"
