#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'My tools' "$@"
}

install.any() {
	if ! command -v cargo &>/dev/null; then
		~/scripts/setup/rust.sh
	fi

	cargo install \
		fox-template \
		fox-dotfile \
		fox-repo \
		fox-repos \
		fox-default
}

main "$@"
