# basalt.zsh
for dir in "$HOME/.dotfiles/.data/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init zsh)"
		break
	fi
done; unset -v dir

# autoenv.zsh
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

# direnv.zsh
if command -v direnv &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

