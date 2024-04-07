#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup "$@"
}

install.any() {
	util.req -o- https://raw.githubusercontent.com/hyperupcall/basalt/main/scripts/install.sh | sh
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
main "$@"
