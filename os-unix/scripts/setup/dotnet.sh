#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Dotnet' "$@"
}

install.ubuntu() {
	sudo add-apt-repository 'ppa:dotnet/backports'
}

main "$@"
