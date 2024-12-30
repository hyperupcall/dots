#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Dotnet' "$@"
}

install.ubuntu() {
	sudo add-apt-repository 'ppa:dotnet/backports'
}

util.is_executing_as_script && main "$@"
