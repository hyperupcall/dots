#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Mise' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://mise.jdx.dev/install.sh | sh
}

util.is_executing_as_script && main "$@"
