#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	local flag_no_upgrade=false
	for arg; do case $arg in
	--no-upgrade)
		flag_no_upgrade=true
		;;
	esac done; unset -v arg

	if [ -f ~/.bootstrap/done ]; then
		if util.confirm "You have already bootstraped your dotfiles. Do you wish to do it again?"; then :; else
			core.print_info 'Exiting'
			exit 0
		fi
	fi

	if [ "$flag_no_upgrade" != 'true' ]; then
		util.update_system
		helper.setup --no-confirm --fn-prefix=install_packages 'Bootstrap' "$@"
	fi

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
	local dir=(~/.dotfiles/.data/node-v*/)
	dir=${dir%/}
	local old_nodejs_version="${dir[0]##*/}"
	old_nodejs_version=${old_nodejs_version#node-v}
	old_nodejs_version=${old_nodejs_version%%-*}
	local nodejs_version='23.6.0' # TODO: Update
	if [ -d "${dir[0]}" ] && [ "$old_nodejs_version" = "$nodejs_version" ]; then
		local dir_nice="~${dir[0]#$HOME}"
		core.print_info "Already installed NodeJS to $dir_nice"
	else
		pushd ~/.dotfiles/.data >/dev/null
		local file="./node-v$nodejs_version.tar.xz"
		if [ "$old_nodejs_version" != "$nodejs_version" ] && [ -n "$old_nodejs_version" ]; then
			core.print_info "Removing outdated NodeJS v$old_nodejs_version"
			rm -rf "${dir[0]}"
		fi
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
	cat > "${XDG_DATA_HOME:-$HOME/.local/share}/systemd/user/dev.service" <<-'EOF'
[Unit]
Description=Dev
ConditionPathIsDirectory=%h/.dev

[Service]
Type=simple
WorkingDirectory=%h/.dev
ExecStart=%h/.dotfiles/.data/node %h/.dev/bin/dev.js start-dev-server
Environment=PORT=40008
Restart=on-failure

[Install]
WantedBy=default.target
EOF
	systemctl --user daemon-reload
	systemctl --user enable --now dev.service

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
