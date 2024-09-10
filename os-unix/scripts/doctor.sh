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

	{
		# TODO: gpg
		:
	}

	# Launcher
	{
		check=true

		if check && [ ! -d ~/.core/launcher ]; then
			failure "Expects a cloned repository at ~/.core/launcher"
			if should_fix; then
				util.clone ~/.core/launcher https://github.com/fox-incubating/launcher
			fi
		fi

		if check && ! command -v keymon &>/dev/null; then
			failure "Expected to find \"keymon\" command in PATH"
			if should_fix; then
				cd ~/.core/launcher
				make
				sudo make install
			fi
		fi

		if check && ! systemctl is-active --quiet keymon.service &>/dev/null; then
			failure "Expected service \"keymon\" to be running"
			if should_fix; then
				systemctl enable --now keymon.service
			fi
		fi

		success ".core/launcher"
	}

	# Hub
	{
		check=true

		if check && [ ! -d ~/.core/hub ]; then
			failure "Expects a cloned repository at ~/.core/hub"
			if should_fix; then
				util.clone ~/.core/hub https://github.com/fox-incubating/hub
			fi
		fi

		success ".core/hub"
	}

	# Git
	{
		check=true

		if check && ! command -v git &>/dev/null; then
			failure "Expects the command \"git\" to be installed"
			if should_fix; then
				util.install_package 'git'
			fi
		fi

		# Check if it is an older verison.
		local git_version git_version_arr
		git_version=$(git version)
		git_version=${git_version#git version }
		IFS='.' read -ra git_version_arr <<< "$git_version"
		if check && ! (( git_version_arr[0] >= 3 || (git_version_arr[0] == 2 && git_version_arr[1] >= 37) )); then
			failure "Git version of \"$git_version\" is too old. It must be at least 2.37.0 to support \"push.autoSetupRemote\""
			if should_fix; then
				util.remove_package 'git'
				~/scripts/setup/git.sh
			fi
		fi

		# TODO
		# printf '%s\n' "GIT:"
		# check.command 'spaceman-diff'
		# check.command 'npm-merge-driver'
		# check.command 'yarn-merge-driver'
		# printf '\n'
	}

	# Neovim
	{
		check=true

		if check && ! command -v nvim &>/dev/null; then
			failure "Expects the command \"nvim\" to be installed"
			if should_fix; then
				util.install_package 'neovim'
			fi
		fi

		local nvim_version nvim_version_arr
		nvim_version=$(nvim --version)
		nvim_version=${nvim_version%%$'\n'*}
		nvim_version=${nvim_version#NVIM v}
		nvim_version=${nvim_version%%-*}
		IFS='.' read -ra nvim_version_arr <<< "$nvim_version"
		if check && ! (( nvim_version_arr[0] >= 1 || (nvim_version_arr[0] == 0 && nvim_version_arr[1] >= 10) )); then
			failure "Neovim version of \"$nvim_version\" is too old. It must be at least v0.10.0"
			if should_fix; then
				util.uninstall_package 'neovim'
				~/scripts/setup/nvim.sh
			fi
		fi
	}

	{
		check=true
		if check && ! command -v dotdrop &>/dev/null; then
			failure "Expects the command \"dotdrop\" to be installed"
			if should_fix; then
				~/scripts/setup/gh.sh
			fi
		fi

		check=true
		if check && ! command -v pass &>/dev/null; then
			failure "Expects the command \"pass\" to be installed"
			if should_fix; then
				~/scripts/setup/pass.sh
			fi
		fi

		check=true
		if check && ! command -v firefox &>/dev/null; then
			failure "Expects the command \"firefox\" to be installed"
			if should_fix; then
				~/scripts/setup/firefox.sh
			fi
		fi

		check=true
		if check && ! command -v brave &>/dev/null; then
			failure "Expects the command \"brave\" to be installed"
			if should_fix; then
				~/scripts/setup/brave.sh
			fi
		fi

		check=true
		if check && ! command -v maestral &>/dev/null; then
			failure "Expects the command \"maestral\" to be installed"
			if should_fix; then
				~/scripts/setup/maestral.sh
			fi
		fi

		check=true
		if check && ! command -v mise &>/dev/null; then
			failure "Expects the command \"mise\" to be installed"
			if should_fix; then
				~/scripts/setup/mise.sh
			fi
		fi
	}

	# Commands
	{




		check=true
		if check && ! command -v gh &>/dev/null; then
			failure "Expects the command \"gh\" to be installed"
			if should_fix; then
				~/scripts/setup/gh.sh
			fi
		fi

		check=true
		if check && ! command -v just &>/dev/null; then
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

check() {
	if [ "$check" = true ]; then
		return 0
	else
		return 1
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
