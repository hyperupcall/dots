# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/gitstatus"

install() {
	git clone 'https://github.com/romkatv/gitstatus'  "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	printf '%s\n' "export GITSTATUS_DIR=\"$dir/gitstatus.plugin.sh\""
	cat "$dir/gitstatus.prompt.sh"
}
