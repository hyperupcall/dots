# ~/.cshrc

test -x "$XDG_CONFIG_HOME/dircolors/dir_colors" \
	&& eval "$(dircolors --csh "$XDG_CONFIG_HOME/dircolors/dir_colors")"
