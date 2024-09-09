# shellcheck shell=sh

alias b='bukdu --suggest'
alias but='btrfs'
alias cat='cat -v' #clone(user, root)
alias cmd='command' #clone(user, root)
alias cmdv='command -v' #clone(user, root)
alias cmdV='command -V' #clone(user, root)
alias copy='xclip -selection clipboard'
alias ddad='dragon-drag-and-drop'
alias hexdump='od -A x -t x1z -v'
alias ipa='ip -c -br a'
alias j='just' #clone(user, root)
alias kssh='kitty +kitten ssh'
alias l='exa -al --icons --git' #clone(user, root)
alias la='exa -a' #clone(user, root)
alias ll='exa -al --icons --git' #clone(user, root)
alias m='make' #clone(user, root)
alias mp='mountpoint' #clone(user, root)
alias p='pass' #clone(user)
alias pbat='bat -p' #clone(user, root)
alias piup='pip install --upgrade pip' #clone(user)
alias pnpxni='pnpx --no-install'
alias pnpxy='pnpm -y'
alias psa='ps xawf -eo pid,user,cgroup,args'
alias tbat='bat --pager "\"$PAGER\" +G"' #clone(user, root)
alias rbat='tbat'
alias rm!='rm -rf'
alias rmrf='rm -rf' #clone(user, root)
alias rmrfv='rm -rfv' #clone(user, root)
alias run-help='help' #clone(user, root)
alias new-venv='python -m venv .venv && source .venv/bin/activate && pip install wheel && piup'
alias ta='type -a' #clone(user, root)
alias utc='TZ=UTC date'
alias ydl='youtube-dl' #clone(user)
alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'
alias totalusage='df -hl --total | grep total'
