# shellcheck shell=sh

#clone(user)
bash() {
	if { [ "$1" = --noprofile ] && [ "$2" = --norc ]; } \
		|| { [ "$1" = --norc ] && [ "$2" = --noprofile ]; }
	then
		_shell_util_log_info "Additionally resetting path to a sane default"
		PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin" command bash "$@"
	else
		command bash "$@"
	fi
}

#clone(user, root)
cls() {
	# assume hardware is not real (not 'reset')
	tput reset

	# this uses our 'stty' function
	stty sane
}

#clone(user)
cdp() {
	if [ -z "$_shell_cdp_dir" ]; then
		_shell_util_log_error "Variable '_shell_cdp_dir' not set. Recommended is to set it in 'PROMPT_COMMAND' or precmd()"
		return
	fi

	_shell_cdp_current_dir="$_shell_cdp_dir"
	while [ ! -d "$_shell_cdp_current_dir" ] && [ "$PWD" != / ]; do
			_shell_cdp_current_dir="$(dirname "$_shell_cdp_current_dir")"
	done

	# shellcheck disable=SC2164
	cd -- "$_shell_cdp_current_dir"
}

dataurl() {
	mimeType=$(file -b --mime-type "$1")
	case "$mimeType" in
		text/*)
			mimeType="${mimeType};charset=utf-8"
		;;
	esac

	str="$(openssl base64 -in "$1" | tr -d '\n')"
	printf "data:${mimeType};base64,%s\n" "$str"

	unset -v mimeType str
}

docker_nuke() {
	docker ps -q | xargs docker stop
	docker ps -aq | xargs docker rm
	docker images | grep none | col 3 | xargs docker rmi -f
}

#clone(user, root)
dg() {
	dig +nocmd "$1" any +multiline +noall +answer
}

edit() {
	_edit_grep_result="$(grep -nR "^$1() {$" "$XDG_CONFIG_HOME"/shell | head -1)"
	if [ -z "$_edit_grep_result" ]; then
			_edit_grep_result="$(grep -nR "^alias $1=" "$XDG_CONFIG_HOME"/shell)"
			if [ -z "$_edit_grep_result" ]; then
			_shell_util_die "edit: Function or alias '$1' not found"
			return
		fi
	fi

	_edit_file="$(echo "$_edit_grep_result" | awk -F ':' '{ print $1 }')"
	_edit_line="$(echo "$_edit_grep_result" | awk -F ':' '{ print $2 }')"

	# TODO: Use 'default'
	if command -v 'nvim' &>/dev/null; then
		nvim "+$_edit_line" "$_edit_file"
	elif command -v 'vim' &>/dev/null; then
		vim "+$_edit_line" "$_edit_file"
	else
		_shell_util_die "edit: Editor not found"
		return
	fi
	unset -v _edit_grep_result _edit_file _edit_line
}

#clone(user, root)
faketty() {
	unbuffer -p "@"
}

gs() {
	_shell_util_log_warn "Correcting command to: 'g s'"
	g s
}

#clone(user, root)
isup() {
	_shell_util_log_warn "Executing: 'curl -sS --head -X GET \"$1\" | grep -q '200 OK'"
	command curl -sS --head -X GET "$1" | grep -q '200 OK'
}

#clone(user, root)
kkexec() {
	sudo kexec -l /efi/EFI/arch/vmlinuz-linux-lts --initrd /efi/EFI/arch/initramfs-linux-lts.img --reuse-cmdline
	sudo systemctl kexec
	# sudo kexec -e
}

#clone(user, root)
nh() {
	nohup "$@" > /dev/null 2>&1 &
}

pbake() {
	if ! _shell_dir=$(
		while [ ! -d '.git' ] && [ "$PWD" != / ]; do
			if ! cd ..; then
				exit 1
			fi
		done
		if [ "$PWD" = / ]; then
			exit 1
		fi
		printf '%s' "$PWD"
	); then
		_shell_util_die "Failed to cd to nearest Git repository" || return
	fi

	_shell_bakefile='.hidden/Bakefile.sh'
	if [ -f "$_shell_bakefile" ]; then
		_shell_bake=
		if command -v bake >/dev/null 2>&1; then
			_shell_bake='bake'
		else
			_shell_bake='./bake'
		fi

		_shell_util_log_info "Using Bakefile: $PWD/$_shell_bakefile"
		"$_shell_bake" -f "$_shell_bakefile" "$@"

		unset -v _shell_bake _shell_bakefile
	else
		_shell_util_die "Could not find a Bakefile under hidden directory" || return
	fi
}

qe() {
	filterList="BraveSoftware code tetrio-desktop obsidian discord sublime-text Ryujinx unity3d hmcl hdlauncher TabNine zettlr Zettlr Google lunarclient libreoffice VirtualBox configstore pulse obs-studio eDEX-UI 1Password kde.org sublime-text-3 gdlauncher gdlauncher_next launcher-main gitify QtProject GIMP r2modman r2modmanPlus-local Code plover GitKraken Electron bonsai-browser sidekick Insomnia Typora wavebox microsoft-edge evolution chromium"

	_qe_file=$(
		cd -- "$XDG_CONFIG_HOME" || { _shell_util_log_error "qe: Could not cd"; exit 1; }
		filterArgs=
		for file in $filterList; do
			filterArgs="$filterArgs -o -name $file"
		done

		# shellcheck disable=SC2086
		find -L . -ignore_readdir_race \( \
			-name 'Beaker Browser' \
			$filterArgs \
			-o -name 'Helios Launcher' \
			-o -name 'Code - Insiders' \
			-o -path ./kak/plugins \
			-o -path ./kak/autoload \
			-o -path ./cookiecutter/cookiecutters \
		\) -prune -o -print | fzf
	)

	[ -z "$_qe_file" ] && { _shell_util_die "qe: Chosen file empty"; return; }

	_qe_file="$XDG_CONFIG_HOME/$(printf "%s" "$_qe_file" | cut -c3-)"
	v "$_qe_file"
	history -s "v \"$_qe_file\""
	unset -v _qe_file
}

# https://unix.stackexchange.com/a/123770
#clone(user, root)
see_old() {
	sudo lsof +c 0 | grep 'DEL.*lib' | awk '1 { print $1 ": " $NF }' | sort -u
}

#clone(user)
serv() {
	set -- "${1:-.}" "${2:-4000}"

	if ! [ -d "$1" ]; then
		_shell_util_die "serv: dir '$1' doesn't exist"
		return
	fi

	# Don't use Python's built in http.server due to weird caching issues.
	if command -v dufs >/dev/null 2>&1; then
		dufs --port "$2" "$1"
	elif command -v file_server >/dev/null 2>&1; then
		file_server "$1" --host 127.0.0.1 -p "$2" # deno
	elif command -v http-server >/dev/null 2>&1; then
		http-server "$1" -c-1 -a 127.0.0.1 -p "$2" # node
		return
	else
		_shell_util_die "serv: no executable found to start server"
		return
	fi
}

vtraceroute() {
	xdg-open "https://stefansundin.github.io/traceroute-mapper/?trace=$('traceroute' -q1 "$*" | sed ':a;N;$!ba;s/\n/%0A/g')"
}

#clone(user)
wa() {
	watch -cn.3 "$@"
}

# watch fast
#clone(user)
waf() {
	watch -cn.1 "$@"
}

# watch slow
#clone(user)
was() {
	watch -cn1 "$@"
}
