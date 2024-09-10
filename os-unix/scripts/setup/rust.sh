#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Rust' "$@"
}

install.any() {
	core.print_info "Installing rustup"
	curl -K "$CURL_CONFIG" https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y

	rustup default nightly
}

configure.any() {
	cargo install --locked starship
	cargo install --locked cargo-binstall
	cargo install --locked fd-find
	cargo install --locked modenv
	cargo install --locked bat
}

main "$@"
