#!/usr/bin/env bash

set-d6vcp() {
	for n in $(ddcutil detect | awk '{ if ($1 == "I2C") { print $3 } }' | cut -d- -f2); do
		ddcutil --bus="$n" setvcp D6 "$1" &
	done
}

set-d6vcp 5
wait

trap 'set-d6vcp 0' INT

read -r
