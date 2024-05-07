#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Brave?'; then
		helper.setup "$@"
	fi
}

install.debian() {
	local gpg_file_release="/etc/apt/keyrings/brave-browser-release.gpg"
	local gpg_file_beta="/etc/apt/keyrings/brave-browser-beta.gpg"
	local gpg_file_nightly="/etc/apt/keyrings/brave-browser-nightly.gpg"

	pkg.add_apt_key \
		'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg' \
		"$gpg_file_release"
	pkg.add_apt_key \
		'https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg' \
		"$gpg_file_beta"
	pkg.add_apt_key \
		'https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg' \
		"$gpg_file_nightly"

	pkg.add_apt_repository \
		"deb [arch=amd64,arm64 signed-by=$gpg_file_release] https://brave-browser-apt-release.s3.brave.com/ stable main" \
		'/etc/apt/sources.list.d/brave-browser-release.list'
	pkg.add_apt_repository \
		"deb [arch=amd64,arm64 signed-by=$gpg_file_beta] https://brave-browser-apt-beta.s3.brave.com/ stable main" \
		'/etc/apt/sources.list.d/brave-browser-beta.list'
	pkg.add_apt_repository \
		"deb [arch=amd64,arm64 signed-by=$gpg_file_nightly] https://brave-browser-apt-nightly.s3.brave.com/ stable main" \
		'/etc/apt/sources.list.d/brave-browser-nightly.list'

	sudo apt-get -y update
	sudo apt-get -y install brave-browser brave-browser-beta
}

install.fedora() {
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo dnf config-manager --add-repo https://brave-browser-rpm-beta.s3.brave.com/x86_64/
	sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc

	sudo dnf -y update
	sudo dnf -y install brave-browser brave-browser-beta
}

install.opensuse() {
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo zypper -y addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
	sudo rpm --import https://brave-browser-rpm-beta.s3.brave.com/brave-core-nightly.asc
	sudo zypper addrepo https://brave-browser-rpm-beta.s3.brave.com/x86_64/ brave-browser-beta

	sudo zypper refresh
	sudo zypper -y install brave-browser brave-browser-beta
}

install.manjaro() {
	yay -S brave-browser brave-browser-beta
}

install.arch() {
	yay -S brave brave-bin brave-beta-bin
}

main "$@"
