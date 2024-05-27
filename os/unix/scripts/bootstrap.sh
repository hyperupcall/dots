#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "You have already bootstraped your dotfiles. Do you wish to do it again?"; then :; else
			core.print_info 'Exiting'
			exit 0
		fi
	fi

	helper.setup 'Bootstrap' "$@"

	# Ensure prerequisites.
	mkdir -p "$XDG_CONFIG_HOME"

	# Remove distribution-specific dotfiles.
	mkdir -p ~/.bootstrap/distro-dots
	for file in ~/.bash_login ~/.bash_logout ~/.bash_profile ~/.bashrc ~/.profile; do
		if [[ ! -L "$file" && -f "$file" ]]; then
			mv "$file" ~/.bootstrap/distro-dots
		fi
	done

	# Set current system profile.
	if [ -f ~/.dotfiles/.data/profile ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local cur=
		local options='desktop|laptop'
		while [[ $cur != @($options) ]]; do
			printf '%s' "System profile? ($options): "
			read -er cur
		done
		mkdir -p ~/.dotfiles/.data
		printf '%s\n' "$cur" > ~/.dotfiles/.data/profile
	fi

	# Fetch GithHub authorization tokens.
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=$HOSTNAME

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -eri "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	~/scripts/setup/dotdrop.sh

	> ~/.bootstrap/done :
	printf '%s\n' 'Done.'
}

install.arch() {
	sudo pacman -Syyu --noconfirm
	sudo pacman -Syu --noconfirm base-devl lvm2 openssl yay
}

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y upgrade

	sudo apt-get -y install apt-transport-https build-essential lvm2
	sudo apt-get -y install bash-completion curl rsync pass cmake ccache vim nano jq
	sudo apt-get -y install pkg-config libssl-dev # For starship
}

install.fedora() {
	sudo dnf -y update

	sudo dnf -y install @development-tools lvm2
	sudo dnf -y install bash-completion curl rsync pass cmake ccache vim nano jq
	sudo dnf -y install pkg-config openssl-devel # For starship
	sudo dnf -y install dnf-plugins-core # For at least Brave
}

install.opensuse() {
	sudo zypper -y update
	sudo zypper -y upgrade

	sudo zypper -y install -t pattern devel_basis lvm
	sudo zypper -y install bash-completion curl rsync pass cmake ccache vim nano jq
	sudo zypper -y install pkg-config openssl-devel # For starship
}

main "$@"
