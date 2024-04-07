#!/usr/bin/env bash

source "${0%/*}/../source.sh"
main() {
	if util.confirm 'Install Mise?'; then
		helper.setup "$@"
	fi
}

install.any() {
	curl https://mise.jdx.dev/install.sh | sh
}

main "$@"
