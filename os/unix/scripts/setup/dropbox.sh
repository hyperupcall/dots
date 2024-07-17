#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'Dropbox' "$@"
}

install.any() {
	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"

		core.print_info 'Downloading'
		curl -K "$CURL_CONFIG" -o ./dropbox.tar.gz 'https://www.dropbox.com/download?plat=lnx.x86_64'

		core.print_info 'Extracting'
		tar xzf ./dropbox.tar.gz

		core.print_info 'Copying'
		rm -rf ~/.dotfiles/.home/Downloads/.dropbox-dist
		mv ./.dropbox-dist ~/.dotfiles/.home/Downloads

		core.print_info 'Symlinking'
		ln -sf ~/.dotfiles/.home/Downloads/.dropbox-dist/dropboxd ~/.dotfiles/.data/bin/dropboxd
	)
}

main "$@"
