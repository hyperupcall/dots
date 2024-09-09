#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Deno' "$@"
}

install.any() {
	if ! command -v file_server &>/dev/null; then
		if command -v deno &>/dev/null; then
			deno install --allow-net --allow-read https://deno.land/std@0.145.0/http/file_server.ts
		else
			core.print_warn "Deno not installed. Skipping installation of 'file_server'"
		fi
	fi
}

installed() {
	command -v deno &>/dev/null
}

main "$@"
