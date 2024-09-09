#!/usr/bin/env sh

if [ -z "$XDG_RUNTIME_DIR" ]; then
	printf '%s\n' "kitty.sh: Error: XDG_RUNTIME_DIR not set" >&2
	exit 1
fi
mkdir -p "$XDG_RUNTIME_DIR/kitty"

n=1
while true; do
	[ ! -S "$XDG_RUNTIME_DIR/kitty/control-socket-$n" ] && break
	n=$((n + 1))
done

exec kitty \
	-o allow_remote_control=yes \
	--listen-on "unix:$XDG_RUNTIME_DIR/kitty/control-socket-$n"
