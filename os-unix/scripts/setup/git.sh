#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Git' "$@"
}

install.any() {
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo apt-get update -y
	sudo apt-get install -y git
}

installed() {
	command -v git &>/dev/null
}

main "$@"
