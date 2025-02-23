#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Basalt' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" https://raw.githubusercontent.com/hyperupcall/basalt/main/scripts/install.sh | sh
}

configure.any() {
	basalt global add \
		hyperupcall/autoenv \
		hyperupcall/bake

	basalt global add \
		cykerway/complete-alias \
		rcaloras/bash-preexec \
		reconquest/shdoc
}

installed() {
	command -v basalt &>/dev/null

}

util.is_executing_as_script && main "$@"
