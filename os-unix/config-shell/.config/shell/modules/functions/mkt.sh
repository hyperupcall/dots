# shellcheck shell=sh

# Get the most recent file in a directory.
_mkt_util_get_latest_file() {
	find . -ignore_readdir_race -mindepth 1 -maxdepth 1 -type f -printf "%T@\t%p\0" \
			| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
}

# cd into the most recently created directory.
_mkt_util_cd_latest_dir() {
	_mkt_latest_dir=$(
		find . -mindepth 1 -maxdepth 1 -type d -printf "%T@\t%p\0" \
				| sort -zn | cut -z -f2- | tail -z -n1 | tr -d '\000'
	)

	if [ -n "$_mkt_latest_dir" ]; then
		if ! _mkt_util_cd "$_mkt_latest_dir"; then
			unset _mkt_latest_dir
			return 1
		fi
	else
		unset _mkt_latest_dir
		return 1
	fi

	unset _mkt_latest_dir
}

# For pOsIX coMplIanCe since pushd isn't POSIX
_mkt_util_cd() {
	# shellcheck disable=SC3044
	if (builtin pushd . >/dev/null); then
		if ! pushd -- "$1" >/dev/null; then
			_shell_util_die "mkt: Could not pushd"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	else
		if ! cd -- "$1"; then
			_shell_util_die "mkt: Could not cd"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	fi

	if [ -n "$_mkt_old_pwd" ]; then
		OLDPWD=$_mkt_old_pwd
	fi
}

_mkt_util_git_clone() {
	if [ "$_mkt_flag_shallow" = 'yes' ]; then
		if ! git clone -- "$1"; then
			_shell_util_die "mkt: Could not clone repository"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	else
		if ! git clone --depth=1 --single-branch -- "$1"; then
			_shell_util_die "mkt: Could not clone repository"
			rmdir "$_mkt_dir" 2>/dev/null
			return 1
		fi
	fi
}

_mkt_util_log() {
	printf "%s\n" "$(date '+%b %d - %I:%M:%S') | $_mkt_dir | $1" >> "${XDG_STATE_HOME:-$HOME/.local/state}/history/mkt_history"
}

mkt() {
	_mkt_flag_shallow='no'

	for arg; do case "$arg" in
	--help)
		cat <<-EOF
		mkt

		Flags:
		  --shallow
		    When git cloning a repository, only clone from HEAD ref

		Examples:
		  mkt https://github.com/eankeen/dots
		  mkt --shallow eankeen/dots
		  mkt https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_linux_amd64.zip
		EOF
		return
		;;
	--shallow)
		_mkt_flag_shallow=yes
		;;
	-*)
		_shell_util_die "mkt: Flag '$arg' not recognized"
		return
		;;
	*)
		_mkt_arg=$arg
		;;
	esac done; unset arg

	_mkt_old_pwd=$PWD

	set -- "$_mkt_arg"
	case "$1" in
	# nothing passed
	'')
		_mkt_dir=$(mktemp -d)
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		;;
	# git repository
	*.git)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev) # id so we can see this folder in /tmp easier
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		unset _mkt_id

		_mkt_util_git_clone "$1" || return

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		;;
	# remote files
	https://*/*.*)
		_mkt_dir=$(mktemp -d)
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"

		command curl -fLO "$1" || { _shell_util_die "mkt: Could not fetch resource with cURL"; return; }
		_mkt_latest_file=$(_mkt_util_get_latest_file)
		if file "$_mkt_latest_file" | grep -Eq '(compressed|archive)'; then
			if command -v aunpack >/dev/null 2>&1; then
				command aunpack "$_mkt_latest_file" # uncompress if compressed
			else
				_shell_util_ls
				_shell_util_die "mkt: Command aunpack not found"
				return
			fi
		fi
		unset _mkt_latest_file

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		;;
	# git repository
	git@*|git://*|*.git|https://github.com/*|https://gitlab.com/*|https://git.sr.ht/*|https://*@bitbucket.org/*|https://invent.kde.org/*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev) # id so we can see this folder in /tmp easier
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		unset _mkt_id

		_mkt_util_git_clone "$1" || return

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		;;
	# file path
	/*|./*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev) # id so we can see this folder in /tmp easier
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$_mkt_dir"
			_mkt_util_cd "$_mkt_dir"
		else
			_mkt_util_cd "$_mkt_dir"
		fi
		;;
	# github repository shorthand
	*/*)
		_mkt_id=$(printf '%s\n' "$1" | rev | cut -d/ -f1 | rev) # id so we can see this folder in /tmp easier
		_mkt_dir=$(mktemp -d --suffix "-$_mkt_id")
		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		unset _mkt_id

		_mkt_util_git_clone "https://github.com/$1" || return

		_mkt_util_cd_latest_dir || return
		_shell_util_ls
		;;
	*)
		_mkt_dir=$(mktemp -d --suffix "-$1")

		if [ -f "$1" ] || [ -d "$1" ]; then
			command cp -r "$1" "$_mkt_dir"
		fi

		_mkt_util_cd "$_mkt_dir" || return
		_mkt_util_log "$1"
		;;
	esac

	unset _mkt_flag_shallow _mkt_arg _mkt_old_pwd _mkt_dir
}
