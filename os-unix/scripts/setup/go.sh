#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Go' "$@"
}

install.any() {
	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/tools/cmd/godoc@latest
	go install golang.org/x/tools/cmd/goimports@latest

	go install github.com/motemen/gore/cmd/gore@latest
	go install github.com/mdempsky/gocode@latest
}

util.is_executing_as_script && main "$@"
