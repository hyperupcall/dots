# shellcheck shell=sh

cd() {
	# Ex. New mountpoints
	if [ "$1" = '.' ]; then
		# shellcheck disable=SC2164
		cd -- "$PWD"
		return
	fi

	if command -v autoenv_init >/dev/null 2>&1; then
		autoenv_init || :
	fi

	if command -v __woof_cd_hook >/dev/null 2>&1; then
		__woof_cd_hook || :
	fi

	_shell_dir=
	for arg; do case $arg in
		-*) ;;
		*) _shell_dir=$arg ;;
	esac done

	builtin cd -P "$@"
	_exit_code=$?

	unset -v _shell_dir
	return $_exit_code
}

#clone(user)
curl() {
	if command -v curlie >/dev/null 2>&1; then
		curlie "$@"
	else
		command curl "$@"
	fi
}

_lsblk_can_mountpoints=no
if [ -z "$_lsblk_can_mountpoints" ]; then
	_lsblk_tmp=$(command lsblk --version)
	_lsblk_major_num=${_lsblk_tmp##* }; _lsblk_major_num=${_lsblk_major_num%%.*}
	_lsblk_minor_num=${_lsblk_tmp##*.}; _lsblk_minor_num=${_lsblk_minor_num%%.*}
	if [ "$_lsblk_major_num" -ge 3 ] || \
		{ [ "$_lsblk_major_num" -eq 2 ] && [ "$_lsblk_minor_num" -ge 37 ]; }; then
		__lsblk_can_mountpoints=yes
	fi
	unset -v _lsblk_tmp _lsblk_major_num _lsblk_minor_num
fi
lsblk() {
	_str='MOUNTPOINT'
	if [ "$__lsblk_can_mountpoints" = 'yes' ]; then
		_str='MOUNTPOINTS'
	fi

	if [ $# -eq 1 ] && [ "$1" = "-f" ]; then
		command lsblk -o "NAME,FSUSED,FSAVAIL,FSSIZE,FSUSE%,FSTYPE,$_str,UUID,MODEL"
		_exit_code=$?
	elif [ $# -eq 0 ]; then
		command lsblk -o "NAME,SIZE,TYPE,$_str,PARTUUID,MODEL"
		_exit_code=$?
	else
		command lsblk "$@"
		_exit_code=$?
	fi

	unset -v _str
	return $_exit_code
}

ping() {
	if command -v prettyping >/dev/null 2>&1; then
		prettyping "$@"
	else
		command ping "$@"
	fi
}

if [ -t 0 ]; then
	_stty_saved_settings=$(stty -g)
fi
stty() {
	if [ $# -eq 1 ] && [ "$1" = 'sane' ]; then
		# Reset our modifications to the behaviors of the tty device, including the
		# line discipline. This assumes the tty was sane when the shell was initialized.
		if [ -n "$_stty_saved_settings" ]; then
			stty "$_stty_saved_settings"
			_stty_exit_code=$?

			# Redirect log to standard error since this could be a scripted command used within a tty.
			_shell_util_log_info "stty: Restored stty settings to our defaults" >&2
		else
			command stty sane
			_stty_exit_code=$?

			# TODO?
			_shell_util_log_warn "stty: Variable \$_stty_saved_settings empty. Falling back to 'stty sane'" >&2
		fi

		return $_stty_exit_code
	else
		command stty "$@"
	fi
}

#clone(user, root)
unlink() {
	for _arg; do
		case "$_arg" in
		--help|--version)
			command unlink "$@"
			return
			;;
		esac
	done

	_exit_code=0
	for _file; do
		command unlink "$file"
		_code=$?
		if (($_code > 0)); then
			_exit_code=$_code
		fi
		unset -v _code
	done

	unset -v _arg _file
}

#clone(user, root)
less() {
	# On OpenSUSE (Tumbleweed), 'less' is a function that opens "xdg-open". Ovverride
	# that because it's annoying.

	_less_cmd=$(type -fp less)

	"$_less_cmd" "$@"
	_exit_code=$?

	unset -v _less_cmd
	return $_exit_code
}
