# shellcheck shell=sh

## OTHER
# export BROWSER='brave-browser'
# export SPELL='aspell -x -c'

## XDG
# asdf
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
ASDF_DIR="$XDG_DATA_HOME/asdf"
# export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
_path_prepend "$ASDF_DIR/bin"
_path_prepend "$ASDF_DATA_DIR/shims"

# atom
# export ATOM_HOME="$XDG_DATA_HOME/atom"

# bashmarks
SDIRS="$XDG_DATA_HOME/bashmarks.sh.db"

# crenv
# export CRENV_ROOT="$XDG_DATA_HOME/crenv"
# _path_prepend "$CRENV_ROOT/bin"

# deno
# export DENO_INSTALL="$XDG_DATA_HOME/deno"
# _path_prepend "$DENO_INSTALL_ROOT"
# _path_prepend "$DENO_INSTALL_ROOT/bin"
# shellcheck shell=bash

# dvm
# export DVM_DIR="$XDG_DATA_HOME/dvm"
# _path_prepend "$DVM_DIR/bin"

# g
# export GOPATH="$XDG_DATA_HOME/gopath"
# export GOROOT="$XDG_DATA_HOME/goroot"
# _path_prepend "$GOPATH/bin"

# k9s
# export K9SCONFIG="$XDG_CONFIG_HOME/k9s"

# nimble
# _path_prepend "$XDG_DATA_HOME/nimble/bin"

# nvm
# export NVM_DIR="$XDG_DATA_HOME/nvm"

# phpbrew
# _path_prepend "$XDG_DATA_HOME/phpenv/bin"

# plenv
# export PLENV_ROOT="$XDG_DATA_HOME/plenv"
# _path_prepend "$XDG_DATA_HOME/plenv/bin"

# phpenv
# export PHPENV_ROOT="$XDG_DATA_HOME/phpenv"
# _path_prepend "$PHPENV_ROOT/bin"

# pyenv
# export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
# export PYENV_VIRTUALENV_INIT=1
# _path_prepend "$PYENV_ROOT/bin"
# _path_prepend "$PYENV_ROOT/shims"

# rbenv
# export RBENV_ROOT="$XDG_STATE_HOME/rbenv"
# _path_prepend "$RBENV_ROOT/bin"
# _path_prepend "$RBENV_ROOT/shims"

# rvm
# _path_prepend "$XDG_DATA_HOME/rvm/bin"

# swift
# export SWIFTENV_ROOT="$XDG_DATA_HOME/swiftenv"
# _path_prepend "$SWIFTENV_ROOT/bin"

# todotxt
# export TODOTXT_CFG_FILE="$XDG_CONFIG_HOME/todotxt/config.sh"

# volta
# export VOLTA_HOME="$XDG_STATE_HOME/volta"
# _path_prepend "$XDG_STATE_HOME/volta/bin"
