#!/usr/bin/env bash

source "${0%/*}/source.sh"

# TODO: hub.woof, nerdfonts
# TODO: git smuge etc filters are in use
# TODO
# if command -v autoenv_init >/dev/null 2>&1; then
# 		autoenv_init || :
# 	else
# 		_shell_util_log_warn "cd: Function is not defined: autoenv_init"
# 	fi

# 	if command -v __woof_cd_hook >/dev/null 2>&1; then
# 		__woof_cd_hook || :
# 	else
# 		_shell_util_log_warn "cd: Function is not defined: __woof_cd_hook"
# 	fi
main() {
	local flag_fix=false
	for arg; do case $arg in
	--prompt-to-fix)
		flag_fix=true
		;;
	esac done

	# Git
	{
		# TODO: Check if Git is installed. If not, install it from the repositories. Later, uninstall it
		# if it is an older verison
		local git_version git_version_arr
		git_version=$(git version)
		git_version=${git_version#git version }
		IFS='.' read -ra git_version_arr <<< "$git_version"
		if ! (( git_version_arr[0] >= 3 || (git_version_arr[0] == 2 && git_version_arr[1] >= 37) )); then
			failure "git/too-old: Git version of \"$git_version\" is too old. It must be at least 2.37.0 to support \"push.autoSetupRemote\""
			if [ "$flag_fix" = true ] && util.confirm "Would you like to fix this?"; then
				~/scripts/setup/git.sh
			fi
		fi

		printf '%s\n' "GIT:"
		check.command 'spaceman-diff'
		check.command 'npm-merge-driver'
		check.command 'yarn-merge-driver'
		printf '\n'
	}

	# Neovim
	{
		# TODO: later, check if nvim command actually is there
		local nvim_version nvim_version_arr
		nvim_version=$(nvim --version)
		nvim_version=${nvim_version%%$'\n'*}
		nvim_version=${nvim_version#NVIM v}
		nvim_version=${nvim_version%%-*}
		IFS='.' read -ra nvim_version_arr <<< "$nvim_version"
		if ! (( nvim_version_arr[0] >= 1 || (nvim_version_arr[0] == 0 && nvim_version_arr[1] >= 10) )); then
			failure "nvim/too-old Nvim version of \"$nvim_version\" is too old. It must be at least v0.10.0"
			if [ "$flag_fix" = true ] && util.confirm "Would you like to fix this?"; then
				~/scripts/setup/nvim.sh
			fi
		else
			success "nvim/too-old Nvim version is \"$nvim_version\""
		fi
	}

	printf '%s\n' "BINARIES:"
	check.command dotdrop
	check.command clang-format
	check.command clang-tidy
	check.command bake
	check.command basalt
	check.command ksh
	printf '\n'

	printf '%s\n' "BINARIES: DEVELOPMENT:"
	check.command gh
	check.command just
	check.command 'dufs'
	check.command 'pre-commit'
	printf '\n'

	printf '%s\n' "DROPBOX:"
	check.process maestral
	printf '\n'

	printf '%s\n' "LATEX:"
	check.process latexindent
	printf '\n'

	printf '%s\n' "FISH:"
	check.command fish
	check.command fish-indent
	printf '\n'

	printf '%s\n' "SENSITIVE:"
	if [ -d "$XDG_DATA_HOME/password-store" ]; then
		if [ -d "$XDG_DATA_HOME/password-store" ]; then
			success "Has password-store and is git directory"
		else
			failure "Password-store not a git directory"
		fi
	else
		failure "Password-store not found in the correct location"
	fi
	if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
		success "Has password-store gpg public key"
	else
		failure "Does not have password-store gpg public key"
	fi
	if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
		success "Has commit signing gpg public key"
	else
		failure "Does not have commit signing gpg public key"
	fi
	if [ -f ~/.ssh/github ]; then
		success "Has GitHub private SSH key"
	else
		failure "Does not have GitHub private SSH key"
	fi
}

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

check.command() {
	local cmd="$1"

	if command -v "$cmd" &>/dev/null; then
		success "Is installed: $cmd"
	else
		failure "Not installed: $cmd"
	fi
}

check.process() {
	local process="$1"

	if pgrep "$process" &>/dev/null; then
		success "$process is running"
	else
		if (($? == 1)); then
			failure "$process not running"
		else
			failure "Syntax or memory error when calling pgrep"
		fi
	fi
}

main "$@"
