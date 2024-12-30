#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup --prefix-fn=install_deps.debian 'Albert' "$@"
	install_albert
}

install_deps.debian() {
	sudo apt-get install -y libarchive-dev autoconf
	sudo apt-get install -y intltool libtool libgmp-dev libmpfr-dev libcurl4-openssl-dev libicu-dev libxml2-dev # pybind11
	sudo apt-get install -y qt6-base-dev qt6-tools-dev qt6-5compat-dev libqt6svg6-dev # albert
}

install_deps.fedora() {
	sudo dnf install -y libarchive-devel autoconf
	sudo dnf install -y intltool libtool libcurl-devel gmp-devel mpfr-devel libicu-devel # pybind11
	sudo dnf install -y qt6-qtbase-devel qt6-qttools-devel qt6-qt5compat-devel qt6-qtsvg-devel qt6-qtscxml # albert
}

install_deps.arch() {
	sudo pacman -Syu --noconfirm libarchive autoconf
	sudo pacman -Syu --noconfirm intltool # pybind11
	sudo pacman -Syu --noconfirm qt6-base qt6-tools qt6-5compat qt6-scxml # albert
}

# Built from scratch because the version from the custom repositories it outdated.
install_albert() {
	local dir="$HOME/.dotfiles/.data/repos/albert"
	util.clone "$dir" 'https://github.com/albertlauncher/albert' --recursive

	cd "$dir"
	git submodule update --init lib/QHotkey

	(
		if [ ! -d lib/pybind11 ]; then
			git submodule add https://github.com/pybind/pybind11 lib/pybind11
		fi
		cd lib/pybind11
		git switch --detach v2.11.1
		if [ ! -f ./.venv/bin/activate ]; then
			python3 -m venv .venv
		fi
		source .venv/bin/activate
		python3 -m pip --require-virtualenv install --upgrade pip
		python3 -m pip --require-virtualenv install -r tests/requirements.txt
		cmake -S . -B build -DDOWNLOAD_CATCH=ON -DDOWNLOAD_EIGEN=ON
		cmake --build build -j$(nproc)
		sudo cmake --install build
	)


	(
		if [ ! -d lib/Qalculate ]; then
			git submodule add https://github.com/Qalculate/libqalculate lib/Qalculate
		fi
		cd lib/Qalculate
		git switch --detach v4.9.0
		./autogen.sh
		./configure --prefix=/usr/local
		make
		sudo make install
	)

	mise install cmake
	PATH="$XDG_DATA_HOME/mise/shims:$PATH"
	cmake -B build -S . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Debug
	cmake --build build
	sudo cmake --install build
}

configure.any() {
	mkdir -p "$XDG_CONFIG_HOME/autostart"
	cat <<EOF > "$XDG_CONFIG_HOME/autostart/albert.desktop"
[Desktop Entry]
Categories=Utility;
Comment=A desktop agnostic launcher
Exec=bash -c 'env LD_LIBRARY_PATH="/usr/local/lib:$HOME/Qt/6.6.1/gcc_64/lib" /usr/local/bin/albert --platform xcb; sleep 9; /usr/local/bin/albert restart'
GenericName=Launcher
Icon=albert
Name=Albert
StartupNotify=false
Type=Application
Version=1.0
# Give desktop environments time to init. Otherwise QGnomePlatform does not correctly pick up the palette.
X-GNOME-Autostart-Delay=3
EOF

}

installed() {
	command -v albert &>/dev/null
}

util.is_executing_as_script && main "$@"
