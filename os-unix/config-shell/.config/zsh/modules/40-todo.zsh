# zstyle    ':z4h:'                                              auto-update            no
# zstyle    ':z4h:'                                              iterm2-integration     yes
# zstyle    ':z4h:'                                              propagate-cwd          yes
# zstyle    ':z4h:*'                                             channel                stable
# zstyle    ':z4h:autosuggestions'                               forward-char           accept
# zstyle    ':z4h:fzf-complete'                                  fzf-command            my-fzf
# zstyle    ':z4h:(fzf-complete|fzf-dir-history|fzf-history)'    fzf-flags              --no-exact --color=hl:14,hl+:14
# zstyle    ':z4h:(fzf-complete|fzf-dir-history)'                fzf-bindings           'tab:repeat'
# zstyle    ':z4h:fzf-complete'                                  find-flags             -name '.git' -prune -print -o -print
# zstyle    ':z4h:ssh:*'                                         ssh-command            kitty +kitten ssh
# zstyle    ':z4h:ssh:*'                                         send-extra-files       '~/.zsh-aliases'
# zstyle    ':z4h:ssh:*'                                         enable                 no
# zstyle    ':zle:(up|down)-line-or-beginning-search'            leave-cursor           yes
# zstyle    ':z4h:term-title:ssh'                                preexec                '%* | %n@%m: ${1//\%/%%}'
# zstyle    ':z4h:term-title:local'                              preexec                '%* | ${1//\%/%%}'
# zstyle    ':completion:*:ssh:argument-1:'                      tag-order              hosts users
# zstyle    ':completion:*:scp:argument-rest:'                   tag-order              hosts files users
# zstyle    ':completion:*:(ssh|scp|rdp):*:hosts'                hosts

# if ! (( P9K_SSH )); then
#     zstyle ':z4h:sudo' term ''
# fi

# ###

# z4h install romkatv/archive || return
# z4h tty-wait --timeout-seconds 1.0 --lines-columns-pattern '<70-> <->'
# z4h init || return

# ####

# zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "l:|=* r:|=*"

# ####

# fpath+=($Z4H/romkatv/archive)
# autoload -Uz archive lsarchive unarchive edit-command-line

# zle -N edit-command-line

# my-fzf () {
#     emulate -L zsh -o extended_glob
#     local MATCH MBEGIN MEND
#     fzf "${@:/(#m)--query=?*/$MATCH }"
# }

# my-ctrl-z() {
#     if [[ $#BUFFER -eq 0 ]]; then
#         BUFFER="fg"
#         zle accept-line -w
#     else
#         zle push-input -w
#         zle clear-screen -w
#     fi
# }
# zle -N my-ctrl-z

# ###

# z4h bindkey z4h-backward-kill-word  Ctrl+Backspace
# z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
# z4h bindkey z4h-kill-zword          Ctrl+Alt+Delete

# z4h bindkey backward-kill-line      Ctrl+U
# z4h bindkey kill-line               Alt+U
# z4h bindkey kill-whole-line         Alt+I

# z4h bindkey z4h-forward-zword       Ctrl+Alt+Right
# z4h bindkey z4h-backward-zword      Ctrl+Alt+Left

# z4h bindkey z4h-cd-back             Alt+H
# z4h bindkey z4h-cd-forward          Alt+L
# z4h bindkey z4h-cd-up               Alt+K
# z4h bindkey z4h-fzf-dir-history     Alt+J

# z4h bindkey my-ctrl-z               Ctrl+Z
# z4h bindkey edit-command-line       Alt+E

# z4h bindkey z4h-eof                 Ctrl+D

# ###

# setopt GLOB_DOTS
# setopt IGNORE_EOF

# ###

# [ -z "$EDITOR" ] && export EDITOR='vim'
# [ -z "$VISUAL" ] && export VISUAL='vim'

# export DIRENV_LOG_FORMAT=
# export FZF_DEFAULT_OPTS="--reverse --multi"
# export SYSTEMD_LESS="${LESS}S"

# ###

# command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

# ###

# z4h source -- /etc/bash_completion.d/azure-cli
# z4h source -- /usr/share/LS_COLORS/dircolors.sh
# z4h source -- $ZDOTDIR/.zsh-aliases
# z4h source -- $ZDOTDIR/.zshrc-private





# gcl() {
#     git clone --recursive "$@"
#     cd -- "${${${@: -1}##*/}%*.git}"
# }

# grf() {
#     upstream="$(git remote get-url upstream 2>/dev/null || git remote get-url origin)"
#     if [[ $# == 1 ]]; then
#         if [[ "$upstream" == https* ]]; then
#             fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print $1 "/" $2 "/" $3 "/" name "/" $5 }')
#         else
#             fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print "https://github.com/" name "/" $2 }')
#         fi

#         git remote remove "$1" 2>/dev/null
#         git remote add "$1" "$fork"
#         git fetch "$1"
#     else
#         myfork=$(echo "$upstream" | awk -v name="$USER" -F/ '{ print "git@github.com:" name "/" $5 }')

