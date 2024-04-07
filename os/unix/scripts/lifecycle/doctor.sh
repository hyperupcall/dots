#!/usr/bin/env bash

source "${0%/*}/../source.sh"

# TODO: hub.woof, nerdfonts
# TODO: git smuge etc filters are in use
main() {
	git_version=$(git version)
	git_version=${git_version#git version }
	IFS='.' read -ra git_version <<< "$git_version"
	if ! (( git_version[0] >= 3 || (git_version[0] == 2 && git_version[1] >= 37) )); then
		failure "Git version is too old. It must be at least 2.37.0 to support 'push.autoSetupRemote'"
	fi
	echo "${git_version[0]}"
	echo "${git_version[1]}"
	echo "${git_version[2]}"

	printf '%s\n' "GIT:"
	check.command 'spaceman-diff'
	check.command 'npm-merge-driver'
	check.command 'yarn-merge-driver'
	printf '\n'

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
	check.command nvim
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
	for dir in ~/.ssh/ ~/.gnupg/; do
		if [ -d "$dir" ]; then
			find "$dir" -type d -exec chmod 700 {} \;
			find "$dir" -type f -exec chmod 600 {} \;
		fi
	done
}

success() {
	printf '%s\n' "✅ $1"
}

failure() {
	printf '%s\n' "⛔ $1"
}

check.command() {
	local cmd="$1"

	if util.is_cmd "$cmd"; then
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
