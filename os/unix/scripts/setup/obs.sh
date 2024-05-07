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
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install com.obsproject.Studio
	fi
}

main "$@"
