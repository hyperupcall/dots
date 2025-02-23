#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'ZFS' "$@"

	if ! sudo zpool status vault &>/dev/null; then
		sudo zpool import -f vault
	fi
	sudo zpool set cachefile=/etc/zfs/zpool.cache vault
	sudo systemctl enable --now zfs-import-cache.service zfs.target zfs-import.target zfs-mount.service
}

install.debian() {
	sudo apt-get update -y
	sudo apt-get install -y debian-archive-keyring

	pkg.add_apt_repository \
		"deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian bookworm-backports main contrib
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian bookworm-backports main contrib" \
		'/etc/apt/sources.list.d/bookworm-backports.list'

	dest_file=/etc/apt/preferences.d/90_zfs
	printf '%s\n' "Package: src:zfs-linux
Pin: release n=bookworm-backports
Pin-Priority: 990" | sudo tee "$dest_file" >/dev/null

	sudo apt-get update -y
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

install.opensuse() {
	source /etc/os-release
	if [ "$ID" = 'opensuse-tumbleweed' ]; then
		if [ ! -f /etc/zypp/repos.d/filesystems.repo ]; then
			sudo zypper -n addrepo https://download.opensuse.org/repositories/filesystems/openSUSE_Tumbleweed/filesystems.repo
		fi
		sudo zypper --gpg-auto-import-keys refresh
		sudo zypper -n install zfs
	else
		core.print_die "Not implemented"
	fi
}

install.arch() {
	 sudo pacman -Syu --noconfirm zfs-linux zfs-linux-lts zfs-dkms
}

install.cachyos() {
	sudo pacman -Syu --noconfirm cachyos-v3/linux-cachyos-zfs cachyos-v3/linux-cachyos-lto-zfs
}

util.is_executing_as_script && main "$@"
