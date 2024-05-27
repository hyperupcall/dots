#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	local -r fingerprints=('6EF89C3EB889D61708E5243DDA8EF6F306AD2CBA' '4C452EC68725DAFD09EC57BAB2D007E5878C6803')

	if [ ! -e '/proc/sys/kernel/osrelease' ]; then
		core.print_die "File '/proc/sys/kernel/osrelease' not found"
	fi

	if [[ $(</proc/sys/kernel/osrelease) =~ 'WSL2' ]]; then
		# WSL
		core.print_info "Copying SSH keys from windows side"
		local name='Edwin'
		for file in "/mnt/c/Users/$name/.ssh"/*; do
			if [ ! -f "$file" ]; then
				continue
			fi

			if [[ "${file##*/}" == @(config|environment|known_hosts) ]]; then
				continue
			fi

			mkdir -vp ~/.ssh
			cp -v "$file" ~/.ssh
		done; unset -v file

		local gpg_dir="/mnt/c/Users/$name/AppData/Roaming/gnupg"
		if [ -d "$gpg_dir" ]; then
			gpg --homedir "$gpg_dir" --armor --export-secret-key "${fingerprints[@]}" | gpg --import
		else
			core.print_warn "Skipping importing GPG keys as directory does not exist"
		fi
	else
		# Not WSL
		local gpg_dir='/storage/ur/storage_other/gnupg'
		if [ -d "$gpg_dir" ]; then
			gpg --homedir "$gpg_dir" "${fingerprints[@]}" --export-ownertrust | gpg --import-ownertrust
			gpg --homedir "$gpg_dir" --armor --export-secret-key "${fingerprints[@]}" | gpg --import
		else
			core.print_warn "Skipping importing GPG keys from /storage/ur subdirectory"

			find_mnt_usb '6044-5CC1' # DUPLICATED
			local block_dev_target=$REPLY
		fi
	fi
}

main "$@"
