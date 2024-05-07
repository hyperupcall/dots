#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Git' "$@"
}

install.any() {
	sudo add-apt-repository ppa:git-core/ppa
	sudo apt-get update
	sudo apt-get install -y git
}

main "$@"
