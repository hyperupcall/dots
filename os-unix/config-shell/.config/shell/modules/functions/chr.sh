# shellcheck shell=sh

#clone(user, root)
chr() {
	[ -z "$1" ] && { _shell_util_die "chr: No mountpoint specified"; return 1; }
	[ -d "$1" ] || { _shell_util_die "chr: Folder doesn't exist"; return; }

	command -v arch-chroot >/dev/null 2>&1 && {
		if [ "$TERM" = xterm-kitty ]; then
			TERM="xterm-256color" sudo arch-chroot "$@"
		else
			sudo arch-chroot "$@"
		fi
	}

	sudo mount -o bind -t proc /proc "$1/proc"
	sudo mount -o bind -t sysfs /sys "$1/sys"
	sudo mount -o bind -t tmpfs /run "$1/run"
	sudo mount -o bind -t devtmpfs /dev "$1/dev"

	if [ "$TERM" = xterm-kitty ]; then
			TERM="xterm-256color" sudo chroot "$@"
	else
			sudo chroot "$@"
	fi
}

#clone(user, root)
unchr() {
	[ -z "$1" ] && { _shell_util_die "unchr: No mountpoint specified"; return; }
	[ -d "$1" ] || { _shell_util_die "unchr: Folder doesn't exist"; return; }

	umount "$1/proc"
	umount "$1/sys"
	umount "$1/run"
	umount "$1/dev"
}
