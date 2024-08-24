#!/usr/bin/env bash

source "${0%/*}/source.sh"

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	local part_uuid="c875b5ca-08a6-415e-bc11-fc37ec94ab8f"
	local mnt='/storage/short'
	if ! grep -q "$mnt" /etc/fstab; then
		if [ ! -f ~/.dotfiles/.data/state/no_ask_edit_fstab ]; then
			if util.confirm "Would you like to edit /etc/fstab to add ${mnt}?"; then
				printf '%s\n' "PARTUUID=$part_uuid  $mnt  btrfs  defaults,nofail,noatime,X-mount.mkdir  0 0" \
					| sudo tee -a /etc/fstab >/dev/null
				sudo mount "$mnt"
			else
				mkdir -p ~/.dotfiles/.data/state
				touch ~/.dotfiles/.data/state/no_ask_edit_fstab
			fi
		fi
	fi

	util.add_user_to_group "$USER" 'docker'
	util.add_user_to_group "$USER" 'vboxusers'
	util.add_user_to_group "$USER" 'libvirt'
	util.add_user_to_group "$USER" 'kvm'
	util.add_user_to_group "$USER" 'input'

	~/.dotfiles/os/unix/scripts/utility/create-dirs.sh
	~/.dotfiles/os/unix/scripts/utility/generate-aliases.sh
	~/.dotfiles/os/unix/scripts/utility/generate-dotgen.sh
	~/.dotfiles/os/unix/scripts/utility/generate-dotconfig.sh
}

main "$@"
