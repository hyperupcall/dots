#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Python Tools' "$@"
}

install.any() {
	python3 -m ensurepip --upgrade
	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade wheel
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
}

util.is_executing_as_script && main "$@"
