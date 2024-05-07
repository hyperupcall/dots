# shellcheck shell=bash
#
# ~/.bashrc
#

# Stop execution if bash is non-interactive
[[ $- != *i* ]] && [ ! -t 0 ] && return

# Ensure /etc/profile is read for non-login shells
# Bash only reads /etc/profile on interactive, login shells
# ! shopt -q login_shell && [ -r /etc/profile ] && source /etc/profile

# Ensure ~/.profile is read for non-login shells
# Bash only reads ~/.profile on login shells when invoked as sh
[ -r ~/.profile ] && source ~/.profile
if (( $? != 0 )); then printf '%s\n' "Error: bashrc.sh: Failed to source ~/.profile successfuly. Aborting source" >&2; return 1; fi

#
# ─── FRAMEWORKS ─────────────────────────────────────────────────────────────────
#

# source "$XDG_CONFIG_HOME/bash/frameworks/oh-my-bash.sh"
# source "$XDG_CONFIG_HOME/bash/frameworks/bash-it.sh"
# source "$HOME/.dotfiles/.data/repos/blesh/out/ble.sh"


#
# ─── SHELL VARIABLES ────────────────────────────────────────────────────────────
#

# Exported so nested shells, virtual environments, etc. inherit the new values

# export CDPATH=':~:'
# export CHILD_MAX='256'
unset -v EXECIGNORE
export FCEDIT="$EDITOR"
unset -v FIGNORE
unset -v GLOBIGNORE
export HISTCONTROL='ignorespace:ignoredups'
HISTFILE="$XDG_STATE_HOME/history/bash_history" # FIXME: bug with exporting this and starship
export HISTSIZE='-1'
export HISTFILESIZE='-1'
export HISTIGNORE='ls:dir|vdir|[bf]g:pwd:clear*:exit*:mkcd*:mkt*'
# export HISTTIMEFORMAT='%B %m %Y %T | '
export HISTTIMEFORMAT='%F %T ' # ISO 8601
export TIMEFORMAT=$'real    %3lR\nuser    %3lU\nsystem  %3lS\npercent %P'
export PROMPT_DIRTRIM='6'
unset -v MAIL
unset -v MAILCHECK
unset -v MAILPATH

#
# ─── SHELL OPTIONS ──────────────────────────────────────────────────────────────
#

# ------------------------- shopt ------------------------ #
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -u direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u failglob
shopt -s globasciiranges
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -u hostcomplete
shopt -s interactive_comments
shopt -u mailwarn
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch
shopt -u nullglob # setting obtains unexpected parameter expansion behavior
shopt -s progcomp
((BASH_VERSINFO[0] == 5)) && shopt -s progcomp_alias # not working due to complete -D
shopt -s shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

# -------------------------- set ------------------------- #
set -o noclobber
set -o notify
set -o physical


#
# ─── PS1 ────────────────────────────────────────────────────────────────────────
#

is_8_colors() {
	colors=$(tput colors 2>/dev/null)

	[ -n "$colors" ] && [ "$colors" -eq 8 ]
}

is_256_colors() {
	colors=$(tput colors 2>/dev/null)

	[ -n "$colors" ] && [ "$colors" -eq 256 ]
}

is_16million_colors() {
	[ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]
}

source "$HOME/.dotfiles/os/unix/config/dotgen-output/concatenated.bash"

if is_16million_colors; then
	if ((EUID == 0)); then
		PS1="\[\e[38;2;201;42;42m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="[\u@\h \w]\$ "
		# shellcheck disable=SC3046
		if ! eval "$(
			if ! default launch shell-prompt-bash; then
				printf '%s\n' 'false' # Propagate error to the "if ! eval ..."
			fi
		)"; then
			PS1="[\[\e[0;31m\](PS1 Error)\[\e[0m\] \u@\h \w]\$ "
		fi
	fi
elif is_8_colors || is_256_colors; then
	if ((EUID == 0)); then
		PS1="\[\e[0;31m\][\u@\h \w]\[\e[0m\]\$ "
	else
		PS1="\[\e[0;33m\][\u@\h \w]\[\e[0m\]\$ "
	fi
else
	PS1="[\u@\h \w]\$ "
fi

unset -f is_8_colors is_256_colors is_16million_colors


#
# ─── MISCELLANEOUS ──────────────────────────────────────────────────────────────
#

# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# even though we `source /etc/profile` at beginnning of script, this is still needed since we now
# only have BASH_COMPLETION_USER_DIR and BASH_COMPLETION_USER_FILE set
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# bash-preexec
if command -v basalt &>/dev/null; then
	basalt.load --global 'github.com/rcaloras/bash-preexec' 'bash-preexec.sh'

	# after command is read, before command execution
	preexec() {
		:
	}

	# before each prompt
	precmd() {
		# for cdp()
		# shellcheck disable=SC2034
		_shell_cdp_dir="$PWD"
	}
fi

source "$XDG_CONFIG_HOME/shell/modules/common/line-editing.sh"
source "$XDG_CONFIG_HOME/bash/modules/readline.sh"
source "$XDG_CONFIG_HOME/bash/modules/util.sh"

# ---
. "/home/edwin/.local/share/cargo/env"
