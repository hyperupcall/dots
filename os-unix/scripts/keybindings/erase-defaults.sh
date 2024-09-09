#!/usr/bin/env bash

source "${0%/*}/../source.sh"

# Erase all defaults
case $XDG_CURRENT_DESKTOP in
	XFCE)
		# Keyboard shortcuts for applications
		for line in $(xfconf-query --channel xfce4-keyboard-shortcuts  --list | grep '/commands/custom'); do
			xfconf-query --channel xfce4-keyboard-shortcuts --property "$line" --reset
		done
		# Without this, default options are re-created
		xfconf-query --channel xfce4-keyboard-shortcuts --property '/commands/custom/override' --type bool --set 'true' --create
		;;
esac
