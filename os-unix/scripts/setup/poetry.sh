#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Poetry' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://install.python-poetry.org | python3 -
}

main "$@"
