# shellcheck shell=bash

# shellcheck disable=SC2016
{
	# Set options.
	set -e
	if [ -n "$BASH_VERSION" ]; then
		# shellcheck disable=SC3044
		shopt -s extglob globstar shift_verbose
	elif [ -n "$ZSH_VERSION" ]; then
		:
	elif [ -n "$KSH_VERSION" ]; then
		set -o globstar
	fi

	# Source libraries.
	source ~/.dotfiles/os/unix/scripts/xdg.sh
	for _f in \
		~/.dotfiles/os/unix/vendor/bash-core/pkg/**/*.sh \
		~/.dotfiles/os/unix/vendor/bash-term/pkg/**/*.sh; \
	do
		source "$_f"
	done; unset -v _f

	# Check for assumptions.
	if [ -z "$XDG_CONFIG_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_CONFIG_HOME is empty' >&2
		exit 1
	fi
	if [ -z "$XDG_DATA_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_DATA_HOME is empty' >&2
		exit 1
	fi
	if [ -z "$XDG_STATE_HOME" ]; then
		printf '%s\n' 'Failed because $XDG_STATE_HOME is empty' >&2
		exit 1
	fi

	err_handler() {
		core.print_stacktrace
	}
	core.trap_add 'err_handler' SIGINT

	CURL_CONFIG="$HOME/.dotfiles/os/unix/config/curl_config.conf"
}

helper.setup() {
	local flag_force_install=no
	local flag_no_confirm=no
	local flag_fn_prefix=install

	local arg=
	for arg; do
		case $arg in
			--force-install)
				flag_force_install=yes
				shift
				;;
			--no-confirm)
				flag_no_confirm=yes
				shift
				;;
			--fn-prefix)
				flag_fn_prefix=${arg#*=}
				shift
				;;
		esac
	done

	local program_name="$1"
	shift

	(
		# A list of 'os-release' files can be found at https://github.com/which-distro/os-release.
		# In some distros, like CachyOS, /usr/lib/os-release has the wrong contents.
		source /etc/os-release

		# Normalize values that are missing or have bad capitalization.
		[ "$ID" = +(arch|blackarch) ] && ID_LIKE=arch
		[ "$ID" = 'debian' ] && ID_LIKE=debian
		[ "$ID" = 'Deepin' ] && ID=deepin
		[[ "$ID_LIKE" == +(*debian*|*ubuntu*) ]] && ID_LIKE=debian
		[[ "$ID_LIKE" == +(*fedora*|*centos*|*rhel*) ]] && ID_LIKE=fedora
		[[ "$ID_LIKE" == +(*opensuse*|*suse*) ]] && ID_LIKE=opensuse

		local has_function=no
		local id=
		for id in "$ID" "$ID_LIKE" any; do
			if declare -f "$flag_fn_prefix.$id" &>/dev/null; then
				has_function=yes
				if ! declare -f installed &>/dev/null || ! installed || [ "$flag_force_install" = yes ]; then
					if util.confirm "Install $program_name?" || [ "$flag_no_confirm" = yes ]; then
						"$flag_fn_prefix.$id" "$@"
						break
					fi
				else
					core.print_warn "Application has already been setup. Pass --force-install to run setup again"
				fi
			fi
		done; unset -v id
		if [ "$has_function" = no ] && ! declare -f install.any &>/dev/null; then
			core.print_warn "Application has no installation function for this distribution"
		fi


		if declare -f 'configure.any' &>/dev/null; then
			core.print_info "Configuring..."
			configure.any "$@"
		fi
	)
}

pkg.add_apt_key() {
	local source_url=$1
	local dest_file="$2"

	if [ ! -f "$dest_file" ] || [ ! -s "$dest_file" ]; then
		core.print_info "Downloading and writing key to $dest_file"
		sudo mkdir -p "${dest_file%/*}"
		curl -K "$CURL_CONFIG" "$source_url" \
			| sudo tee "$dest_file" >/dev/null
	fi
}

pkg.add_apt_repository() {
	local source_line="$1"
	local dest_file="$2"

	sudo mkdir -p "${dest_file%/*}"
	sudo rm -f "${dest_file%.*}.list"
	sudo rm -f "${dest_file%.*}.sources"
	printf '%s\n' "$source_line" | sudo tee "$dest_file" >/dev/null
}

util.clone() {
	local dir="$1"
	local repo="$2"
	shift 2

	if [ ! -d "$dir" ]; then
		core.print_info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir" "$@"

		local git_remote=
		git_remote=$(git -C "$dir" remote)
		if [ "$git_remote" = 'origin' ]; then
			git -C "$dir" remote rename origin me
		fi
		unset -v git_remote
	fi
}

util.confirm() {
	local message=${1:-Confirm?}

	local input=
	until [[ "$input" =~ ^[yn]$ ]]; do
		read -rN1 -p "$message "
		if [ -n "$BASH_VERSION" ]; then
			if (( ${BASH_VERSINFO[0]} >= 6 || ( ${BASH_VERSINFO[0]} == 5 && ${BASH_VERSINFO[1]} >= 1 ) )); then
				input=${REPLY@L}
			else
				# Ksh fails parse without eval.
				eval 'input=${REPLY,,}'
			fi
		elif [ -n "$ZSH_VERSION" ]; then
			input=${REPLY:l}
		elif [ -n "$KSH_VERSION" ]; then
			# shellcheck disable=SC2034
			typeset -M toupper input="$REPLY"
		else
			input=$(printf '%s\n' "$REPLY" | tr '[:upper:]' '[:lower:]')
		fi
	done
	printf '\n'

	if [ "$input" = 'y' ]; then
		return 0
	else
		return 1
	fi
}

util.get_latest_github_tag() {
	unset -v REPLY; REPLY=
	local repo="$1"

	if [ ! -f ~/.dotfiles/.data/github_token ]; then
		core.print_die "Error: File not found: ~/.dotfiles/.data/github_token"
	fi

	core.print_info "Getting latest version of: $repo"

	local token=
	token="$(<~/.dotfiles/.data/github_token)"
	local url="https://api.github.com/repos/$repo/releases/latest"
	local tag_name=
	tag_name=$(curl -K "$CURL_CONFIG" -H "Authorization: token: $token" "$url" | jq -r '.tag_name')

	REPLY=$tag_name
}

