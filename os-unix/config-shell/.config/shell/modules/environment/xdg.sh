# shellcheck shell=sh

# android
export ANDROID_HOME="$XDG_STATE_HOME/Android/Sdk"
_path_prepend "$ANDROID_HOME/emulator"
_path_prepend "$ANDROID_HOME/tools"
_path_prepend "$ANDROID_HOME/tools/bin"
_path_prepend "$ANDROID_HOME/platform-tools"
export ANDROID_USER_HOME="$XDG_STATE_HOME/Android/User"

# antigen
export _ANTIGEN_INSTALL_DIR="$XDG_STATE_HOME/antigen"

# aspell
# export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_STATE_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_STATE_HOME/aws/config"

# azure
export AZURE_CONFIG_DIR="$XDG_STATE_HOME/azure"

# babel
export BABEL_CACHE_PATH="$XDG_CACHE_HOME/babel.json"

# bash-completion
export BASH_COMPLETION_USER_DIR="$XDG_CONFIG_HOME/bash"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash_completion.sh"

# boto
export BOTO_CONFIG="$XDG_DATA_HOME/boto"

# bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# cabal
export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export CABAL_DIR="$XDG_DATA_HOME/cabal"
_path_prepend "$CABAL_DIR/bin"

# ccache
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME/ccache/config"

# cinelerra
export CIN_CONFIG="$XDG_CONFIG_HOME/bcast5"

# conan
export CONAN_USER_HOME="$XDG_STATE_HOME"

# conda
export CONDA_ROOT="$XDG_CONFIG_HOME/conda"

# cookiecutter
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/cookiecutterrc"

# cpanm
export PERL_CPANM_HOME="$XDG_DATA_HOME/cpanm"

# crawl
export CRAWL_DIR="$XDG_DATA_HOME/crawl/" # trailing slash required

# cuda
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# curl
export CURL_HOME="$XDG_CONFIG_HOME/curl"

# dart
export PUB_CACHE="$XDG_CACHE_HOME/pub-cache"

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# docker-machine
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"

# duc
export DUC_DATABASE="$XDG_DATA_HOME/duc.db"

# dvdcss
export DVDCSS_CACHE="$XDG_CACHE_HOME/dvdcss"

# electrum
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"

# elinks
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"

# emscripten
# export EM_CONFIG="$XDG_CONFIG_HOME/emscripten/config"
export EM_CACHE="$XDG_CACHE_HOME/emscripten"
# export EM_PORTS="$XDG_DATA_HOME/emscripten/cache"

# gdb
export GDBHISTFILE="$XDG_STATE_HOME/history/gdb_history"

# gem
export GEM_HOME="$XDG_DATA_HOME/gem" # conflicts with rvm
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
_path_prepend "$GEM_HOME/bin"
# _path_prepend "$HOME/.gem/ruby/2.7.0/bin"

# get_iplayer
export GETIPLAYERUSERPREFS="$XDG_DATA_HOME/get_iplayer"

# ghcup (haskell)
export GHCUP_INSTALL_BASE_PREFIX="$XDG_DATA_HOME/ghcup"
_path_prepend "$GHCUP_INSTALL_BASE_PREFIX/bin" # requires symlink

# gitlib
export GITLIBS="$XDG_DATA_HOME/gitlibs"

# gnustep
export GNUSTEP_USER_ROOT="$XDG_DATA_HOME/GNUstep"

# gpodder
export GPODDER_HOME="$XDG_DATA_HOME/gPodder"

# gq
export GQRC="$XDG_CONFIG_HOME/gqrc"
export GQSTATE="$XDG_DATA_HOME/gq/gq-state"

# gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# grip
export GRIPHOME="$XDG_CONFIG_HOME/grip"

# gtk
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# hledger
export LEDGER_FILE="$XDG_STATE_HOME/hledger/hledger.journal"

# ida
export IDAUSR="$XDG_STATE_HOME/idapro"

# imap
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

# info
alias info='info --init-file $XDG_CONFIG_HOME/info/infokey'

