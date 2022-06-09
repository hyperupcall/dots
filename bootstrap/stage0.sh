#!/usr/bin/env sh
set -e

die() {
	error "$@"
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Exiting\n" '=>' >&2
	exit 1
}

error() {
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Error: %s\n" '=>' "$1" >&2
}

log() {
	printf "$GLOBAL_FMT_START%s$GLOBAL_FMT_END Info: %s\n" '=>' "$1" >&2
}

ensure() {
	if "$@"; then :; else
		error "Failed to run command (code $?)"
		printf '%s\n' "  -> Command: $*" >&2
		exit 1
	fi
}

iscmd() {
	if command -v "$1" >/dev/null 2>&1; then
		return $?
	else
		return $?
	fi
}

# shellcheck disable=SC3028,SC3054
if [ -n "$BASH" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
	printf '%s\n' "Error: File 'stage0.sh' should not be sourced"
	return 1
fi


if [ -t 0 ]; then
	GLOBAL_FMT_BLACK_FG='\033[1;30m'
	GLOBAL_FMT_WHITE_BG='\033[1;47m'
	GLOBAL_FMT_RESET='\033[0;0m'
	GLOBAL_FMT_START="$GLOBAL_FMT_WHITE_BG$GLOBAL_FMT_BLACK_FG"
	GLOBAL_FMT_END="$GLOBAL_FMT_RESET"
else
	GLOBAL_FMT_START=
	GLOBAL_FMT_END=
fi

# Ensure prerequisites
mkdir -p ~/.bootstrap

if ! iscmd 'sudo'; then
	die "Please install 'sudo' before running this script"
fi

case $(uname) in darwin*)
	log 'Installing Homebrew'

	ensure cd "$(mktemp -d)"
	curl -fsSLo './install.sh' 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
	bash './install.sh'
esac

if iscmd 'git'; then
	log 'Already installed git'
else
	log 'Installing git'

	if iscmd 'pacman'; then
		ensure sudo pacman -S --noconfirm 'git'
	elif iscmd 'apt-get'; then
		ensure sudo apt-get -y install 'git'
	elif iscmd 'dnf'; then
		ensure sudo dnf -y install 'git'
	elif iscmd 'zypper'; then
		ensure sudo zypper -y install 'git'
	elif iscmd 'eopkg'; then
		ensure sudo eopkg -y install 'git'
	elif iscmd 'brew'; then
		ensure brew install 'git'
	fi

	if ! iscmd 'git'; then
		die 'Automatic installation of git failed'
	fi
fi

if iscmd 'nvim'; then
	log 'Already installed neovim'
else
	log 'Installing neovim'

	if iscmd 'pacman'; then
		ensure sudo pacman -S --noconfirm 'neovim'
	elif iscmd 'apt-get'; then
		ensure sudo apt-get -y install 'neovim'
	elif iscmd 'dnf'; then
		ensure sudo dnf -y install 'neovim'
	elif iscmd 'zypper'; then
		ensure sudo zypper -y install 'neovim'
	elif iscmd 'eopkg'; then
		ensure sudo eopkg -y install 'neovim'
	elif iscmd 'brew'; then
		ensure brew install 'neovim'
	fi

	if ! iscmd 'nvim'; then
		die 'Automatic installation of neovim failed'
	fi
fi

# Install ~/.dots
if [ -d ~/.dots ]; then
	log 'Already cloned github.com/hyperupcall/dots'
else
	log 'Cloning github.com/hyperupcall/dots'

	ensure git clone --quiet https://github.com/hyperupcall/dots ~/.dots
fi
ensure mkdir -p ~/.dots/.usr/bin
ensure ln -sf ~/.dots/bootstrap/dotmgr/bin/dotmgr ~/.dots/.usr/bin/dotmgr
ensure cd ~/.dots
	ensure git remote set-url origin 'git@github.com:hyperupcall/dots'
	ensure ./bake init
ensure cd ~

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
	die 'Failed to find file at ~/.dots/xdg.sh'
fi

# Export variables for 'bootstrap.sh'
cat > ~/.bootstrap/stage0-out.sh <<-EOF
# shellcheck shell=sh

export NAME="Edwin Kofler"
export EMAIL="edwin@kofler.dev"
export EDITOR="$EDITOR"
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dots/.usr/bin:\$PATH"

if [ -f ~/.dots/xdg.sh ]; then
  . ~/.dots/xdg.sh
else
  printf '%s\n' 'Error: ~/.dots/xdg.sh not found'
  return 1
fi
EOF

cat <<-"EOF"
---
. ~/.bootstrap/stage0-out.sh
dotmgr bootstrap
---
EOF
