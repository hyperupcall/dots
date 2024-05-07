#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Poetry' "$@"
}

install.any() {
	curl -sSL https://install.python-poetry.org | python3 -
}

main "$@"
