#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Mise' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh
}

main "$@"
