#!/usr/bin/env zsh

source "${0%/*}/source.sh"

main() {
	local url="$1"

	yt-dlp --ignore-config --no-write-thumbnail -o "%(channel)s-%(title)s.%(ext)s" --no-mtime --no-call-home --audio-quality 0 --embed-subs "$url"

	# for f in ./*.mp4; do out=${f%.mp4}.mp3; ffmpeg -i "$f" -i ~/Downloads/3d.jpg -c:v copy -map 0:a:0 -map 1:v:0 "$out"; done
}

main "$@"
