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
}

# -------------------------------------------------------- #
#                     HELPER FUNCTIONS                     #
# -------------------------------------------------------- #
helper.setup() {
	local flag_force_install=no

	local arg=
	for arg; do
		case $arg in
			--force-install) flag_force_install=yes ;;
		esac
	done

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
			if declare -f "install.$id" &>/dev/null; then
				has_function=yes
				if ! declare -f installed &>/dev/null || ! installed || [ "$flag_force_install" = yes ]; then
					if util.confirm "Install $id?"; then
						"install.$id" "$@"
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

	if [ ! -f "$dest_file" ]; then
		core.print_info "Downloading and writing key to $dest_file"
		sudo mkdir -p "${dest_file%/*}"
		util.req "$source_url" \
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

util.requires_bin() {
	if ! command -v "$1" &>/dev/null; then
		core.print_die "Command '$1' does not exist"
	fi
}

# TODO: remove this
util.req() {
	curl --proto '=https' --tlsv1.2 -#Lf "$@"
}

# TODO: remove
util.get_package_manager() {
	for package_manager in pacman apt-get dnf zypper; do
		if command -v "$package_manager" &>/dev/null; then
			REPLY="$package_manager"

			return
		fi
	done

	core.print_die 'Failed to get the system package manager'
}

util.clone() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir" ]; then
		core.print_info "Cloning '$repo' to $dir"
		git clone "$repo" "$dir"

		git_remote=$(git -C "$dir" remote)
		if [ "$git_remote" = 'origin' ]; then
			git -C "$dir" remote rename origin me
		fi
		unset -v git_remote
	fi
}

util.clone_in_dotfiles() {
	unset -v REPLY; REPLY=
	local repo="$1"

	local dir="$HOME/.dotfiles/.data/repos/${repo##*/}"
	util.clone "$repo" "$dir" "${@:2}"

	REPLY=$dir
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

util.install_packages() {
	if command -v 'pacman' &>/dev/null; then
		sudo pacman -S --noconfirm "$@"
	elif command -v 'apt-get' &>/dev/null; then
		sudo apt-get -y install "$@"
	elif command -v 'dnf' &>/dev/null; then
		sudo dnf -y install "$@"
	elif command -v 'zypper' &>/dev/null; then
		sudo zypper -y install "$@"
	elif command -v 'eopkg' &>/dev/null; then
		sudo eopkg -y install "$@"
	elif iscmd 'brew'; then
		brew install "$@"
	else
		core.print_die 'Failed to determine package manager'
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
	tag_name=$(curl -fsSLo- -H "Authorization: token: $token" "$url" | jq -r '.tag_name')

	REPLY=$tag_name
}

