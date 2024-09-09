#!/usr/bin/env bash

_die() {
	printf '%s\n' 'Error: ' "$1" 2>&1
}

_main() {
	local file="$1"
	local action="$2"
	shift || _die 'Failed shift'
	shift || _die 'Failed shift'

	# shellcheck disable=SC1090
	source "$file"
	if [ "$action" = 'install' ]; then
		install "$@"
	elif [ "$action" = 'uninstall' ]; then
		uninstall "$@"
	elif [ "$action" = 'test' ]; then
		test "$@"
	elif [ "$action" = 'switch' ]; then
		if declare -f 'switch' &>/dev/null; then
			switch "$@"
		fi
	elif [ "$action" = 'launch' ]; then
		launch "$@"
	fi
}

_main "$@"
