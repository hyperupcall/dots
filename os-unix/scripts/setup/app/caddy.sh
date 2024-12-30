#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Caddy' "$@"
}

install.debian() {
	sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
	local gpg_file="/etc/apt/keyrings/caddy-stable.asc"

	pkg.add_apt_key \
		'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
		"$gpg_file"
	pkg.add_apt_repository \
			"deb [signed-by=$gpg_file] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main
deb-src [signed-by=$gpg_file] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" \
			'/etc/apt/sources.list.d/caddy-stable.list'

	sudo apt-get update -y
	sudo apt-get install -y caddy
}

util.is_executing_as_script && main "$@"
