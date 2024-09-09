source "$XDG_CONFIG_HOME/shell/modules/common/line-editing.sh"

_zle_x_discard() {
	_lineediting_action_x_discard "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_kill() {
	_lineediting_action_x_kill "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_yank() {
	_lineediting_action_x_yank "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_x_paste() {
	_lineediting_action_x_paste "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_show_help() {
	_lineediting_action_show_help "$BUFFER"
}

_zle_show_man() {
	_lineediting_action_show_man "$BUFFER"
}

_zle_show_tldr() {
	_lineediting_action_show_tldr "$BUFFER"
}

_zle_toggle_sudo() {
	_lineediting_action_toggle_sudo "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_toggle_backslash() {
	_lineediting_action_toggle_backslash "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_toggle_comment() {
	_lineediting_action_toggle_comment "$BUFFER" "$CURSOR"
	BUFFER="$REPLY1"
	CURSOR="$REPLY2"
}

_zle_trim_whitespace() {
	BUFFER="$(
		_lineediting_action_trim_whitespace "$BUFFER"
	)"
}

_zle_ls(){
	_shell_util_ls
}

_zle_exit() {
	exit
}

zle -N _zle_x_discard
zle -N _zle_x_kill
zle -N _zle_x_yank
zle -N _zle_x_paste
zle -N _zle_show_help
zle -N _zle_show_man
zle -N _zle_show_tldr
zle -N _zle_toggle_sudo
zle -N _zle_toggle_backslash
zle -N _zle_toggle_comment
zle -N _zle_trim_whitespace
zle -N _zle_ls
zle -N _zle_exit

bindkey -e "\eu" _zle_x_discard
bindkey -e "\ek" _zle_x_kill
bindkey -e "\ey" _zle_x_yank
bindkey -e "\eo" _zle_x_paste
bindkey -e "\eh" _zle_show_help
bindkey -e "\em" _zle_show_man
# bindkey -e "\et" _zle_show_tldr
bindkey -e "\es" _zle_toggle_sudo
bindkey -e "\e\\" _zle_toggle_backslash
bindkey -e "\e/" _zle_toggle_comment
bindkey -e "\C-_" _zle_toggle_comment
bindkey -e "\ei" _zle_trim_whitespace
bindkey -e "\el" _zle_ls

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
# [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"

# [[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
# [[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# typeset -g -A key

# key[Home]="${terminfo[khome]}"
# key[End]="${terminfo[kend]}"
# key[Insert]="${terminfo[kich1]}"
# key[Backspace]="${terminfo[kbs]}"
# key[Delete]="${terminfo[kdch1]}"
# key[Up]="${terminfo[kcuu1]}"
# key[Down]="${terminfo[kcud1]}"
# key[Left]="${terminfo[kcub1]}"
# key[Right]="${terminfo[kcuf1]}"
# key[PageUp]="${terminfo[kpp]}"
# key[PageDown]="${terminfo[knp]}"
# key[Shift-Tab]="${terminfo[kcbt]}"

# # setup key accordingly
# [[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
# [[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
# [[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
# [[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
# [[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
# [[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
# [[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
# [[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
# [[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
# [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
# [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
# [[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


bindkey -M vicmd '^T' history-incremental-pattern-search-backward # Patterned history search with zsh expansion, globbing, etc.
bindkey '^T' history-incremental-pattern-search-backward
bindkey -e
bindkey ' ' magic-space
bindkey -M isearch '^M' accept-search # Verify search result before accepting
