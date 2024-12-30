#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'npm dependencies' "$@"
}

install.any() {
	npm i -g yarn pnpm
	yarn global add pnpm
	yarn global add diff-so-fancy
	yarn global add graphqurl
}

util.is_executing_as_script && main "$@"
