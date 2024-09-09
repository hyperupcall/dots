if [ -d "$XDG_DATA_HOME/miniconda3/bin" ]; then
	_path_prepend "$XDG_DATA_HOME/miniconda3/bin"
	eval "$(conda shell.bash hook)"
fi
