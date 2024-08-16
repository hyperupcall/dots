#!/usr/bin/env sh
set -e

# shellcheck disable=SC3028,SC3054,SC2039
if [ -n "$BASH" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
	printf '%s\n' "Error: This file should not be sourced"
	return 1
fi

main() {
	if ! iscmd 'sudo'; then
		die "Please install 'sudo' before running this script"
	fi

	run mkdir -p ~/.bootstrap

	# Install essential commands.
	updatesystem
	case $(uname) in darwin*)
		if iscmd 'brew'; then
			log "Already installed Homebrew"
		else
			log 'Installing Homebrew'
			run curl -fsSLo ~/.bootstrap/install-brew.sh 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
			run bash ~/.bootstrap/install-brew.sh
		fi
		run brew install bash
	esac
	installcmd 'curl' 'curl'
	installcmd 'git' 'git'
	installcmd 'vim' 'vim'

	# Install hyperupcall/dotfiles.
	clonerepo 'github.com/hyperupcall/dotfiles' ~/.dotfiles
	run cd ~/.dotfiles
		run git remote set-url me 'git@github.com:hyperupcall/dotfiles'
		run ./bake init
	run cd

	# Symlink ~/scripts.
	run ln -fs ~/.dotfiles/os/unix/scripts ~/

	# Export variables.
	cat > ~/.bootstrap/bootstrap-out.sh <<EOF
# shellcheck shell=sh

export NAME='Edwin Kofler'
export EMAIL='edwin@kofler.dev'
export EDITOR='vim'
export VISUAL="\$EDITOR"
export PATH="\$HOME/.dotfiles/.data/bin:\$PATH"

if [ -f ~/.dotfiles/os/unix/scripts/xdg.sh ]; then
	. ~/.dotfiles/os/unix/scripts/xdg.sh
else
	printf '%s\n' 'Error: ~/.dotfiles/os/unix/scripts/xdg.sh not found'
	return 1
fi
EOF

	# Print next steps.
	cat <<-"EOF"
	---
	. ~/.bootstrap/bootstrap-out.sh
	~/scripts/lifecycle/doctor.sh
	~/scripts/lifecycle/bootstrap.sh
	dotdrop install -c ~/.dotfiles/os/unix/config/dotdrop/dotdrop.yaml -p nullptr
	~/scripts/lifecycle/idempotent.sh
	---
	EOF
}

die() {
	error "$@"
	printf "=> Exiting\n" >&2
	exit 1
}

error() {
	printf "=> Error: %s\n" "$1" >&2
}

log() {
	printf "=> Info: %s\n" "$1"
}

run() {
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

updatesystem() {
	if iscmd 'pacman'; then
		sudo pacman -Syyu --noconfirm
		local orphaned_dependencies=
		orphaned_dependencies=$(pacman -Qdtq)
		if [ -n "$orphaned_dependencies" ]; then
			sudo pacman -R $orphaned_dependencies
		fi
	elif iscmd 'apt-get'; then
		sudo apt-get -y update
		if ! iscmd 'pkcon'; then # KDE Neon
			sudo apt-get -y upgrade
		fi
		sudo apt-get -y install apt-transport-https
		sudo apt-get -y autoremove
	elif iscmd 'dnf'; then
		sudo dnf -y update
		sudo dnf -y autoremove
	elif iscmd 'zypper'; then
		sudo zypper -y update
		sudo zypper -y upgrade
	else
		die 'Failed to determine package manager'
	fi
}

installcmd() {
	if iscmd "$1"; then
		log "Already installed $1"
	else
		log "Installing $1"

		if iscmd 'pacman'; then
			run sudo pacman -S --noconfirm "$2"
		elif iscmd 'apt-get'; then
			run sudo apt-get -y install "$2"
		elif iscmd 'dnf'; then
			run sudo dnf -y install "$2"
		elif iscmd 'zypper'; then
			run sudo zypper -y install "$2"
		elif iscmd 'eopkg'; then
			run sudo eopkg -y install "$2"
		elif iscmd 'brew'; then
			run brew install "$2"
		else
			die 'Failed to determine package manager'
		fi

		if ! iscmd "$1"; then
			die "Automatic installation of $1 failed"
		fi
	fi
}

clonerepo() {
	if [ -d "$2" ]; then
		log "Already cloned $1"
	else
		log "Cloning $1"
		run git clone --quiet "https://$1" "$2" --recurse-submodules

		git_remote=$(run git -C "$2" remote)
		if [ "$git_remote" = 'origin' ]; then
			run git -C "$2" remote rename origin me
		fi
		unset -v git_remote
	fi
}

main "$@"
