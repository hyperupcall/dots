#!/usr/bin/env bash

# Deal with:
# - Mounting file systems (if applicable)
# - Removing pre-existing dotfiles
# - Creating necessary directories and files
# - Creating necessary symlinks
# - Removing extraneous directories and files
# - Removing broken symlinks
# - Removing autoappended content to `~/.{profile,bashrc}`, etc.

source "${0%/*}/../source.sh"

main() {
	local profile="$(<~/.dotfiles/.data/profile)"

	# -------------------------------------------------------- #
	#     REMOVE AUTOAPPENDED LINES IN SHELL STARTUP FILES     #
	# -------------------------------------------------------- #
	for file in ~/.profile ~/.bashrc ~/.bash_profile "${ZDOTDIR:-$HOME}/.zshrc" "${ZDOTDIR:-$HOME}/.zshenv" "$XDG_CONFIG_HOME/fish/config.fish"; do
		if [ ! -f "$file" ]; then
			continue
		fi

		local file_string=
		while IFS= read -r line; do
			file_string+="$line"$'\n'

			if [[ "$line" == '# ---' ]]; then
				break
			fi
		done < "$file"; unset -v line

		printf '%s' "$file_string" > "$file"
	done; unset -v file
	core.print_info 'Cleaned shell dotfiles'

	# -------------------------------------------------------- #
	#                  REMOVE BROKEN SYMLINKS                  #
	# -------------------------------------------------------- #
	for f in "$HOME"/*; do
		if [ -L "$f" ] && [ ! -e "$f" ]; then
			unlink "$f"
		fi
	done

	# -------------------------------------------------------- #
	#               CREATE DIRECTORIES AND FILES               #
	# -------------------------------------------------------- #
	must.dir "$HOME/.dotfiles/.home"
	must.dir "$HOME/.dotfiles/.data"
	must.dir "$HOME/.dotfiles/.data/workspace"
	must.dir "$HOME/.gnupg"
	must.dir "$HOME/.ssh"
	must.dir "$XDG_STATE_HOME/Android/Sdk"
	must.dir "$XDG_STATE_HOME/history"
	must.dir "$XDG_STATE_HOME/nano/backups"
	must.dir "$XDG_DATA_HOME/maven"
	must.dir "$XDG_DATA_HOME"/nano/backups
	must.dir "$XDG_DATA_HOME/zsh"
	must.dir "$XDG_DATA_HOME/X11"
	must.dir "$XDG_DATA_HOME/xsel"
	must.dir "$XDG_DATA_HOME/tig"
	must.dir "$XDG_CONFIG_HOME/sage" # $DOT_SAGE
	must.dir "$XDG_CONFIG_HOME/less" # $LESSKEY
	must.dir "$XDG_CONFIG_HOME/Code - OSS/User"
	must.dir "$XDG_DATA_HOME/gq/gq-state" # $GQ_STATE
	must.dir "$XDG_DATA_HOME/sonarlint" # $SONARLINT_USER_HOME
	must.file "$XDG_CONFIG_HOME/yarn/config"
	must.file "$XDG_STATE_HOME/tig/history"
	must.file "$XDG_STATE_HOME/history/zsh_history" # ZSH's $HISTFILE
	for dir in ~/.ssh/ ~/.gnupg/; do
		if [ -d "$dir" ]; then
			find "$dir" -type d -exec chmod 700 {} \;
			find "$dir" -type f -exec chmod 600 {} \;
		fi
	done


	# -------------------------------------------------------- #
	#               REMOVE AUTOGENERATED DOTFILES              #
	# -------------------------------------------------------- #
	must.rm .bash_history
	must.rm .dir_colors
	must.rm .dircolors
	must.rm .flutter
	must.rm .flutter_tool_state
	must.rm .gitconfig
	must.rm .gmrun_history
	must.rm .inputrc
	must.rm .lesshst
	must.rm .mkshrc
	must.rm .pulse-cookie
	must.rm .pythonhist
	must.rm .sh_history
	must.rm .sqlite_history
	must.rm .sudo_as_admin_successful
	must.rm .viminfo
	must.rm .wget-hsts
	must.rm .xsession-errors
	must.rm .zlogin
	must.rm .zshenv
	must.rm .zshrc
	must.rm .zprofile
	must.rm .zcompdump


	# -------------------------------------------------------- #
	#                 CREATE HOME DIR SYMLINKS                 #
	# -------------------------------------------------------- #
	if [ "$profile" = 'desktop' ]; then
		must.link "$HOME/.dotfiles/os/unix/scripts" "$HOME/scripts"
		must.link "$HOME/.dotfiles/.home/Documents/Projects/Programming/Organizations/fox-forks" "$HOME/forks"
		must.link "$HOME/.dotfiles/.home/Documents/Projects/Programming/Git" "$HOME/git"
		must.link "$HOME/.dotfiles/.home/Documents/Projects/Programming/Organizations" "$HOME/repositories"
		must.link "$HOME/.dotfiles/.home/Documents/Projects/Programming/Organizations" "$HOME/organizations"
	elif [ "$profile" = 'laptop' ]; then
		:
	fi

	# -------------------------------------------------------- #
	#                      CREATE SYMLINKS                     #
	# -------------------------------------------------------- #
	{
		# Use 'cp -f' for "$XDG_CONFIG_HOME/user-dirs.dirs"; otherwise unlink/link operation races.
		if [ "$profile" = 'desktop' ]; then
			local filename='user-dirs-custom.conf'
		else
			local filename='user-dirs-other.conf'
		fi
		cp -f "$HOME/.dotfiles/os/unix/user/.config/user-dirs.dirs/$filename" "$XDG_CONFIG_HOME/user-dirs.dirs"
		unset -v filename
	}

	# Create XDG user directories.
	source "$XDG_CONFIG_HOME/user-dirs.dirs"
	for dir in "$XDG_DESKTOP_DIR" "$XDG_DOWNLOAD_DIR" "$XDG_TEMPLATES_DIR" "$XDG_PUBLICSHARE_DIR" "$XDG_DOCUMENTS_DIR" "$XDG_MUSIC_DIR" "$XDG_PICTURES_DIR" "$XDG_VIDEOS_DIR"; do
			must.dir "$dir"
	done; unset -v dir

	# Populate ~/.dotfiles/.home/.
	(
		source "$XDG_CONFIG_HOME/user-dirs.dirs"
		must.link "$XDG_DESKTOP_DIR" "$HOME/.dotfiles/.home/Desktop"
		must.link "$XDG_DOWNLOAD_DIR" "$HOME/.dotfiles/.home/Downloads"
		must.link "$XDG_TEMPLATES_DIR" "$HOME/.dotfiles/.home/Templates"
		must.link "$XDG_PUBLICSHARE_DIR" "$HOME/.dotfiles/.home/Public"
		must.link "$XDG_DOCUMENTS_DIR" "$HOME/.dotfiles/.home/Documents"
		must.link "$XDG_MUSIC_DIR" "$HOME/.dotfiles/.home/Music"
		must.link "$XDG_PICTURES_DIR" "$HOME/.dotfiles/.home/Pictures"
		must.link "$XDG_VIDEOS_DIR" "$HOME/.dotfiles/.home/Videos"

		must.link "$XDG_CACHE_HOME" "$HOME/.dotfiles/.home/xdg_cache_dir"
		must.link "$XDG_CONFIG_HOME" "$HOME/.dotfiles/.home/xdg_config_dir"
		must.link "$XDG_STATE_HOME" "$HOME/.dotfiles/.home/xdg_state_dir"
		must.link "$XDG_DATA_HOME" "$HOME/.dotfiles/.home/xdg_data_dir"

		for f in "$HOME/.dotfiles/.home"/*; do
			if [ -L "$f" ] && [ ! -e "$f" ]; then
				unlink "$f"
			fi
		done; unset -v f
	)

	if [ "$profile" = 'desktop' ]; then
		local -r storage_home='/storage/ur/storage_home'
		local -r storage_other='/storage/ur/storage_other'
		must.link "$storage_home/Desktop" "$HOME/Desktop"
		must.link "$storage_home/Dls" "$HOME/Dls"
		must.link "$storage_home/Other/Templates" "$HOME/Other/Templates"
		must.link "$storage_home/Other/Public" "$HOME/Other/Public"
		must.link "$storage_home/Docs" "$HOME/Documents"
		must.link "$storage_home/Music" "$HOME/Music"
		must.link "$storage_home/Pics" "$HOME/Pics"
		must.link "$storage_home/Vids" "$HOME/Vids"

		must.link "$storage_other/mozilla" "$HOME/.mozilla"
		if [ ! -L "$HOME/.ssh" ]; then rm -f "$HOME/.ssh/known_hosts"; fi
		must.link "$storage_other/ssh" "$HOME/.ssh"
		must.link "$storage_other/BraveSoftware" "$XDG_CONFIG_HOME/BraveSoftware"
		must.link "$storage_other/fonts" "$XDG_CONFIG_HOME/fonts"
		must.link "$storage_other/history" "$XDG_CONFIG_HOME/history"
		must.link "$storage_other/Mailspring" "$XDG_CONFIG_HOME/Mailspring"
	fi

	# Must be last as they are dependent on previous symlinking
	must.dir "$HOME/.dotfiles/.home/Documents/Applications/IntegratedAppImages"
}

must.rm() {
	util.get_path "$1"
	local file="$REPLY"

	if [ -f "$file" ]; then
		local output=
		if output=$(rm -f -- "$file" 2>&1); then
			core.print_info "Removed file '$file'"
		else
			core.print_warn "Failed to remove file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.rmdir() {
	util.get_path "$1"
	local dir="$REPLY"

	if [ -d "$dir" ]; then
		local output=
		if output=$(rmdir -- "$dir" 2>&1); then
			core.print_info "Removed directory '$dir'"
		else
			core.print_warn "Failed to remove directory '$dir'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.dir() {
	local d=
	for d; do
		util.get_path "$d"
		local dir="$REPLY"

		if [ ! -d "$dir" ]; then
			local output=
			if output=$(mkdir -p -- "$dir" 2>&1); then
				core.print_info "Created directory '$dir'"
			else
				core.print_warn "Failed to create directory '$dir'"
				printf '  -> %s\n' "$output"
			fi
		fi
	done; unset -v d
}

must.file() {
	util.get_path "$1"
	local file="$REPLY"

	if [ ! -f "$file" ]; then
		local output=
		if output=$(mkdir -p -- "${file%/*}" && touch -- "$file" 2>&1); then
			core.print_info "Created file '$file'"
		else
			core.print_warn "Failed to create file '$file'"
			printf '  -> %s\n' "$output"
		fi
	fi
}

must.link() {
	util.get_path "$1"
	local src="$REPLY"

	util.get_path "$2"
	local target="$REPLY"

	if [ -z "$1" ]; then
		core.print_warn "must.link: First parameter is emptys"
		return
	fi

	if [ -z "$2" ]; then
		core.print_warn "must.link: Second parameter is empty"
		return
	fi

	# Skip if already is correct
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		return
	fi

	if [ ! -e "$src" ]; then
		core.print_warn "Skipping symlink from '$src' to $target (source directory not found)"
		return
	fi

	# If it is an empty directory (and not a symlink) automatically remove it
	core.shopt_push -s nullglob
	if [ -d "$target" ] && [ ! -L "$target" ]; then
		local children=
		children=("$target"/*)
		if (( ${#children[@]} == 0)); then
			rmdir "$target"
		else
			core.print_warn "Skipping symlink from '$src' to '$target' (target a non-empty directory)"
			return
		fi
	fi
	core.shopt_pop

	local output=
	if output=$(ln -sfT "$src" "$target" 2>&1); then
		core.print_info "Symlinking '$src' to $target"
	else
		core.print_warn "Failed to symlink from '$src' to '$target'"
		printf '  -> %s\n' "$output"
	fi
}

util.get_path() {
	if [[ ${1::1} == / ]]; then
		REPLY="$1"
	else
		REPLY="$HOME/$1"
	fi
}

main "$@"
