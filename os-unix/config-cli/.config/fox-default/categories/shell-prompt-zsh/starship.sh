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
	starship init zsh --print-full-init
}
