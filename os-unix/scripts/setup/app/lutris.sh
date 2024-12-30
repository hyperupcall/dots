#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Lutris' "$@"
}

install.ubuntu() {
	local temp_dir=
	temp_dir=$(mktemp -d)
	cd "$temp_dir"

	util.get_latest_github_tag 'lutris/lutris'
	local version="$REPLY"
	version=${version#v}

	curl -K "$CURL_CONFIG" -o 'lutris.deb' "https://github.com/lutris/lutris/releases/download/v${version}/lutris_${version}_all.deb"
	sudo apt install './lutris.deb'
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/lutris.asc"

	pkg.add_apt_key \
		'https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [signed-by=$gpg_file] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" \
		'/etc/apt/sources.list.d/lutris.list'
}

install.fedora() {
	sudo dnf install -y lutris
}

install.opensuse() {
	sudo zypper -n install lutris
}

install.arch() {
	sudo pacman -Syu --noconfirm lutris
}

util.is_executing_as_script && main "$@"
