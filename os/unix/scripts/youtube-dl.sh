#!/usr/bin/env zsh

source "${0%/*}/source.sh"

main() {
	local url="$1"

	mkdir -p ~/.dotfiles/.home/Downloads/Temporary_Music
	cd ~/.dotfiles/.home/Downloads/Temporary_Music

	# yt-dlp --ignore-config --no-write-thumbnail -o "%(title)s.%(ext)s" --no-mtime --no-call-home --audio-quality 0 --extract-audio --embed-subs "$url"

	# find . -exec sh -c '
	# 	case $0 in
	# 	*.mp3)
	# 		exit 0
	# 	;;
	# 	esac

	# 	if [ -f "${0%.*}.mp3" ]; then
	# 		rm -f "$0"
	# 	else
	# 		ffmpeg -i "$0" "${0%.*}.mp3"
	# 		rm -f "$0"
	# 	fi
	# ' {} \;

	for f in ./**/*; do
		if [ -d "$f" ]; then
			continue
		fi

		if [[ "$f" != *.mp3 ]]; then
			continue
		fi

		local dir=${f%/*}
		dir=${dir##*/}
		local title=${f##*/}

		echo "$dir: $title"

		eyeD3 --remove-v1 --to-v2.3 --artist 'Hiroyuki Sawano' --album "AoT $dir" --genre 'Anime' --title "$title" "$f"
	done
}

main "$@"
