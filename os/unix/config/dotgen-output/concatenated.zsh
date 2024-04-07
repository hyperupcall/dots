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

# mise.zsh
eval "$("$HOME/.local/bin/mise" activate zsh)"

# concatenated.zsh
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


# pipx.zsh
# TODO
# if command -v register-python-argcomplete &>/dev/null; then
# 	autoload -U bashcompinit
# 	bashcompinit
# 	eval "$(register-python-argcomplete pipx)"
# fi

# repomgr.zsh
_path_prepend "$HOME/.local/state/repomgr/bin"

# woof.zsh
if command -v woof >/dev/null 2>&1; then
	eval "$(woof init --no-cd zsh)"
fi

# zoxide.zsh
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi

