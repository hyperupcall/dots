#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install OBS?'; then
		helper.setup "$@"
	fi
}

install.any() {
	if util.is_cmd 'apt'; then
		sudo add-apt-repository ppa:obsproject/obs-studio
		sudo apt update -y
		sudo apt-get install -y obs-studio
	else
		#flatpak install flathub TODO
		flatpak install com.obsproject.Studio
	fi
}

main "$@"
