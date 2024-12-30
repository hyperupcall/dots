#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Maestral' "$@"
}

install.debian() {
	sudo apt-get install -y python3-dev python3-venv cython libsystemd-dev qt5-default
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.pop() {
	sudo apt-get install -y python3-dev python3-venv cython3 libsystemd-dev
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.neon() {
	sudo apt-get install -y python3-dev python3-venv cython3 libsystemd-dev qt5-default
	sudo apt-get install -y libxcb-cursor0 # maestral gui
	install_maestral "$@"
}

install.fedora() {
	sudo dnf install -y python3 python3-devel cython systemd-devel qt5-qtbase-devel
}

install.opensuse() {
	sudo zypper -n install python311 python-devel python311-cython systemd-devel libqt5-qtbase-devel
	install_maestral "$@"
}

install.arch() {
	sudo pacman -Syu --noconfirm python3
}

install.any() {
	install_maestral "$@"
}

install_maestral() {
	mkdir -p ~/.dotfiles/.data/maestral
	cd ~/.dotfiles/.data/maestral
	~/scripts/setup/python-tools.sh --no-confirm

	if [ -f ./venv/bin/activate ]; then
		core.print_info 'Found virtualenv'
	else
		core.print_info 'Creating virtualenv'
		python3 -m venv ./venv
	fi
	source ./venv/bin/activate

	python3 -m pip --require-virtualenv install --upgrade pip
	python3 -m pip --require-virtualenv install --upgrade wheel
	python3 -m pip --require-virtualenv install --upgrade importlib_metadata # Fedora 39
	python3 -m pip --require-virtualenv install --upgrade maestral
	python3 -m pip --require-virtualenv install --upgrade 'maestral[gui]'
	python3 -m pip --require-virtualenv install --upgrade 'maestral[syslog]' # May fail

	mkdir -p ~/.dotfiles/.data/bin
	cat <<'EOF' > ~/.dotfiles/.data/bin/maestral
#!/usr/bin/env sh
set -e
. ~/.dotfiles/.data/maestral/venv/bin/activate
maestral "$@"
EOF
	chmod +x ~/.dotfiles/.data/bin/maestral

	maestral auth link
	mkdir -p ~/Dropbox-Maestral
	maestral config set path "$HOME/Dropbox-Maestral"
	maestral autostart --yes
	maestral start
}

util.is_executing_as_script && main "$@"
