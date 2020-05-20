#!/bin/sh

## general ##
# editor
export VISUAL="nvim"
export EDITOR="$VISUAL"
export SUDO_EDITOR="$VISUAL"
export DIFFPROG="nvim -d"
export PAGER="less"
export LANG=${LANG:-en_US.UTF-8}

# xdg
export XDG_DATA_HOME="$HOME/.local/share" # default
export XDG_CONFIG_HOME="$HOME/.config" # default
export XDG_DATA_DIRS="/usr/local/share/:/usr/share" # default
export XDG_CONFIG_DIRS="/etc/xdg" # default
export XDG_CACHE_HOME="$HOME/.cache" # default

# path
export PATH="$HOME/.local/bin:$PATH"


## programs / utilities ##
# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# most [jedsoft.org/most]
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# postgresql
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# nvm (github.com/nvm-sh/nvm)
export NVM_DIR="$XDG_DATA_HOME"/nvm

# less [greenwoodsoftware.com/less]
#export LESS="--mouse -q"
export LESSKEY="$XDG_CONFIG_HOME/less/keys"
export LESSHISTFILE="$XDG_CONFIG_HOME/less/history"
export LESSHISTSIZE="250"

# code (github.com/microsoft/vscode) [code.visualstudio.com]

# irssi (github.com/irssi/irssi) [irssi.org]
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi"'

# gnupg (git.gnupg.org/cgi-bin/gitweb.cgi) [gnupg.org]
alias gpg2='gpg2 --homedir "$XDG_DATA_HOME/gnupg"'
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
tty="$(tty)" && export GPG_TTY="$tty"; unset tty

# nnn (github.com/jarun/nnn)
export NNN_FALLBACK_OPENER="xdg-open"
export NNN_DE_FILE_MANAGER="nautilus"

# boto (github.com/boto/boto) [docs.pythonboto.org]
export BOTO_CONFIG="$XDG_CONFIG_HOME/boto"

# elinks (elinks.cz/elinks.git) [elinks.or.cz]
export ELINKS_CONFDIR="$XDG_DATA_HOME/elinks"

# ice
export ICEAUTHORITY="$XDG_RUNTIME_DIR/iceauthority"

# mplayer [mplayerhq.hu]
export MPLAYER_HOME=$XDG_CONFIG_HOME/mplayer

# tmux (github.com/tmux/tmux)
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# snap (github.com/snapcore/snapd) [snapcraft.io]
export PATH="/snap/bin:$PATH"

# gitlib (github.com/jwiegley/gitlib)
export GITLIBS="$HOME/.local/opt/gitlibs"

# sccache (github.com/mozilla/sccache)
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"
export SCCACHE_CACHE_SIZE="20G"

# ccache (github.com/ccache/ccache) [ccache.dev]
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME"/ccache.config

# subversion [subversion.apache.org]
export SUBVERSION_HOME=$XDG_CONFIG_HOME/subversion

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# mysql (github.com/mysql/mysql-server) [mysql.com]
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"

# netbeams (github.com/apache/netbeans) [netbeans.org]
alias netbeams='netbeans --userdir "$XDG_CONFIG_HOME/netbeans"'

## programming programs ##
# wolfram mathematica [wolfram.com/mathematica]
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# docker (github.com/moby/moby) [docker.com]
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# ansible (github.com/ansible/ansible) [ansible.com]
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible.cfg"

# kubernetes (github.com/kubernetes/kubernetes)
export KUBECONFIG="$XDG_DATA_HOME/kube"

# krew (github.com/kubernetes-sigs/krew) [krew.sigs.k8s.io]
export KREW_ROOT="$HOME/.local/opt/krew"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# terraform (github.com/hashicorp/terraform) [terraform.io]
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraformrc-custom"

# screen (git://git.savannah.gnu.org/screen.git) [gnu.org/software/screen]
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"

