#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Mise' "$@"
}

install.any() {
	curl https://mise.jdx.dev/install.sh | sh
}

main "$@"
