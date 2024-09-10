#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Python' "$@"
}

install.any() {
	if ! command -v 'pip' &>/dev/null; then
		core.print_info "Installing pip"
		python3 -m ensurepip --upgrade
	fi
	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade wheel


	if ! command -v 'pipx' &>/dev/null; then
		core.print_info "Installing pipx"
		python3 -m pip install --user pipx
		python3 -m pipx ensurepath
	fi
}

main "$@"
