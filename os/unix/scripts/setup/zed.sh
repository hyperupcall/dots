#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Zed' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh

}

main "$@"
