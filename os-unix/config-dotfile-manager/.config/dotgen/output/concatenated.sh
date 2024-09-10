# basalt.sh
for dir in "$HOME/.dotfiles/.data/bin"; do
	if [ -e "$dir/basalt" ]; then
		eval "$("$dir/basalt" global init sh)"
		break
	fi
done; unset -v dir

