#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'pass' "$@"

	if util.confirm 'Clone password repository?'; then
		local dir="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

		if [ -d "$dir" ]; then
			if [ -d "$dir/.git" ]; then
				core.print_info "Secrets repository already cloned"
			else
				core.print_die "Non-git directory already exists in place of secrets dir. Please remove manually"
			fi
		else
			git clone 'git@github.com:hyperupcall/secrets' "$dir"
		fi
	fi
}

install.debian() {
	sudo apt-get -y update
	sudo apt-get -y install pass
}

install.fedora() {
	sudo dnf -y update
	sudo dnf -y install pass
}

install.opensuse() {
	sudo zypper -n refresh
	sudo zypper -n install password-store
}

install.arch() {
	yay -Syu --noconfirm pass
}

main "$@"
