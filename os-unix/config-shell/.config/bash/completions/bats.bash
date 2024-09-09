# shellcheck shell=bash

# based on https://tylerthrailkill.com/2019-01-19/writing-bash-completion-script-with-subcommands/
_bats() {
	local i=1 cmd

	# iterate over COMP_WORDS (ending at currently completed word)
	# this ensures we bm_get command completion even after passing flags
	while [[ "$i" -lt "$COMP_CWORD" ]]; do
		local s="${COMP_WORDS[i]}"
		case "$s" in
		# if our current word starts with a '-', it is not a subcommand
		-*) ;;
		# we are completing a subcommand, set cmd
		*)			cmd="$s"
			break
			;;
		esac
		(( i++ ))
	done

	# check if we're completing 'dotty'
	if [[ "$i" -eq "$COMP_CWORD" ]]; then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		# shellcheck disable=SC2207
		COMPREPLY=($(compgen -o default -W "-c --count -h --help -p --pretty -t --tap -v --version" -- "$cur"))
		return
	fi

	# if we're not completing 'bats', then we're completing a subcommand
	case "$cmd" in
	*)
		COMPREPLY=() ;;
	esac

} && complete -F _bats bats
