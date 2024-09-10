#!/usr/bin/env bash

# Registers all VirtualBox virtual machine. Optionally
# enables unregistering all virtual machines

source ~/.dotfiles/os-unix/data/source.sh

main() {
    local virtualbox_dir=/storage/bigfiles/VirtualBox_Machines

	if command -v VBoxManage &>/dev/null; then
		VBoxManage setproperty machinefolder "$virtualbox_dir"
	else
		core.print_die "Must have command 'VBoxManage' installed"
	fi

	core.shopt_push -s nullglob

	local flag_unregister='no'

	for arg; do case $arg in
		--help|-h) printf '%s\n' "Usage: $0 [-h|--help] [--unregister] (add is default)" ;;
		--unregister) flag_unregister='yes'
	esac done

	if [ "$flag_unregister" = 'yes' ]; then
		while IFS= read -r line; do
			printf '%s\n' "Removing '${line}'"
			local uuid="${line%\}}"
			uuid=${uuid##*\{}
			VBoxManage unregistervm "$uuid"
		done < <(VBoxManage list vms)
		return
	fi

	if [ ! -d "$virtualbox_dir" ]; then
		core.print_die "Could not find directory '$virtualbox_dir'"
	fi

	# Add all
	for group_dir in "$virtualbox_dir"/*/; do
		register "${group_dir%/}"

		#for vm_dir in "$group_dir"*/; do
		#	register "${vm_dir%/}"
		#done
	done

	core.shopt_pop
}

register() {
	local dir="$1"
    printf '%s\n' "Registering: $dir"

	for file in "$dir"/*.vbox; do
		printf '%s\n' "Adding '$file'"
		VBoxManage registervm "$file"
	done
}

main "$@"
