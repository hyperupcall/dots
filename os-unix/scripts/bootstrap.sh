#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "You have already bootstraped your dotfiles. Do you wish to do it again?"; then :; else
			core.print_info 'Exiting'
			exit 0
		fi
	fi

	util.update_system
	helper.setup --no-confirm --fn-prefix=install_packages 'Bootstrap' "$@"

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
		core.print_info 'Already set system profile'
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

	# Download and install NodeJS runtime.
	local dir=("./node-v"*/)
	if [ -d "${dir[0]}" ]; then
		core.print_info 'Already installed NodeJS to ~/.dotfiles/.data/nodejs'
	else
		pushd ~/.dotfiles/.data >/dev/null
		local nodejs_version='22.12.0' # TODO: Update
		local file="./node-v$nodejs_version.tar.xz"
		core.print_info "Downloading NodeJS v$nodejs_version"
		curl -K "$CURL_CONFIG" -o "$file" "https://nodejs.org/dist/v$nodejs_version/node-v$nodejs_version-linux-x64.tar.xz"
		core.print_info "Extracting $file"
		tar xf "$file"
		rm -rf "$file"
		popd >/dev/null
	fi
	if [ ! -f ~/.dotfiles/.data/node ]; then
		ln -sf ~/.dotfiles/.data/node-v*/bin/node ~/.dotfiles/.data/node
	fi

	# Download and install "dev".
	if [ ! -d ~/.dev ]; then
		git clone git@github.com:fox-incubating/dev ~/.dev
	fi
	if [ ! -f ~/.dotfiles/.data/bin/dev ]; then
		cd ~/.dotfiles/.data/nodejs
		local bin_dir="$PWD"
		bin_dir=${bin_dir#/home/}
		bin_dir=${bin_dir#*/}
		bin_dir="\$HOME/$bin_dir/bin"
		PATH="$bin_dir:$PATH"
		cd ~/.dev/
		npm i -g pnpm
		pnpm install

		cat <<-EOF > ~/.dotfiles/.data/bin/dev
		#!/usr/bin/env sh
		set -e
		PATH="$bin_dir:\$PATH" ~/.dev/bin/dev.js "\$@"
	EOF
		chmod +x ~/.dotfiles/.data/bin/dev
	fi

	# Fetch GithHub authorization tokens.
	if [ -f ~/.dotfiles/.data/github_token ]; then
		core.print_info 'Already downloaded GitHub token'
	else
		local hostname=$HOSTNAME

		printf '%s\n' "Go to: https://github.com/settings/tokens/new?description=General+@${hostname}&scopes="
		read -erp "Paste token: "

		local token="$REPLY"
		printf '%s\n' "$token" > ~/.dotfiles/.data/github_token
	fi

	> ~/.bootstrap/done :
	printf '%s\n' 'Done.'
}

install_packages.arch() {
	sudo pacman -Syyu --noconfirm
	sudo pacman -Syu --noconfirm base-devl lvm2 openssl yay
}

install_packages.debian() {
	sudo apt-get -y update && sudo apt-get -y upgrade
	sudo apt-get -y install apt-transport-https build-essential
	sudo apt-get -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore:curl-must-have-args
	sudo apt-get -y install pkg-config libssl-dev # For starship
}

install_packages.fedora() {
	sudo dnf -y update
	sudo dnf -y install @development-tools
	sudo dnf -y install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo dnf -y install pkg-config openssl-devel # For starship
	sudo dnf -y install dnf-plugins-core # For at least Brave
}

install_packages.opensuse() {
	sudo zypper -n update
	sudo zypper -n install -t pattern devel_basis
	sudo zypper -n install bash-completion curl rsync cmake ccache vim nano jq lvm2 # lint-ignore
	sudo zypper -n install pkg-config openssl-devel # For starship
}

main "$@"
