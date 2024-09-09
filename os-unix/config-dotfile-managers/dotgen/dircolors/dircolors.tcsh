if ( -r "$XDG_CONFIG_HOME/dircolors/dir_colors" ) then
	eval "$(dircolors -c "$XDG_CONFIG_HOME/dircolors/dir_colors")"
endif
