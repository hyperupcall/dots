test -x ~/.profile && . ~/.profile

HISTEDIT="$VISUAL"
HISTFILE="$XDG_STATE_HOME/history/ksh_history"
HISTSIZE="32768"

set -o emacs
