#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'GHC' "$@"
}

install.any() {
	core.print_info "Installing haskell"

	mkdir -p "$XDG_DATA_HOME/ghcup"
	ln -s "$XDG_DATA_HOME"/{,ghcup/.}ghcup

	curl -K "$CURL_CONFIG" 'https://get-ghcup.haskell.org' | sh
	curl -K "$CURL_CONFIG" 'https://get.haskellstack.org' | sh
}

main "$@"
