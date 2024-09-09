autoload run-help
alias help='run-help'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


SAVEHIST=2147483647
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

HISTFILE="$XDG_STATE_HOME/history/zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward

# autoload -Uz history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey -M vicmd "^P" history-beginning-search-backward-end
# bindkey -M viins "^P" history-beginning-search-backward-end

# bindkey -M vicmd "^N" history-beginning-search-forward-end
# bindkey -M viins "^N" history-beginning-search-forward-end
