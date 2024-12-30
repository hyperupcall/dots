#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Steam' "$@"
}

install.debian() {
	local temp_dir=
	temp_dir="$(mktemp -d)"
	cd "$temp_dir"

	curl -K "$CURL_CONFIG" -o ./steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
	# With `apt-get install`, it might automatically choose 'steam-launcher' from repository.
	sudo dpkg -i ./steam.deb
}

install.opensuse() {
	flatpak install -y  --user --from 'https://flathub.org/repo/appstream/com.valvesoftware.Steam.flatpakref'
	sudo zypper -n install steam-devices
}

util.is_executing_as_script && main "$@"
