#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Git' "$@"
}

install.debian() {
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo apt-get update -y
	sudo apt-get install -y git
}

install.ubuntu() {
	install.debian
}

installed() {
	git_version_check() {
		local -a git_version_arr
		git_version=$(git version)
		git_version=${git_version#git version }
		IFS='.' read -ra git_version_arr <<< "$git_version"
		(( git_version_arr[0] >= 3 || (git_version_arr[0] == 2 && git_version_arr[1] >= 37) ))
	}

	command -v git &>/dev/null && git_version_check
}

util.is_executing_as_script && main "$@"
