#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'VSCode and VSCode Insiders' "$@"
}

install.arch() {
	yay -S visual-studio-code-bin visual-studio-code-insiders-bin
}

install.debian() {
	local gpg_file="/etc/apt/keyrings/microsoft.asc"

	pkg.add_apt_key \
		'https://packages.microsoft.com/keys/microsoft.asc' \
		"$gpg_file"

	pkg.add_apt_repository \
		"deb [arch=amd64,arm64,armhf signed-by=$gpg_file] https://packages.microsoft.com/repos/code stable main" \
		'/etc/apt/sources.list.d/vscode.list'

	sudo apt-get -y update
	sudo apt-get -y install code code-insiders
}

install.fedora() {
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
		| sudo tee '/etc/yum.repos.d/vscode.repo' >/dev/null

	sudo dnf -y update
	sudo dnf -y install code code-insiders
}

install.opensuse() {
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
		| sudo tee '/etc/zypp/repos.d/vscode.repo' >/dev/null

	sudo zypper refresh
	sudo zypper -n install code code-insiders
}

main "$@"
