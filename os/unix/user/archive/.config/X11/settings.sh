#!/usr/bin/env sh

# @file settings.sh
# @brief Set X11 settings. This is its own file so settings can be applied
# manually in case '.xinitrc' succeeds, but somehow settings haven't been set

setxkbmap -option terminate:ctrl_alt_bksp

xbacklight -set 100

# xhost gives X server access for same user processes on localhost.
# Safe since the kernel can check the actual owner of the calling process
xhost +si:localuser:"$(id -un)"

xmodmap "$XDG_CONFIG_HOME/X11/Xmodmap"

xrandr \
	--output DP-1 --left-of HDMI-0 \
	--output DP-5 --right-of HDMI-0 \
	--output DP-3 --above HDMI-0

xrdb -load -all "$XDG_CONFIG_HOME/X11/Xresources"

xset -b
xset -dpms
xset +fp "$XDG_DATA_HOME/fonts"
xset fp rehash
xset led off
xset m 0 0
xset r rate 500 40

xsetroot -default
# xsetroot -xcf /usr/share/icons/breeze_cursors/cursors/left_ptr 4
xsetroot -mod 8 8
xsetroot -solid '#212529' # Open Color black-9
xsetroot -name "Root Window"
