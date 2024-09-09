#!/usr/bin/env bats

source ../../../../../vendor/bats-all/load.bash
source ./line-editing.sh
set -o vi

@test "_readline_util_get_line" {
	readonly -a gits=(
		"git"
		"'git'"
		'"git"'
		"\\git"
	)

	for git in "${gits[@]}"; do
		local -a lines=(
			"$git status -s"
			" $git status -s"
			"sudo $git status -s"
			" sudo $git status -s"
		)

		for line in "${lines[@]}"; do
			_readline_util_get_line "$line"

			# echo "line: '$line'" >&3

			assert [ "$REPLY" = "git status -s" ]
		done
	done
}

@test "_readline_util_expand_alias" {
	local result=

	alias f='f -al'

	local -A line_cmds=(
		["f"]="f -al"
	)

	for key in "${!line_cmds[@]}"; do
		expectedCmd="${line_cmds[$key]}"
		_readline_util_expand_alias "$key"
		expandedAlias="$REPLY"

		assert [ "$expectedCmd" = "$expandedAlias" ]
	done
}

@test "_readline_util_get_cmd" {
	local result=

	local -A line_cmds=(
		["git status"]="git"
		["git"]="git"
		["exa -ls"]="exa"
	)

	for key in "${!line_cmds[@]}"; do
		expectedCmd="${line_cmds[$key]}"
		_readline_util_get_cmd "$key"
		actualCmd="$REPLY"

		assert [ "$expectedCmd" = "$actualCmd" ]
	done
}
