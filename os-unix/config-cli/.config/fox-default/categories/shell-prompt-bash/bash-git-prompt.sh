# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/bash-git-prompt"

install() {
	git clone 'https://github.com/magicmonty/bash-git-prompt' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	printf '%s\n' "__GIT_PROMPT_DIR=\"$dir\""
	cat "$dir/gitprompt.sh"
}
