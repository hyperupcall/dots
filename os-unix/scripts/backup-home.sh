#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	local save_dir="$HOME"
	local backup_dir="/storage/vault/rodinia/Backups/backup_storage_home"

	# shellcheck disable=SC2059
	printf "Backing up\n  from: $save_dir\n  to:   $backup_dir\n"
	if util.confirm; then
		if [ ! -d "$backup_dir" ]; then
			core.print_die "Backup directory does not exist"
		fi

		borg create \
			--show-version --show-rc --verbose --stats --progress \
			--exclude '**/brave-browser*' \
			--exclude '**/chromium*' \
			--exclude '**/firefox*' \
			--exclude '**/llvm-project*' \
			--exclude '**/gcc*' \
			--exclude '**/android*' \
			--exclude '**/buildroot*' \
			--exclude '**/linux*' \
			--exclude '**/rootfs*' \
			--exclude '**/rustup/toolchains' \
			--exclude '**/cargo/registry' \
			--exclude '**/mise/installs' \
			--exclude '**/pnpm/store' \
			--exclude '**/node_modules' \
			--exclude '**/__pycache__' \
			--exclude '**/target' \
			--exclude '**/dist' \
			--exclude '**/output' \
			--exclude '**/build' \
			--exclude '**/.Trash-1000' \
			--exclude '**/aria2c' \
			--exclude '**/Torrents' \
			--exclude '**/youtube-dl' \
			--exclude '**/Dls' \
			--exclude '**/*.git' \
			--exclude '**/.git' \
			--exclude '**/.hg' \
			--exclude '**/.svn' \
			--exclude '**/.cache' \
			"$backup_dir"::'backup-{now}' \
			"$save_dir"
	fi
}

main "$@"
