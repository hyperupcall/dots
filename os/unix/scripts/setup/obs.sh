#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'OBS' "$@"
}

install.any() {
	if command -v 'apt' &>/dev/null; then
		sudo add-apt-repository ppa:obsproject/obs-studio
		sudo apt-get update -y
		sudo apt-get install -y obs-studio
	else
		#flatpak install flathub TODO
		flatpak install com.obsproject.Studio
	fi
}

main "$@"
