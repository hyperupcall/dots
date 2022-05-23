# shellcheck shell=bash

# Name:
# Deploy Dotfiles
#
# Description:
# Executes dotfox with the right arguments. The command is shown before it is ran
# Before executing, however, it removes ~/.config/user-dirs.dirs

helper.dotfox_deploy() {
	prompt_run dotfox --config-dir="$HOME/.dots/user/.config/dotfox" --deployment=all.sh deploy
}

prompt_run() {
	core.print_info "Would you like to run the following?"
	printf '%s\n%s' "$ $*" "(y/n): "
	if ! read -rN1; then
		core.print_die "Failed to get input"
	fi
	printf '\n'

	if [ "$REPLY" = y ]; then
		if "$@"; then :; else
			return $?
		fi
	else
		core.print_info "Skipping command"
	fi
}
