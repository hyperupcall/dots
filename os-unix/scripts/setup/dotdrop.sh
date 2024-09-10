#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Dotdrop' "$@"
}

install.any() {
	mkdir -p ~/.dotfiles/.data/workspace/dotdrop
	cd ~/.dotfiles/.data/workspace/dotdrop

	if [ -d ./repository ]; then
		core.print_info 'Found dotdrop repository'
	else
		core.print_info 'Downloading dotdrop repository'
		util.clone ./repository https://github.com/deadc0de6/dotdrop
	fi
	cd ./repository
	# TODO: apt-get install -y python3-venv
	if [ -f ./venv/bin/activate ]; then
		core.print_info 'Found virtualenv'
	else
		core.print_info 'Creating virtualenv'
		python3 -m venv ./venv
	fi
	source ./venv/bin/activate

	python3 -m pip install --upgrade pip
	python3 -m pip install --upgrade wheel
	python3 -m pip install -r ./requirements.txt

	mkdir -p ~/.dotfiles/.data/bin
	cat <<'EOF' > ~/.dotfiles/.data/bin/dotdrop
	#!/usr/bin/env sh
	set -e
	. ~/.dotfiles/.data/workspace/dotdrop/repository/venv/bin/activate
	~/.dotfiles/.data/workspace/dotdrop/repository/dotdrop.sh "$@"
EOF
	chmod +x ~/.dotfiles/.data/bin/dotdrop
}
