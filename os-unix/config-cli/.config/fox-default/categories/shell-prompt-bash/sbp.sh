# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/sbp"

install() {
	git clone 'https://github.com/brujoand/sbp' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	printf '%s\n' "SBP_PATH=\"$dir\""
	printf '%s\n' "source \$SBP_PATH/sbp.bash"
}
