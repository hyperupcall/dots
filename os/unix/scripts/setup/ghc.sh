#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install GHC?'; then
		helper.setup "$@"
	fi
}

install.any() {
	core.print_info "Installing haskell"

	mkdir -p "$XDG_DATA_HOME/ghcup"
	ln -s "$XDG_DATA_HOME"/{,ghcup/.}ghcup

	util.req 'https://get-ghcup.haskell.org' | sh

	util.req 'https://get.haskellstack.org' | sh
}

main "$@"
