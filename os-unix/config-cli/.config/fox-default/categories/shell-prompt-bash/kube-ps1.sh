# shellcheck shell=bash

declare -g dir="$HOME/.dotfiles/.data/repos/kube-ps1"

install() {
	git clone 'https://github.com/jonmosco/kube-ps1' "$dir"
}

uninstall() {
	rm -rf "$dir"
}

test() {
	[ -d "$dir" ]
}

launch() {
	cat "$dir/kube-ps1.sh"
	printf '%s\n' "PS1=\"[\u@\h \W \$(kube_ps1)]\\$ \""
}
