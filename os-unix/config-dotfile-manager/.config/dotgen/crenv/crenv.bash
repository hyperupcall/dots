if command -v crenv &>/dev/null; then
	eval "$(crenv init - | grep -v 'export PATH')"
fi
