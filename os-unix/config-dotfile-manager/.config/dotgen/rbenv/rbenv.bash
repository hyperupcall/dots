if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - | while IFS= read -r line; do
		if [ "${line::11}" != 'export PATH' ]; then
			printf '%s\n' "$line"
		fi
	done )"
fi
