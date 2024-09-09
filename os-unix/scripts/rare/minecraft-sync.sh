#!/usr/bin/env bash

# Syncs subdirectories like 'resourcepacks', 'saves', 'screenshots' of
# the most common .minecraft directories for all major launchers.

source "${0%/*}/../source.sh"

main() {
	local mc_common_data="$HOME/.dotfiles/.home/Documents/Games/Minecraft_Common_Data"

	local -a minecraft_dirs=(
		~/.minecraft
		"$XDG_DATA_HOME"/multimc/instances/*/.minecraft
		"$XDG_CONFIG_HOME"/hmcl/.minecraft
	)

	for mc_dir in "${minecraft_dirs[@]}"; do
		if [ ! -d "$mc_dir" ]; then
			continue
		fi

		core.print_info "Processing $mc_dir"

		# Sync Common Files
		# files=(optionsLC.txt optionsof.txt optionsshaders.txt options.txt servers.dat servers.dat_old)
		# files=(servers.dat)

		# Sync Common Directories
		local subdir=
		for subdir in resourcepacks shaderpacks saves screenshots; do
			mkdir -p "$mc_common_data/$subdir"

			printf '%s\n' "  -> Symlinking ./$subdir"
			if [ -L "$mc_dir/$subdir" ]; then
				ln -sfT "$mc_common_data/$subdir" "$mc_dir/$subdir"
			else
				rmdir "$mc_dir/$subdir"
				ln -sfT "$mc_common_data/$subdir" "$mc_dir/$subdir"
			fi
		done; unset -v subdir
	done
}

main "$@"
