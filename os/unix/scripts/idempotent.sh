#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	# -------------------------------------------------------- #
	#                     MOUNT /STORAGE/UR                    #
	# -------------------------------------------------------- #
	# TODO
	# if [ "$profile" = 'desktop' ]; then
	# 	local part_uuid="c875b5ca-08a6-415e-bc11-fc37ec94ab8f"
	# 	local mnt='/storage/ur'
	# 	if ! grep -q "$mnt" /etc/fstab; then
	# 		printf '%s\n' "PARTUUID=$part_uuid  $mnt  btrfs  defaults,noatime,X-mount.mkdir  0 0" \
	# 			| sudo tee -a /etc/fstab >/dev/null
	# 		sudo mount "$mnt"
	# 	fi
	# fi

	~/.dotfiles/os/unix/scripts/utility/create-dirs.sh
	~/.dotfiles/os/unix/scripts/utility/generate-aliases.sh
	~/.dotfiles/os/unix/scripts/utility/generate-dotgen.sh
	~/.dotfiles/os/unix/scripts/utility/generate-dotconfig.sh
}

main "$@"
