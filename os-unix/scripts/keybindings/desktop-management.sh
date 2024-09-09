#!/usr/bin/env bash

source "${0%/*}/../source.sh"

# Behavior: Show desktop menu / home
case $XDG_CURRENT_DESKTOP in
	GNOME|zorin:GNOME)
		gsettings set org.gnome.mutter overlay-key ''
		;;
esac

# Behavior: Toggle move window on moues drag
case $XDG_CURRENT_DESKTOP in
	XFCE)
		xfconf-query --channel xfwm4 --create --property /general/easy_click --type string --set ''
		;;
esac

# Behavior: Hide windows and set focus to desktop
case $XDG_CURRENT_DESKTOP in
	MATE)
		dconf write '/org/mate/marco/global-keybindings/show-desktop' "'disabled'"
		;;
esac
dconf update