# ipfs
export IPFS_PATH="$XDG_DATA_HOME/ipfs"

# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"

# irb
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

# irssi
alias irssi='irssi --config "$XDG_CONFIG_HOME/irssi" --home "$XDG_CONFIG_HOME/irssi"'

# java
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_STATE_HOME/java"
export JAVA_TOOL_OPTIONS="-Djava.util.prefs.userRoot=$XDG_STATE_HOME/java"

# julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export JULIA_HISTORY="$XDG_STATE_HOME/history/julia_history"

# junest
export JUNEST_HOME="$XDG_DATA_HOME/junest"

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# kde
export KDEHOME="$XDG_CONFIG_HOME/kde"

# krew
export KREW_ROOT="$XDG_STATE_HOME/krew"
_path_prepend "$KREW_ROOT/bin"

# ldap
# export LDAPRC="$XDG_CONFIG_HOME/ldap.conf"

# leiningen
export LEIN_HOME="$XDG_STATE_HOME/lein"

# ltrace
alias ltrace='ltrace -F "$XDG_CONFIG_HOME/ltrace/ltrace.conf"'

# maven
alias mvn='mvn -gs "$XDG_CONFIG_HOME/maven/settings.xml"'

# maxima
export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"

# mbsync
export MBSYNC_CONFIG="$XDG_CONFIG_HOME/mbsync/config"

# mednafen
export MEDNAFEN_HOME="$XDG_CONFIG_HOME/mednafen"

# minikube
export MINIKUBE_HOME="$XDG_STATE_HOME/minikube"

# most
export MOST_INITFILE="$XDG_CONFIG_HOME/most/mostrc"

# mplayer
export MPLAYER_HOME="$XDG_STATE_HOME/mplayer"

# mysql
export MYSQL_HISTFILE="$XDG_STATE_HOME/history/mysql_history"

# n
export N_PREFIX="$XDG_DATA_HOME/n"
_path_prepend "$N_PREFIX/bin"

# nb
export NBRC_PATH="$XDG_CONFIG_HOME/nb/nbrc"
export NB_DIR="$XDG_DATA_HOME/nb"
export NB_HIST="$XDG_STATE_HOME/history/nb_history"

# node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/history/node_repl_history"
export TS_NODE_HISTORY="$XDG_STATE_HOME/history/ts_node_repl_history"

# node-gyp
export npm_config_devdir="$XDG_STATE_HOME/node-gyp"

# node-spawn-wrap
export SPAWN_WRAP_SHIM_ROOT="$XDG_STATE_HOME/node-spawn-wrap"

# notmuch
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# nuget
export NUGET_PACKAGES="$XDG_DATA_HOME/nuget/packages"

# nvidia
# alias nvidia-settings='nvidia-settings --config $XDG_DATA_HOME/nvidia-settings'

# octave
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export OCTAVE_HISTFILE="$XDG_STATE_HOME/history/octave-history"

# opera
export OPERA_PERSONALDIR="$XDG_STATE_HOME/opera"

# packer
export PACKER_CONFIG="$XDG_DATA_HOME/packer/packerconfig"
export PACKER_CONFIG_DIR="$XDG_DATA_HOME/packer/packer.d"

# parallel
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"

# pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"

# perl
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl5"
export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
export PERL_MM_OPT="INSTALL_BASE=\"$PERL_LOCAL_LIB_ROOT\""
_path_prepend "$PERL_LOCAL_LIB_ROOT/bin"
_path_prepend PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5"

# pipx
export PIPX_HOME="$XDG_STATE_HOME/pipx/virtualenv"
export PIPX_BIN_DIR="$XDG_STATE_HOME/pipx/bin"

# platformio
# export PLATFORMIO_CORE_DIR="$XDG_STATE_HOME/platformio"
# _path_prepend "$PLATFORMIO_CORE_DIR/penv/bin"

# poetry
export POETRY_HOME="$XDG_DATA_HOME/poetry"
_path_prepend "$POETRY_HOME/bin"

