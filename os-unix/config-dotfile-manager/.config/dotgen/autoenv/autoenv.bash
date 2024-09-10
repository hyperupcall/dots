if command -v basalt &>/dev/null; then
	command() {
		if [[ "$1" = '-v' && "$2" == gsha1sum ]]; then
			enable_autoenv() { :; }

			if builtin command "$@"; then
				return $?
			else
				return $?
			fi
		fi
	} # TODO
	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
	unset -f command
fi
