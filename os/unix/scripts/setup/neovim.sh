#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Neovim' "$@"
}

install.any() {
	# TODO: install gettext
	util.clone ~/.dotfiles/.data/repos/neovim 'https://github.com/neovim/neovim'
	local dir="$REPLY"

	cd "$dir"
	git switch master
	git pull --ff-only me master

	local channel='nightly' # or stable
	git fetch me "$channel"
	if git show-ref --quiet refs/heads/build; then
		git branch -D 'build'
	fi
	git switch -c 'build' "tags/$channel"

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

main "$@"
