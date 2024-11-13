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
	source ~/.dotfiles/os-unix/data/xdg.sh
	for _f in \
		~/.dotfiles/os-unix/vendor/bash-core/pkg/**/*.sh \
		~/.dotfiles/os-unix/vendor/bash-term/pkg/**/*.sh; \
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

	CURL_CONFIG="$HOME/.dotfiles/os-unix/data/curl_config.conf"
}

helper.setup() {
	local flag_force_install=no
	local flag_no_confirm=no
	local flag_fn_prefix=install
	local program_name=

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
			--fn-prefix*)
				core.shopt_push -s nullglob on
				flag_fn_prefix=${arg#--fn-prefix}
				flag_fn_prefix=${flag_fn_prefix#=}
				core.shopt_pop
				if [ -z "$flag_fn_prefix" ]; then
					core.print_die "Expected a value for --fn-prefix"
				fi
				shift
				;;
			-*)
				core.print_die "Invalid flag \"$arg\""
				;;
			*)
				if [ -n "$program_name" ]; then
					core.print_die "Expected a single positional argument"
				fi
				program_name=$arg
				;;
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
		[[ "$ID_LIKE" == +(*debian*|*ubuntu*) ]] && ID_LIKE=ubuntu
		[[ "$ID_LIKE" == *debian* ]] && ID_LIKE=debian
		[[ "$ID_LIKE" == +(*fedora*|*centos*|*rhel*) ]] && ID_LIKE=fedora
		[[ "$ID_LIKE" == +(*opensuse*|*suse*) ]] && ID_LIKE=opensuse

		local ran_function=no
		local id=
		for id in "$ID" "$ID_LIKE" any; do
			if declare -f "$flag_fn_prefix.$id" &>/dev/null; then
				ran_function=yes
				if ! declare -f installed &>/dev/null || ! installed || [ "$flag_force_install" = yes ]; then
					if [ "$flag_no_confirm" = yes ] || util.confirm "Install $program_name?"; then
						"$flag_fn_prefix.$id" "$@"
						break
					fi
				else
					core.print_warn "Application has already been setup. Pass --force-install to run setup again"
				fi
			fi
		done; unset -v id
		if [ "$ran_function" = no ] && ! declare -f install.any &>/dev/null; then
			core.print_warn "Application has no installation function for this distribution for prefix \"$flag_fn_prefix\""
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
		git clone "$repo" "$dir" "$@" # lint-ignore:no-git-clone

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

	local tag_name=
	tag_name=$(curl -K "$CURL_CONFIG" -H "Authorization: token: $token" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')

	REPLY=$tag_name
}

util.add_user_to_group() {
	local user="$1"
	local group="$2"

	if id -nG "$user" | grep -qw "$group"; then
		return
	fi

	local output=
	if output=$(sudo groupadd "$group" 2>&1); then
		core.print_info "Creating group \"$group\""
	else
		local code=$?
		if ((code != 9)); then
			core.print_warn "Failed to create group \"$group\""
			printf '%s\n' "  -> $output"
		fi
	fi

	if sudo usermod -aG "$group" "$user"; then
		core.print_info "Added user \"$user\" to group \"$group\""
	else
		core.print_warn "Failed to add user \"$user\" to group \"$group\""
	fi
}

util.update_system() {
	update_system.debian() {
		sudo apt-get -y update
		sudo apt-get -y upgrade
	}
	update_system.neon() {
		sudo apt-get -y update
		if sudo pkcon -y update; then :; else
			# Exit code for "Nothing useful was done".
			if (($? != 5)); then
				core.print_die "Failed to run 'pkgcon'"
			fi
		fi
	}
	update_system.fedora() {
		sudo dnf -y update
	}
	update_system.opensuse() {
		sudo zypper -n update
	}
	update_system.arch() {
		sudo pacman -Syyu --noconfirm
	}

	helper.setup --no-confirm --fn-prefix=update_system
}

util.install_package() {
	local package="$1"

	install_package.debian() {
		sudo apt-get install -y "$package"
	}
	install_package.fedora() {
		sudo dnf install -y "$package"
	}
	install_package.opensuse() {
		sudo zypper -n install "$package"
	}
	install_package.arch() {
		sudo pacman -Syu --noconfirm "$package"
	}

	helper.setup --no-confirm --fn-prefix=install_package
}

util.remove_package() {
	local package="$1"

	remove_package.debian() {
		sudo apt-get remove -y "$package"
	}
	remove_package.fedora() {
		sudo dnf remove -y "$package"
	}
	remove_package.opensuse() {
		sudo zypper -n remove "$package"
	}
	remove_package.arch() {
		sudo pacman -R --noconfirm "$package"
	}

	helper.setup --no-confirm --fn-prefix=remove_package
}
