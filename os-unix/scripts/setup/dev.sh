#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'dev' "$@"
}

install.any() {
	if [ ! -d ~/.dev ]; then
		git clone git@github.com:fox-incubating/dev ~/.dev
	fi

	mkdir -p ~/.dev/.data/nodejs
	cd ~/.dev/.data/nodejs

	local nodejs_version='22.11.0'
	local file="node-v$nodejs_version-linux-x64.tar.xz"
	if [ ! -f "$file" ]; then
		core.print_info "Downloading NodeJS $nodejs_version"
		curl -K "$CURL_CONFIG" "https://nodejs.org/dist/v$nodejs_version/$file"
		core.print_info "Extracting..."
		tar xf ./"node-v$nodejs_version"*
	fi
	cd ./"node-v$nodejs_version"*/

	local bin_dir="$PWD"
	bin_dir=${bin_dir#/home/}
	bin_dir=${bin_dir#*/}
	bin_dir="\$HOME/$bin_dir/bin"

	PATH="$bin_dir:$PATH"
	cd ~/.dev/
	npm i -g pnpm
	pnpm install

	cat <<-EOF > ~/.dotfiles/.data/bin/dev
	#!/usr/bin/env sh
	set -e
	PATH="$bin_dir:\$PATH" ~/.dev/bin/dev.js "\$@"
EOF
	chmod +x ~/.dotfiles/.data/bin/dev
}

installed() {
	command -v dev &>/dev/null
}

main "$@"