#         git remote remove upstream 2>/dev/null
#         git remote remove origin 2>/dev/null

#         git remote add upstream "$upstream"
#         git remote add origin "$myfork"

#         git fetch upstream
#         git fetch origin

#         git branch --set-upstream-to=upstream/main main
#     fi
# }

# ### pacman

# alias paci='SNAP_PAC_SKIP=true pac -Sy'
# alias paci!='pac -Sy -dd'
# alias pacr='SNAP_PAC_SKIP=true pac -Rs'
# alias pacr!='pac -Rs -dd'
# alias pacf='SNAP_PAC_SKIP=true pac -U'
# alias pacF='pacman -F'
# alias pacq='pacman -Si'
# alias pacl='pacman -Ql'
# alias pacdiff='sudo \pacdiff; refresh-waybar-updates'

# pac() {
#     sudo -E pacman "$@" || return 1

#     is_removal=0
#     while [[ "$1" == -* ]]; do
#         [[ "$1" == "-R"* ]] && is_removal=1
#         shift
#     done
#     if (( is_removal )); then
#         echo "\nCleaning up AUR repo..."
#         repo-remove -s /var/cache/pacman/maximbaz-local/maximbaz-local.db.tar "$@"
#     fi

#     echo "\nCleaning up repo cache..."
#     sudo -E paccache -vr -c /var/cache/pacman/pkg -c /var/cache/pacman/maximbaz-local
#     sudo -E paccache -vruk0 -c /var/cache/pacman/pkg -c /var/cache/pacman/maximbaz-local

#     refresh-waybar-updates
#     rehash
# }
# command -v pacman &> /dev/null && compdef pac=pacman

# pacs() {
#     [ $# -lt 1 ] && { >&2 echo "No search term provided"; return 1; }
#     sudo -E pacman -Sy
#     tmp=$(mktemp -d)

#     {
#         NO_COLOR=true aur search -n -k NumVotes $(basename -a "$@" | xargs)
#         pacman -Ss $(basename -a "$@" | xargs)
#     } |
#     while read -r pkg; do
#         read -r desc
#         name="${pkg%% *}"
#         mkdir -p "$tmp/${name%/*}"
#         echo "$pkg" >>$tmp/pkgs
#         echo "$desc" >$tmp/$name
#     done
#     [ -s $tmp/pkgs ] || { >&2 echo "No packages found"; rm -rf "$tmp"; return 2; }

#     aur_pkgs=()
#     repo_pkgs=()
#     cat $tmp/pkgs | fzf --tac --preview-window=wrap --preview="cat $tmp/{1}; echo; echo; pacman -Si \$(basename {1}) 2>/dev/null; true" |
#     while read -r pkg; do
#         title="${pkg%% *}"
#         if [ "${title%/*}" = "aur" ]; then
#             aur_pkgs+=("${title#*/}")
#         else
#             repo_pkgs+=("${title#*/}")
#         fi
#     done
#     rm -rf "$tmp"

#     if (( ${#aur_pkgs[@]} )); then
#         aur sync -Sc "${aur_pkgs[@]}"
#         post_aur
#     fi
#     SNAP_PAC_SKIP=true pac -Sy "${aur_pkgs[@]}" "${repo_pkgs[@]}"
# }

# pacu() {
#     xargs -a <(aur vercmp-devel | cut -d: -f1) aur sync -Scu --rebuild "$@"
#     post_aur
#     pac -Syu
# }

# pacQ() {
#     [[ $# == 1 ]] || return 1;
#     [ -e "$1" ] && file="$1" || file="$(which "$1")"
#     [ -e "$file" ] || { echo >&2 "File '$1' not found, aborting."; return 1; }
#     pacman -Qo "$file"
# }

# aurs() {
#     aur sync -Sc "$@"
#     sudo -E pacman -Sy
#     refresh-waybar-updates
#     post_aur
# }
# alias aurs!='aurs --nover-argv -f'

# aurb() {
#     aur build -Scf --pkgver "$@"
#     sudo -E pacman -Sy
#     refresh-waybar-updates
#     post_aur
# }

# post_aur() {
#     find ~/.cache/aurutils/sync -name .git -execdir git clean -fx \; >/dev/null
#     find /var/cache/pacman/maximbaz-local -group root -delete >/dev/null
# }

# refresh-waybar-updates() {
#     systemctl --user start waybar-updates.service
# }

# rga-fzf() {
#     RG_PREFIX="rga --files-with-matches"
#     xdg-open "$(
#         FZF_DEFAULT_COMMAND="$RG_PREFIX $@" \
#             fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
#                 --bind=tab:down,btab:up \
#                 --phony -q "$1" \
#                 --bind "change:reload:$RG_PREFIX {q}" \
#                 --preview-window="70%:wrap"
#     )"
# }
