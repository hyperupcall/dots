if command -v basalt &>/dev/null; then
	# complete-alias
	basalt.load --global 'github.com/cykerway/complete-alias' 'complete_alias'
	if declare -F _complete_alias &>/dev/null; then
		for alias_name in $(
		alias -p | while IFS= read -r line; do
			line="${line#alias }"
			line="${line%%=*}"
			printf '%s\n' "$line"
			done
		); do
			complete -F _complete_alias "$alias_name"
		done; unset -v alias_name
	else
		_shell_util_log_warn "Completions from cykerway/complete-alias not loaded properly"
	fi
fi
