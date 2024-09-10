# shellcheck shell=sh

# My XDG Base Directory variables are set differently depending on
# the operating system. This file is used during my dotfile bootstrap process.

__xdg_main() {
	if [ -f /etc/os-release ]; then
		while IFS='=' read -r __key __value; do
			if [ "$__key" = ID ]; then
				__value=${__value#\"}
				__value=${__value%\"}
				__xdg_distro_id=$__value
			fi
		done < /etc/os-release; unset -v __key __value
	else
		printf '%s\n' "Error: xdg.sh: File /etc/os-release not found. Exiting" >&2
		return 1
	fi

	__xdg_flag_value='export-vars'
	for __arg; do case $__arg in
	--export-vars)
		__xdg_flag_value='export-vars'
		;;
	--set-type)
		__xdg_flag_value='set-type'
		;;
	esac done; unset -v __arg

	case $__xdg_flag_value in
	export-vars)
		_xdg_action_default() {
			export XDG_CONFIG_HOME="$HOME/.config"
			export XDG_STATE_HOME="$HOME/.local/state"
			export XDG_DATA_HOME="$HOME/.local/share"
			export XDG_CACHE_HOME="$HOME/.cache"
		}

		_xdg_action_custom() {
			export XDG_CONFIG_HOME="$HOME/config"
			export XDG_STATE_HOME="$HOME/state"
			export XDG_DATA_HOME="$HOME/share"
			export XDG_CACHE_HOME="$HOME/.cache"
		}
		;;
	set-type)
		_xdg_action_default() { REPLY='default'; }
		_xdg_action_custom() { REPLY='custom'; }
		;;
	*)
		printf '%s\n' "Error: xdg.sh: An invalid flag was specified. Exiting" >&2
		return 1
	esac

	case $__xdg_distro_id in
		arch|void|gentoo) _xdg_action_custom ;;
		*) _xdg_action_default ;;
	esac

	unset -v __xdg_distro_id
	unset -f _xdg_action_default _xdg_action_custom
}

__xdg_main "$@"
unset -f __xdg_main
