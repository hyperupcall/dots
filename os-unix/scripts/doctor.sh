#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

# TODO: hub, woof, nerdfonts
# TODO: git smuge etc filters are in use
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

	local check=

	# SSH, GPG
	{
		if [ -f ~/.ssh/github ]; then
			success "Has GitHub private SSH key"
		else
			failure "ssh: Expected the file \"~/.ssh/github\" to exist"
			core.print_die 'Exiting...'
		fi

		if ! gpg --list-public-keys | grep --quiet 'edwin@kofler.dev'; then
			failure "gpg: Expected a gpg key with email \"edwin@kofler.dev\" to exist"
			core.print_die 'Exiting...'
		fi
		if gpg --list-keys 0x2FB93BF35E14E7C4 &>/dev/null; then
			success "Has password-store gpg public key"
		else
			failure "Does not have password-store gpg public key"
			core.print_die 'Exiting...'
		fi
		if gpg --list-keys 0x3851E5FD042C7C6C &>/dev/null; then
			success "Has commit signing gpg public key"
		else
			failure "Does not have commit signing gpg public key"
			core.print_die 'Exiting...'
		fi
	}

	# TODO: 'spaceman-diff'
	# Git
	{
		# TODO: use installed() in ~/scripts/setup/git.sh
		(
			source ~/scripts/setup/git.sh
			if ! installed; then
				failure "Git is not installed"
				if should_fix; then
					install
				fi
			fi
		)
		if ! command -v git &>/dev/null; then
			failure "Expects the command \"git\" to be installed"
			if should_fix; then
				util.install_package 'git'
			fi
		fi

		# Check if it is an older verison.
		local git_version=

		if check && ! git_version_check; then
			failure "Git version of \"$git_version\" is too old. It must be at least 2.37.0 to support \"push.autoSetupRemote\""
			if should_fix; then
				util.remove_package 'git'
				~/scripts/setup/git.sh
			fi
		fi

		if git_version_check; then
			success 'Git is installed'
		fi
	}

	# Neovim
	{
		if ! command -v nvim &>/dev/null; then
			failure "Expects the command \"nvim\" to be installed"
			if should_fix; then
				util.install_package 'neovim'
			fi
		fi
		local nvim_version
		neovim_version_check() {
			local -a nvim_version_arr
			nvim_version=$(nvim --version)
			nvim_version=${nvim_version%%$'\n'*}
			nvim_version=${nvim_version#NVIM v}
			nvim_version=${nvim_version%%-*}
			IFS='.' read -ra nvim_version_arr <<< "$nvim_version"
			(( nvim_version_arr[0] >= 1 || (nvim_version_arr[0] == 0 && nvim_version_arr[1] >= 10) ))
		}
		if check && ! neovim_version_check; then
			failure "Neovim version of \"$nvim_version\" is too old. It must be at least v0.10.0"
			if should_fix; then
				util.uninstall_package 'neovim'
				~/scripts/setup/nvim.sh
			fi
		fi

		if neovim_version_check; then
			success 'neovim is installed'
		fi
	}

	{
		if ! command -v pass &>/dev/null; then
			failure "Expects the command \"pass\" to be installed"
			if should_fix; then
				~/scripts/setup/pass.sh
			fi
		fi

		if command -v pass &>/dev/null; then
			success 'pass is installed'
		fi
	}

	{
		if ! command -v firefox &>/dev/null; then
			failure "Expects the command \"firefox\" to be installed"
			if should_fix; then
				~/scripts/setup/app/firefox.sh
			fi
		fi

		if command -v firefox &>/dev/null; then
			success 'Firefox is installed'
		fi

		if ! command -v brave-browser &>/dev/null; then
			failure "Expects the command \"brave-browser\" to be installed"
			if should_fix; then
				~/scripts/setup/app/brave.sh
			fi
		fi

		if command -v brave-browser &>/dev/null; then
			success 'Brave is installed'
		fi
	}

	{
		if ! command -v maestral &>/dev/null; then
			failure "Expects the command \"maestral\" to be installed"
			if should_fix; then
				~/scripts/setup/app/maestral.sh
			fi
		fi
		if command -v maestral &>/dev/null; then
			success 'Maestral is installed'
		fi
	}
	{
		if ! command -v mise &>/dev/null; then
			failure "Expects the command \"mise\" to be installed"
			if should_fix; then
				~/scripts/setup/mise.sh
			fi
		fi
		if command -v mise &>/dev/null; then
			success 'Mise is installed'
		fi
	}


	# Launcher
	# TODO
	# {
	# 	if [ ! -d ~/.dev ]; then
	# 		failure "Expects a cloned repository at ~/.dev"
	# 		if should_fix; then
	# 			util.clone ~/.dev https://github.com/fox-incubating/dev
	# 		fi
	# 	fi

	# 	if check && ! command -v keymon &>/dev/null; then
	# 		failure "Expected to find \"keymon\" command in PATH"
	# 		if should_fix; then
	# 			cd ~/.core/launcher
	# 			make
	# 			sudo make install
	# 		fi
	# 	fi

	# 	if check && ! systemctl is-active --quiet keymon.service &>/dev/null; then
	# 		failure "Expected service \"keymon\" to be running"
	# 		if should_fix; then
	# 			systemctl enable --now keymon.service
	# 		fi
	# 	fi

	# 	success ".core/launcher"
	# }


	# Commands
	{
		if ! command -v gh &>/dev/null; then
			failure "Expects the command \"gh\" to be installed"
			if should_fix; then
				~/scripts/setup/gh.sh
			fi
		fi

		if ! command -v just &>/dev/null; then
			failure "Expects the command \"just\" to be installed"
			if should_fix; then
				cargo install --locked just
			fi
		fi
	}

	printf '%s\n' "BINARIES:"
	check.command clang-format
	check.command clang-tidy
	check.command bake
	check.command basalt
	check.command ksh
	printf '\n'

	printf '%s\n' "BINARIES: DEVELOPMENT:"
	check.command 'dufs'
	check.command 'pre-commit'
	printf '\n'

	printf '%s\n' "LATEX:"
	check.command latexindent
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

should_fix() {
	if [ "$flag_fix" = true ] && util.confirm "Would you like to fix this?"; then
		return 0
	else
		return 1
	fi
}

main "$@"
