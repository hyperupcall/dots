#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Neovim' "$@"
}

install.any() {
	helper.setup --no-confirm --fn-prefix=install_gettext.debian
	install_gettext.debian() {
		sudo apt-get -y install gettext
	}
	install_gettext.fedora() {
		sudo dnf install -y gettext
	}
	install_gettext.opensuse() {
		sudo zypper -n install gettext
	}
	install_gettext.arch() {
		sudo pacman -Syu --noconfirm gettext
	}

	local dir="$HOME/.dotfiles/.data/repos/neovim"
	util.clone "$dir" 'https://github.com/neovim/neovim'

	cd "$dir"
	git switch master
	git pull --ff-only me master

	# Use "nightly" or "stable".
	local tag='stable'
	git fetch --tags --force me "$tag"
	if git show-ref --quiet 'refs/heads/build'; then
		git branch -D 'build'
	fi
	git switch -c 'build' "tags/$tag"

	rm -rf './build'
	mkdir -p './build'

	make distclean
	make deps
	make CMAKE_BUILD_TYPE=Release
	sudo make install
}

install.arch() {
	yay -S --noconfirm neovim
}

util.is_executing_as_script && main "$@"
