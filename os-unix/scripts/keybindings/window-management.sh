#!/usr/bin/env bash

source "${0%/*}/../source.sh"

{
	# Behavior: Move between windows (popup)
	# Keybinding: Alt + Tab
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/switch-windows' "'disabled'"
			;;
	esac
	dconf update

	# Behavior: Move between windows (immediately)
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/cycle-windows' "'<Alt>Tab'"
			;;
	esac
	dconf update
}

{
	# Behavior: Move between windows of an application (popup)
	# Keybinding: unset
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/switch-group' "'disabled'"
			;;
	esac
	dconf update

	# Behavior: Move between windows of an application (immediately)
	# Keybinding: unset
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/cycle-group' "'disabled'"
			;;
	esac
	dconf update
}

{
	# Behavior: Move between panels (popup)
	# Keybinding: unset
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/switch-panels' "'disabled'"
			;;
	esac
	dconf update

	# Behavior: Move between panels (immediately)
	# Keybinding: unset
	case $XDG_CURRENT_DESKTOP in
		MATE)
			dconf write '/org/mate/marco/global-keybindings/cycle-panels' "'disabled'"
			;;
	esac
	dconf update
}


