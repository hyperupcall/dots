#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'MongoDB' "$@"
}

install.debian() {
		local gpg_file="/etc/apt/keyrings/mongodb.asc"
		local dist='jammy'

		pkg.add_apt_key \
			'https://www.mongodb.org/static/pgp/server-6.0.asc' \
			"$gpg_file"

		pkg.add_apt_repository \
			"deb [arch=amd64,arm64 signed-by=$gpg_file] https://repo.mongodb.org/apt/ubuntu $dist/mongodb-org/6.0 multiverse" \
			"/etc/apt/sources.list.d/mongodb-6.0.list"

		sudo apt-get -y update
		sudo apt-get install -y mongodb-org
}

util.is_executing_as_script && main "$@"