# postgresql
export PSQLRC="$XDG_DATA_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/history/psql_history"
export PGPASSFILE="$XDG_DATA_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_DATA_HOME/pg/pg_service.conf"

# pulse
# export PULSE_COOKIE="$XDG_STATE_HOME/pulse/cookie"

# pylint
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/config"

# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py" # https://github.com/python/cpython/pull/13208
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"

# racket
export PLTUSERHOME="$XDG_DATA_HOME/racket"

# readline
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# redis
export REDISCLI_RCFILE="$XDG_CONFIG_HOME/redis/redisclirc"
export REDISCLI_HISTFILE="$XDG_STATE_HOME/history/redis_history"

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# rlwrap
export RLWRAP_HOME="$XDG_STATE_HOME/history"

# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
_path_prepend "$CARGO_HOME/bin"

# ruby-build
export RUBY_BUILD_CACHE_PATH="$XDG_CACHE_HOME/ruby-build"

# sage
export DOT_SAGE="$XDG_CONFIG_HOME/sage"

# sbt
# alias sbt='sbt -ivy "$XDG_DATA_HOME/ivy2" -sbt-dir "$XDG_DATA_HOME/sbt"'

# sccache
export SCCACHE_CACHE_SIZE='100G'
export SCCACHE_DIR="$XDG_CACHE_HOME/sccache"

# screen
export SCREENRC="$XDG_CONFIG_HOME/screenrc"

# spacemacs
export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs"

# xsm
export SM_SAVE_DIR="$XDG_DATA_HOME/xsm"

# sonarlint
export SONARLINT_USER_HOME="$XDG_DATA_HOME/sonarlint"

# sqlite
export SQLITE_HISTORY="$XDG_STATE_HOME/history/sqlite_history"

# stack
export STACK_ROOT="$XDG_DATA_HOME/stack"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# task
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"
export TASKDATA="$XDG_DATA_HOME/taskwarrior"

# terminfo
# export TERMINFO="$XDG_DATA_HOME"/terminfo
# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# TeXmf
export TEXMFHOME="$XDG_DATA_HOME/textmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

# TeXmacs
export TEXMACS_HOME_PATH="$XDG_STATE_HOME/texmacs"

# tree-sitter
export TREE_SITTER_DIR="$XDG_CONFIG_HOME/tree-sitter"

# ts3
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"

# uncrustify
export UNCRUSTIFY_CONFIG="$XDG_CONFIG_HOME/uncrustify/uncrustify.cfg"

# unison
export UNISON="$XDG_DATA_HOME/unison"

# vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$VAGRANT_HOME/aliases"

# vimperator
export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/vimperatorrc"
export VIMPERATOR_RUNTIME="$XDG_CONFIG_HOME/vimperator"

# vpython (chromium)
export VPYTHON_VIRTUALENV_ROOT="$XDG_STATE_HOME/vpython"

# urxvt
export URXVT_PERL_LIB="$XDG_CONFIG_HOME/urxvt/ext"
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd

# wakatime
export WAKATIME_HOME="$XDG_DATA_HOME/wakatime"

# wasmer
export WASMER_DIR="$XDG_DATA_HOME/wasmer"
# [ -r "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# wasmtime
export WASMTIME_HOME="$XDG_DATA_HOME/wasmtime"
_path_prepend "$WASMTIME_HOME/bin"

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# wine
export WINEPREFIX="$XDG_DATA_HOME/wine"

# wolfram mathematica
export MATHEMATICA_BASE="/usr/share/mathematica"
export MATHEMATICA_USERBASE="$XDG_DATA_HOME/mathematica"

# xsel
alias xsel='xsel -l "$XDG_DATA_HOME/xsel/xsel.log'

# yarn
export YARN_CACHE_FOLDER="$XDG_CACHE_HOME/yarn"
_path_prepend "$HOME/.yarn/bin"
# _path_prepend "$XDG_DATA_HOME/yarn/bin"
# alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# z
export _Z_DATA="$XDG_DATA_HOME/z"
