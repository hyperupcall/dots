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
	# TODO
	# if command -v basalt.load; then
	# 	basalt.load --global 'github.com/hyperupcall/autoenv' 'activate.sh'
	# else
	# 	printf '%s\n' "Failed to source hyperupcall/autoenv through Basalt" # TODO
	# fi
	# unfunction command
fi
