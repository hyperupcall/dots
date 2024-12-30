#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Zed' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://zed.dev/install.sh | sh
}

util.is_executing_as_script && main "$@"
