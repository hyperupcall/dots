# shellcheck shell=sh

# Common functions used in starup files for POSIX shell, Bash, and Zsh.

_path_prepend() {
	if [ -n "$2" ]; then
		case ":$(eval "printf '%s' \"\$$1\""):" in
			*":$2:"*) :;;
			*) eval "export $1=$2\${$1:+\":\$$1\"}" ;;
		esac
		return
	fi

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="$1${PATH:+":$PATH"}"
	esac
}

_path_append() {
	if [ -n "$2" ]; then
		case ":$(eval "printf '%s' \"\$$1\""):" in
			*":$2:"*) :;;
			*) eval "export $1=\${$1:+\"\$$1:\"}$2" ;;
		esac
		return
	fi

	case ":$PATH:" in
		*":$1:"*) :;;
		*) export PATH="${PATH:+"$PATH:"}$1"
	esac
}

_shell_util_die() {
	_shell_util_log_error "$*"
	return 1
}

_shell_util_log_error() {
	if [ -t 0 ]; then
		printf "\033[0;31m%s\033[0m %s\n" 'Error:' "$1" >&2
	else
		printf "%s %s\n" 'Error:' "$1" >&2
	fi
}

_shell_util_log_warn() {
	if [ -t 0 ]; then
		printf "\033[1;33m%s\033[0m %s\n" 'Warn:' "$1" >&2
	else
		printf "%s %s\n" 'Warn:' "$1" >&2
	fi
}

_shell_util_log_info() {
	if [ -t 0 ]; then
		printf "\033[0;34m%s\033[0m %s\n" 'Info:' "$1"
	else
		printf "%s %s\n" 'Info:' "$1"
	fi
}

_shell_util_ls() {
	printf '%s\n' '---'
	if command -v exa >/dev/null 2>&1; then
		exa -a --color=always
	else
		ls -A --color=always
	fi
	printf '%s\n' '---'
}

_shell_util_has() {
	if hash "$1" >/dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

_shell_util_run() {
	_shell_util_log_info "Executing: $*"

	if "$@"; then :; else
		return $?
	fi
}
