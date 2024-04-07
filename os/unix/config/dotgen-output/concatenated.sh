# basalt.sh
for dir in "$HOME/.dotfiles/.data/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init sh)"
		break
	fi
done; unset -v dir

# concatenated.sh
# basalt.sh
for dir in "$HOME/.dotfiles/.data/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init sh)"
		break
	fi
done; unset -v dir


# repomgr.sh
_path_prepend "$HOME/.local/state/repomgr/bin"

# zoxide.sh
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init posix --hook prompt)"
fi

