#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup "$@"
}

install.any() {
	core.print_info "Installing rustup"
	util.req https://sh.rustup.rs | sh -s -- --default-toolchain nightly -y || util.die

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
