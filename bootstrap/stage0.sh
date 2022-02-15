#!/usr/bin/env bash
set -e

die() {
	printf '%s\n' "ERROR: $1. Exiting" >&2
	exit 1
}

ensure() {
	if "$@"; then :; else
		die "Command '$*' failed (code $?)"
	fi
}

log() {
	printf 'INFO: %s\n' "$1"
}

iscmd() {
	if command -v "$1" &>/dev/null; then
		return 0
	else
		return $?
	fi
}

if [ -n "$BASH" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
	printf '%s\n' "Error: File 'stage0.sh' should not be sourced"
	exit 1
fi

# Ensure prerequisites
mkdir -p ~/.bootstrap

if ! iscmd sudo; then
	die "Sudo not installed"
fi

if ! iscmd git; then
	log 'Installing git'

	if iscmd pacman; then
		ensure sudo pacman -S --noconfirm git
	elif iscmd apt-get; then
		ensure sudo apt-get -y install git
	elif iscmd dnf; then
		ensure sudo dnf -y install git
	elif iscmd zypper; then
		ensure sudo zypper -y install git
	elif iscmd eopkg; then
		ensure sudo eopkg -y install git
	fi

	if ! iscmd git; then
		die 'Automatic installation of sudo failed'
	fi
fi

if ! iscmd nvim; then
	log 'Installing neovim'

	if iscmd pacman; then
		ensure sudo pacman -S --noconfirm neovim
	elif iscmd apt-get; then
		ensure sudo apt-get -y install neovim
	elif iscmd dnf; then
		ensure sudo dnf -y install neovim
	elif iscmd zypper; then
		ensure sudo zypper -y install neovim
	elif iscmd eopkg; then
		ensure sudo eopkg -y install neovim
	fi

	if ! iscmd nvim; then
		die 'Automatic installation of neovim failed'
	fi
fi

# Install ~/.dots
if [ ! -d ~/.dots ]; then
	log 'Cloning github.com/hyperupcall/dots'

	ensure git clone --quiet https://github.com/hyperupcall/dots ~/.dots
	ensure cd ~/.dots
	ensure git remote set-url origin git@github.com:hyperupcall/dots
	ensure git config --local filter.npmrc-clean.clean "$(pwd)/user/config/npm/npmrc-clean.sh"
	ensure git config --local filter.slack-term-config-clean.clean "$(pwd)/user/config/slack-term/slack-term-config-clean.sh"
	ensure git config --local filter.oscrc-clean.clean "$(pwd)/user/config/osc/oscrc-clean.sh"
	ensure cd
fi

# Set EDITOR so editors like 'vi' or 'vim' that may not be installed
# are never executed
if [ -z "$EDITOR" ]; then
	if iscmd nvim; then
		EDITOR='nvim'
	elif iscmd vim; then
		EDITOR='vim'
	elif iscmd nano; then
		EDITOR='nano'
	elif iscmd vi; then
		EDITOR='vi'
	else
		die "Variable EDITOR cannot be set. Is nvim installed?"
	fi
fi

if [ ! -f ~/.dots/xdg.sh ]; then
	die '~/.dots/xdg.sh not found'
fi

# Export variables for 'bootstrap.sh'
cat > ~/.bootstrap/stage1.sh <<-EOF
# shellcheck shell=sh

export NAME="Edwin Kofler"
export EMAIL="edwin@kofler.dev"
export EDITOR="$EDITOR"
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dots/bootstrap/dotmgr/bin:\$PATH"

if [ -f ~/.dots/xdg.sh ]; then
  . ~/.dots/xdg.sh
else
  printf '%s\n' 'Error: ~/.dots/xdg.sh not found'
  exit 1
fi
EOF

cat <<-"EOF"
---
. ~/.bootstrap/stage1.sh
dotmgr bootstrap-stage1
---
EOF
