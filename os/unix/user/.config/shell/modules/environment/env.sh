# shellcheck shell=sh

# ------------------------ General ----------------------- #
export NAME='Edwin Kofler'
export EMAIL='edwin@kofler.com'

export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-"$LANG"}"
export LC_ALL="${LC_ALL:-"$LANG"}"
export VISUAL='nvim'
export EDITOR='nvim'
export DIFFPROG='vim -d'
export PAGER='less'

# ------------------------ Program ----------------------- #
# fzf
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_DEFAULT_OPTS="--history \"$XDG_STATE_HOME/history/fzf_history\" --history-size=10000"

# gnupg
# export GPG_TTY; GPG_TTY=$(tty)

# guile
export GUILE_HISTORY="$XDG_STATE_HOME/history/guile_history"

# hstr
export HSTR_CONFIG='hicolor'

# less
# shellcheck disable=SC3003
{
	export LESSKEY="$XDG_CONFIG_HOME/less/less"
	export LESS_TERMCAP_mb=$'\e[1;31m' # start blink
	export LESS_TERMCAP_md=$'\e[1;36m' # start bold
	export LESS_TERMCAP_me=$'\e[0m' # end all
	export LESS_TERMCAP_so=$'\e[01;44;33m' # start reverse video
	export LESS_TERMCAP_se=$'\e[0m' # end reverse video
	export LESS_TERMCAP_us=$'\e[1;32m' # start underline
	export LESS_TERMCAP_ue=$'\e[0m' # end underline
	export LESS_TERMCAP_us=$'\e[1;32m' # start underline
}

# more
export MORE='-l'

# nnn
export NNN_FALLBACK_OPENER='xdg-open'
export NNN_DE_FILE_MANAGER='nautilus'

# packer
export CHECKPOINT_DISABLE='1'

# pass
export PASSWORD_STORE_CLIP_TIME='15'
export PASSWORD_STORE_ENABLE_EXTENSIONS='true'
export PASSWORD_STORE_GENERATED_LENGTH='40'

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
_path_prepend "$PNPM_HOME"

# ps
export CMD_ENV='linux'

# qt
export QT_ACCESSIBILITY='1'
# export QT_QPA_PLATFORMTHEME="qt5ct"

# ranger
# export RANGER_LOAD_DEFAULT_RC='FALSE'

# snapd
# _path_append '/var/lib/snapd/snap/bin'

# ssh
# unset SSH_AGENT_PID
# if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#   export SSH_AUTH_SOCK=
#   SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# fi

# sxhkd
export SXHKD_SHELL='/bin/sh'

# vim
export VIMINIT="if has('nvim') | source $XDG_CONFIG_HOME/nvim/init.lua | else | source $XDG_CONFIG_HOME/vim/vimrc | endif"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# zinit
export ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

# zfs
export ZFS_COLOR=

# zplug
export ZPLUG_HOME="$HOME/.dotfiles/.data/repos/zplug"
