#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install VSCode and VSCode Insiders?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_package_manager
	local pkgmngr="$REPLY"

	case $pkgmngr in
	pacman)
		yay -S visual-studio-code-bin visual-studio-code-insiders-bin
		;;
	apt)
		local gpg_file="/etc/apt/keyrings/microsoft.asc"

		pkg.add_apt_key \
			'https://packages.microsoft.com/keys/microsoft.asc' \
			"$gpg_file"

		pkg.add_apt_repository \
			"deb [arch=amd64,arm64,armhf signed-by=$gpg_file] https://packages.microsoft.com/repos/code stable main" \
			'/etc/apt/sources.list.d/vscode.list'

		sudo apt-get -y update
		sudo apt-get -y install code code-insiders
		;;
	dnf)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
			| sudo tee '/etc/yum.repos.d/vscode.repo' >/dev/null

		sudo dnf -y update
		sudo dnf -y install code code-insiders
		;;
	zypper)
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			printf "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n" \
				| sudo tee '/etc/zypp/repos.d/vscode.repo' >/dev/null

		sudo zypper refresh
		sudo zypper -y install code code-insiders
		;;
	*)
		core.print_fatal "Pakage manager '$pkgmngr' not supported"
	esac
}

main "$@"
