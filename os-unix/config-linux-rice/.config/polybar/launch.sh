#!/usr/bin/env sh

killall -q polybar
# while pgrep -x polybar >/dev/null; do sleep 1; done

bar="main"
if type "xrandr" >/dev/null 2>&1; then
	for m in $(xrandr --query | grep ' connected ' | cut -d' ' -f1); do
		MONITOR=$m polybar --reload "$bar" &
	done
else
	echo "Error: xrandr not found" 1>&2
	polybar --reload "$bar" &
fi
