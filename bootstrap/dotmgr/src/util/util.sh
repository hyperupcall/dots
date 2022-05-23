# shellcheck shell=bash

util.req() {
	curl --proto '=https' --tlsv1.2 -sSLf "$@"
}

util.run() {
	print.info "Executing '$*'"
	if "$@"; then
		return $?
	else
		return $?
	fi
}

util.ensure() {
	if "$@"; then :; else
		print.die "'$*' failed (code $?)"
	fi
}

util.is_cmd() {
	if command -v "$1" &>/dev/null; then
		return $?
	else
		return $?
	fi
}

util.ensure_bin() {
	if ! command -v "$1" &>/dev/null; then
		print.die "Command '$1' does not exist"
	fi
}

util.clone() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir" ]; then
		print.info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir"
	fi
}

util.clone_in_dots() {
	local repo="1"
	util.clone "$repo" ~/.dots/.repos/"${repo##*/}"
}

util.ensure_profile_read() {
	local has_found_profile='no'
	for profile_file in  "$DOTMGR_ROOT/src/profiles"/?*.sh; do
		source "$profile_file"
		local profile_name="${profile_file##*/}"; profile_name=${profile_name%.sh}

		if "$profile_name".check; then
			"$profile_name".vars
			has_found_profile='yes'
			break
		fi
	done

	if [ "$has_found_profile" = 'no' ]; then
		print.die 'No matching profile could be found'
	fi
}

util.prereq() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
		# shellcheck disable=SC2016
		print.die '$XDG_CONFIG_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_DATA_HOME" ]; then
		# shellcheck disable=SC2016
		print.die '$XDG_DATA_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi

	if [ -z "$XDG_STATE_HOME" ]; then
		# shellcheck disable=SC2016
		print.die '$XDG_STATE_HOME is empty. Did you source profile-pre-bootstrap.sh?'
	fi
}

util.show_help() {
	cat <<-EOF
		Usage:
		  dotmgr [command]

		Commands:
		  bootstrap-stage1
		    Bootstrap operations that occur before dotfiles have been deployed

		  info
		    Get information about the current system. Currently, it lists
		    information about the current profile

		  action
		    Perform a particular action. If no action was given, show
		    a selection screen for the different actions

		  module [--list] [--show] [--edit] [stage]
		    Bootstraps dotfiles, only for a particular language

		  sudo
		    Run this script with superuser priviledges. This runs an entirely different
		    set of commands

		Flags:
		  --help
		    Show help menu

		Examples:
		  dotmgr bootstrap-stage1
		  dotmgr module rust
	EOF
}
