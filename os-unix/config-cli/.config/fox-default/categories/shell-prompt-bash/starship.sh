# shellcheck shell=bash

install() {
	cargo install starship
}

uninstall() {
	cargo uninstall starship
}

test() {
	command -v starship
}

launch() {
	starship init bash --print-full-init
}
