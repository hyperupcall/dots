#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'LLVM' "$@"
}

install.debian() {
	local dist='jammy'
	local version='17'
	local gpg_file="/etc/apt/keyrings/apt.llvm.org.asc"

	pkg.add_apt_key \
		'https://apt.llvm.org/llvm-snapshot.gpg.key' \
		"$gpg_file"

	pkg.add_apt_repository \
	"deb [signed-by=$gpg_file] http://apt.llvm.org/$dist/ llvm-toolchain-$dist-$version main
deb-src [signed-by=$gpg_file] http://apt.llvm.org/$dist/ llvm-toolchain-$dist-$version main" \
		'/etc/apt/sources.list.d/llvm.list'

	sudo apt-get -y update
	sudo apt-get -y install clang-17
}

util.is_executing_as_script && main "$@"
