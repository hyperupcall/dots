# shellcheck shell=bash

export VISUAL='kak'
export EDITOR='ed'
export PAGER='less'

[ -f ~/.bashrc-generated-aliases ] && source ~/.bashrc-generated-aliases
[ -f ~/.bashrc-generated-functions ] && source ~/.bashrc-generated-functions

#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

8Colors() {
	test "$(tput colors)" -eq 8
}

256Colors() {
	test "$(tput colors)" -eq 256
}

16MillionColors() {
	test "$COLORTERM" = "truecolor" || test "$COLORTERM" = "24bit"
}

if 16MillionColors; then
	PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
elif 8Colors || 256Colors; then
	PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
else
	PS1="[\u@\h \w]\$ "
fi

unset -f 8Colors 256Colors 16MillionColors

[ -r ~/.dir_colors ] && eval "$(dircolors ~/.dir_colors)"
