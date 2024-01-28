#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "It seems you have already bootstraped your dotfiles, do you wish to do it again?"; then :; else
			util.die 'Exiting'
		fi
	fi

	# Ensure prerequisites
	util.ensure mkdir -p "$XDG_CONFIG_HOME"

	# Install generally useful dependencies
	util.get_package_manager
	case $REPLY in
	pacman)
		sudo pacman -Syyu --noconfirm
		sudo pacman -S --noconfirm base-devel
		sudo pacman -S --noconfirm lvm2
		sudo pacman -S --noconfirm openssl # for starship
		;;
	apt)
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install apt-transport-https
		sudo apt-get -y install build-essential
		sudo apt-get -y install lvm2
		sudo apt-get -y install libssl-dev # for starship
		;;
	dnf)
		sudo dnf -y update
		sudo dnf install dnf-plugins-core # For at least Brave
		sudo dnf -y install @development-tools
		sudo dnf -y install lvm2
		sudo dnf -y install openssl-devel # for starship
		;;
	zypper)
		sudo zypper -y update
		sudo zypper -y upgrade
		sudo zypper -y install -t pattern devel_basis
		sudo zypper -y install lvm
		sudo zypper -y install openssl-devel # for starship
		;;
	esac
	util.install_packages bash-completion curl rsync pass
	util.install_packages pkg-config # for starship
	util.install_packages cmake ccache vim nano
	if util.is_cmd 'jq'; then
		core.print_info 'Already installed jq'
	else
		core.print_info 'Installing jq'
		util.install_packages 'jq'
	fi

	# Remove distribution specific dotfiles
	util.ensure mkdir -p ~/.bootstrap/distro-dots
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			util.ensure mv "$file" ~/.bootstrap/distro-dots
		fi
	done

	~/scripts/setup/dotdrop.sh

	# Get GithHub authorization tokens
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=
		hostname=$(hostname)

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -eri "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	> ~/.bootstrap/done :
	printf '%s\n' 'Done.'
}

main "$@"
