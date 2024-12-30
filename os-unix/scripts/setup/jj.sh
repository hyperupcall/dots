#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'jj' "$@"
}

install.any() {
	~/scripts/setup/rust.sh --no-confirm
	cargo binstall --strategies crate-meta-data jj-cli
}

installed() {
	command -v jj &>/dev/null
}

util.is_executing_as_script && main "$@"
