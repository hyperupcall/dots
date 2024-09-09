# shellcheck shell=sh

o() {
	if [ $# -eq 0 ]; then
		xdg-open .
	else
		xdg-open "$@"
	fi
}

#clone(user, root)
r() {
	for _file; do
		if [ -d "$_file" ]; then
			command rmdir "$_file"
		else
			command rm "$_file"
		fi
	done; unset -v _file
}

#clone(user, root)
t() {
	if [ $# -eq 0 ]; then
		_shell_util_log_error 't: Missing file arguments'
		return
	fi

	for _file; do
		mkdir -p "${_file%/*}"
		command touch "$_file"
	done; unset -v _file
}

#clone(user, root)
v() {
	s=
	if [ -e "$1" ] && [ "$(stat -c "%G" "$1")" = 'root' ]; then
		s='sudo'
	fi

	_v_editor="${VISUAL:-vi}"
	if [ $# -eq 0 ]; then
		"$_v_editor" .
	else
		$s mkdir -p "${1%/*}"
		$s "$_v_editor" "$@"
	fi
	unset -v _v_editor
}

#clone(user, root)
del() {
	if command -v trash-put >/dev/null 2>&1; then
		for f; do
			if ! trash-put "$f"; then
				_shell_util_die "del: 'trash-put' failed"
				return
			fi
		done
	elif command -v gio >/dev/null 2>&1; then
		for f; do
			if ! gio trash "$f"; then
				_shell_util_die "del: 'gio trash' failed"
				return
			fi
		done
	else
		_shell_util_log_warn "del: Neither 'trash-cli' nor 'gio' installed. Skipping"
	fi
}

#clone(user, root)
cdls() {
	cd -- "$1" || { _shell_util_die "cdls: cd failed"; return; }
	_shell_util_ls
}

#clone(user, root)
mkcd() {
	command mkdir -p -- "$@"
	cd -- "$@" || { _shell_util_die "mkcd: could not cd"; return; }
}

#clone(user, root)
mkmv() {
	for lastArg; do :; done
	mkdir -p "$lastArg"

	mv "$@"
}


