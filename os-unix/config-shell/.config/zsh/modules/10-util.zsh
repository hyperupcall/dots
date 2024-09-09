zmodload zsh/compctl
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/computil

zmodload zsh/zle
# zmodload zsh/zleparameter
# zmodload zsh/zpty

typeset -U PATH path


autoload run-help
autoload zmv
# autoload -Uz edit-command-line run-help zmv
# autoload -Uz add-zsh-hook

autoload -RU colors && colors
autoload -RUz run-help
autoload -RUz run-help-git
autoload -RUz run-help-svn
autoload -RUz run-help-svk
# autoload -RUz promptinit
# promptinit

[[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}" ]] && bindkey -- "${key[Control-Left]}" backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
