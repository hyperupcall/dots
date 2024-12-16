#!/usr/bin/env zsh

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'yt-dlp' "$@"
}

install.any() {
	curl -K "$CURL_CONFIG" -o ~/.local/bin/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
	chmod +x ~/.local/bin/yt-dlp
}

main "$@"
