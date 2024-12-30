#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Docker' "$@"
}

install.any() {
	sudo apt-get -y install \
		ca-certificates \
		gnupg \
		lsb-release \
		curl # lint-ignore

	local dist='focal'
	local gpg_file="/etc/apt/keyrings/docker.asc"

	pkg.add_apt_key \
		'https://download.docker.com/linux/ubuntu/gpg' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=$(dpkg --print-architecture) signed-by=$gpg_file] https://download.docker.com/linux/ubuntu $dist stable" \
		'/etc/apt/sources.list.d/docker.list'

	sudo apt-get update -y
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
	sudo groupadd --force docker
	sudo usermod -aG docker "$USER"
}

util.is_executing_as_script && main "$@"
