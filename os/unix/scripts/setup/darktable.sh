#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'darktable' "$@"
}

install.any() {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y org.darktable.Darktable
}
