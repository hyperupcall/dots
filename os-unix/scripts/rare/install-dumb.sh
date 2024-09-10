#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	# 1. Bash
	if util.confirm 'Install Bash stuff?'; then
		# Frameworks
		util.clone ~/.dotfiles/.data/repos/oh-my-bash 'https://github.com/ohmybash/oh-my-bash'
		util.clone ~/.dotfiles/.data/repos/bash-it 'https://github.com/bash-it/bash-it'
		source ~/.dotfiles/.data/repos/bash-it/install.sh --no-modify-config

		# Prompts
		util.clone ~/.dotfiles/.data/repos/bash-git-prompt 'https://github.com/magicmonty/bash-git-prompt'
		util.clone ~/.dotfiles/.data/repos/bash-powerline 'https://github.com/riobard/bash-powerline'
		util.clone ~/.dotfiles/.data/repos/bashtrap 'https://github.com/barryclark/bashstrap'
		util.clone ~/.dotfiles/.data/repos/git-prompt 'https://github.com/lvv/git-prompt'
		util.clone ~/.dotfiles/.data/repos/liquidprompt 'https://github.com/nojhan/liquidprompt'
		util.clone ~/.dotfiles/.data/repos/oh-my-git 'https://github.com/arialdomartini/oh-my-git'
		util.clone ~/.dotfiles/.data/repos/sexy-bash-prompt 'https://github.com/twolfson/sexy-bash-prompt'

		# Utilities
		util.clone ~/.dotfiles/.data/repos/ble.sh 'https://github.com/akinomyoga/ble.sh'
		util.clone ~/.dotfiles/.data/repos/bashmarks 'https://github.com/huyng/bashmarks'
		# util.clone ~/.dotfiles/.data/repos/basher 'https://github.com/basherpm/basher'
	fi


	# 2. Git
	if util.confirm 'Install Random Git packages?'; then
		util.clone ~/.dotfiles/.data/repos/git-blame-something-else 'jayphelps/git-blame-someone-else'
		util.clone ~/.dotfiles/.data/repos/git-ink 'davidosomething/git-ink'
		util.clone ~/.dotfiles/.data/repos/git-fire 'qw3rtman/git-fire'
		util.clone ~/.dotfiles/.data/repos/git-recent 'paulirish/git-recent'
		util.clone ~/.dotfiles/.data/repos/git-fresh 'imsky/git-fresh'
		util.clone ~/.dotfiles/.data/repos/git-open 'paulirish/git-open'
	fi
}

main "$@"
