#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

# Behavior: Take a screenshot
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/run-command-screenshot' "'disabled'"
		;;
esac
dconf update

# Behavior: Take a screenshot of a window
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/run-command-window-screenshot' "'disabled'"
		;;
esac
dconf update
