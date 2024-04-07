#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install ZFS?'; then
		helper.setup "$@"
	fi
}

# DEBIAN_FRONTEND=noninteractive # TODO

install.debian() {
	pkg.add_apt_repository \
		"deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian bookworm-backports main contrib
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian bookworm-backports main contrib" \
		'/etc/apt/sources.list.d/bookworm-backports.list'

    dest_file=/etc/apt/preferences.d/90_zfs
    printf '%s\n' "Package: src:zfs-linux
Pin: release n=bookworm-backports
Pin-Priority: 990" | sudo tee "$dest_file" >/dev/null

    sudo apt update
    sudo apt-get install -y dpkg-dev linux-headers-generic linux-image-generic
    sudo apt-get install -y zfs-dkms zfsutils-linux
}

install.ubuntu() {
	install.debian "$@"
}

install.fedora() {
	sudo dnf remove -y zfs-fuse
	sudo dnf install -y "https://zfsonlinux.org/fedora/zfs-release-2-4$(rpm --eval "%{dist}").noarch.rpm"
	sudo dnf install -y kernel-devel
	sudo dnf install -y zfs
	sudo modprobe zfs
	printf '%s\n' zfs | sudo tee /etc/modules-load.d/zfs.conf >/dev/null
	printf '%s\n' zfs | sudo tee /etc/dnf/protected.d/zfs.conf >/dev/null
}

main "$@"
