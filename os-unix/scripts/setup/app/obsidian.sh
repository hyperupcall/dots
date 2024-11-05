#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Obsidian' "$@"
}

install.any() {
	if ! command -v appimagelauncherd &>/dev/null; then
		core.print_die "This scripts depends on the installation of AppImageLauncher"
	fi

	util.get_latest_github_tag 'obsidianmd/obsidian-releases'
	local latest_tag="$REPLY"

	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"

		core.print_info 'Downloading and Installing Obsidian AppImage'
		local latest_version="${latest_tag#v}"
		local file='Obsidian.AppImage'
		curl -K "$CURL_CONFIG" -o "$file" "https://github.com/obsidianmd/obsidian-releases/releases/download/$latest_tag/Obsidian-$latest_version.AppImage"
		chmod +x "$file"
		exec ./"$file" # TODO: Launch background
	)
}

main "$@"
