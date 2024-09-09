# shellcheck shell=bash

pkg() {
	printf '%s\n' "Functions:
  pkgi: Install a package
  pkgl: List contents of package
  pkgp: see package Providing a file
  pkgs: Search for a package"
}

pkgi() {
	if _shell_util_has 'pacman'; then
		_shell_util_run 'pacman' -S "$@"
	elif _shell_util_has 'dnf'; then
		_shell_util_run 'dnf' install "$@"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgl() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		_shell_util_run 'pacman' -Ql "$pkg"
	elif _shell_util_has 'dnf'; then
		_shell_util_run 'rpm' -ql "$pkg"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgp() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		_shell_util_run 'pacman' -Qo "$pkg"
	elif _shell_util_has 'dnf'; then
		_shell_util_run 'dnf' provides "$1"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}

pkgs() {
	local pkg="$1"

	if _shell_util_has 'pacman'; then
		_shell_util_run 'pacman' -Q "$pkg"
	elif _shell_util_has 'dnf'; then
		_shell_util_run 'dnf' search "$pkg"
	else
		_shell_util_log_error "Package manager not recognized"
	fi
}