# vagrant (github.com/hashicorp/vagrant) [vagrantup.com]
export VAGRANT_HOME="$HOME/.local/opt/vagrant.d"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# packer (github.com/hashicorp/packer) [packer.io]
export PACKER_CONFIG="$XDG_CONFIG_HOME/packerconfig"
export PACKER_CONFIG_DIR="$XDG_CONFIG_HOME/packer.d"

# anki (github.com/ankitects/anki) [apps.ankiweb.net]
alias anki='anki -b "$XDG_DATA_HOME/anki"'

# atom (github.com/atom/atom) [atom.io]
export ATOM_HOME="$XDG_DATA_HOME/atom"

# bash-completeion
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"

## programming ##
# node [nodejs.org]
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# npm (github.com/npm/cli) [npmjs.com]
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"

# n (github.com/tj/n)
export N_PREFIX="$HOME/.local/opt/n"
export PATH="$N_PREFIX/bin:$PATH"

# yarn (github.com/yarnpkg/yarn) [yarnpkg.com]
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/node_modules/.bin:$PATH"

# rust (github.com/rust-lang/rust) [rust-lang.org]
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$CARGO_HOME/bin:$PATH"

# poetry (github.com/sdispater/poetry) [python-poetry.org]
export PATH="$HOME/.poetry/bin:$PATH"

# go (github.com/golang/go) [golang.org]
export GOROOT="$HOME/.local/go-root"
export GOPATH="$HOME/.local/go-path"
export PATH="$HOME/$GOPATH/bin:$PATH"

# dart (github.com/dart-lang/sdk) [dart.dev]
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# flutter (github.com/flutter/flutter) [flutter.dev]
export PATH="$HOME/.local/opt/flutter/bin:$PATH"

# ipython (github.com/ipython/ipython) [ipython.org]
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter

# jupyter [jupyter.org]
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# gradle (github.com/gradle/gradle) [gradle.org]
export GRADLE_USER_HOME="$HOME/.local/opt/gradle"

# maven (github.com/apache/maven) [maven.apache.org]
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'

# rvm (github.com/rvm/rvm) [rvm.io]
# shellcheck source=/home/edwin/.rvm/scripts/rvm
test -r "$HOME/.rvm/scripts/rvm" && . "$HOME/.rvm/scripts/rvm"
export PATH="$HOME/.rvm/bin:$PATH"

# gem (github.com/rubygems/rubygems) [rubygems.org]
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem

# bundle (github.com/rubygems/bundler) [bundler.io]
export BUNDLE_CACHE_PATH="$XDG_CACHE_HOME/bundle"

# gcloud [cloud.google.com/sdk/gcloud]
test -r "$HOME/.local/opt/google-cloud-sdk/path.bash.inc" && . "$HOME/.local/opt/google-cloud-sdk/path.bash.inc"
test -r "$HOME/.local/opt/google-cloud-sdk/completion.bash.inc" && . "$HOME/.local/opt/google-cloud-sdk/completion.bash.inc"

# stack (github.com/commercialhaskell/stack) [haskellstack.org]
export STACK_ROOT="$XDG_DATA_HOME/stack"

# buku (github.com/jarun/buku)
alias b="bukdu --suggest"

# tails (github.com/eankeen/eankeen)
alias t='node -r esm $HOME/repos/tails/tails-cli/src/index.js'

# dotdrop (https://github.com/deadc0de6/dotdrop) [deadc0de.re/dotdrop]
alias dotdrop='dotdrop --cfg=$HOME/.dots/config.yaml'

# http-serve (node package)
alias http-serve='http-serve -c-1'

## aliases ##
alias cp="cp -i"
alias df="df -h"
alias free="free -m" 

# deno
export DENO_INSTALL="/home/edwin/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export DENO_INSTALL_ROOT="$XDG_DATA_HOME/deno"
export PATH="/home/edwin/.local/share/deno/bin:$PATH"
alias dem='/home/edwin/.local/share/deno/bin/cmd'
