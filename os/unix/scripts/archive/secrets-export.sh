#!/usr/bin/env bash

# Description:
# This exports gpg keys, ssh keys, and the pass database to your 'secrets' USB.
# Everything is encrypted with a passphrase. This script Just Works, whether or not the
# USB is already mounted

source "${0%/*}/../source.sh"

main() {
	sudo -v

	find_mnt_usb '6044-5CC1' # DUPLICATED
	local block_dev_target=$REPLY

	# Now, file system is mounted at "$block_dev_target"

	local password=
	password=$(LC_ALL=C tr -dc '[:alnum:][:digit:]' </dev/urandom | head -c 12; printf '\n')
	core.print_info "Password: $password"

	# Copy over ssh keys
	local -r sshDir="$HOME/.ssh"
	local -a sshKeys=(environment config github github.pub)
	if [ -d "$sshDir" ]; then
		exec 4> >(sudo tee "$block_dev_target/ssh-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			cd "$sshDir"
			tar -c ${sshKeys[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			core.print_die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		core.print_warn "Skipping copying ssh keys"
	fi

	# Copy over gpg keys
	local -r fingerprints=('6EF89C3EB889D61708E5243DDA8EF6F306AD2CBA' '4C452EC68725DAFD09EC57BAB2D007E5878C6803')
	local gpg_dir="$HOME/.gnupg"
	if [ -d "$gpg_dir" ]; then
		exec 4> >(sudo tee "$block_dev_target/gpg-keys.tar.age" >/dev/null)
		if expect -f <(cat <<-EOF
			set bashFd [lindex \$argv 0]
			spawn bash \$bashFd

			expect -- "Enter passphrase*"
			send -- "$password\n"
			expect -- "Confirm passphrase*"
			send -- "$password\n"
			expect eof

			set result [wait]
			if {[lindex \$result 2] == 0} {
				exit [lindex \$result 3]
			} else {
				error "An operating system error occurred, errno=[lindex \$result 3]"
			}
		EOF
		) <(cat <<-EOF
			set -eo pipefail

			gpg --export-secret-keys --armor ${fingerprints[*]} | age --encrypt --passphrase --armor >&4
		EOF
		); then :; else
			core.print_die "Command 'expect' failed (code $?)"
		fi
		exec 4<&-
	else
		core.print_warn "Skipping copying gpg keys"
	fi
}

main "$@"
