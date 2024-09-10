# basalt.bash
for dir in "$HOME/.dotfiles/.data/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init bash)"
		break
	fi
done; unset -v dir

# autoenv.bash
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

# dircolors.bash
if [ -f "$XDG_CONFIG_HOME/dircolors/dir_colors" ]; then
	eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dir_colors")"
fi

# direnv.bash
if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

# nodejs.bash
if command -v node &>/dev/null; then
	source <(node --completion-bash)
fi

# concatenated.bash
