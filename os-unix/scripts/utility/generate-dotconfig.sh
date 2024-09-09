#!/usr/bin/env bash
set -eo pipefail

source "${0%/*}/../source.sh"

declare -gr g_dotfiles_dir="$HOME/.dotfiles"

declare -grA g_dotfiles_src=(
	[home]="$g_dotfiles_dir"
	[cfg]="$g_dotfiles_dir/.config"
	[state]="$g_dotfiles_dir/.local/state"
	[data]="$g_dotfiles_dir/.local/share"
)

declare -grA g_dotfiles_dst=(
	[home]="$HOME"
	[cfg]="$XDG_CONFIG_HOME"
	[state]="$XDG_STATE_HOME"
	[data]="$XDG_DATA_HOME"
)

declare -ga g_dotfiles=(
	home:'.agignore'
	home:'.alsoftrc'
	home:'.aspell.conf'
	home:'.cpan/CPAN/MyConfig.pm'
	home:'.digrc'
	home:'.gnuplot'
	home:'.psqlrc'
	home:'.gnupg/dirmngr.conf'
	home:'.gnupg/gpg.conf'
	home:'.gnupg/gpg-agent.conf'
	home:'.hushlogin'
	xresources"|cfg:X11/Xresources|home:.Xresources"
	bash_profile"|cfg:bash/bash_profile.sh|home:.bash_profile"
	bash_logout"|cfg:bash/bash_logout.sh|home:.bash_logout"
	bashrc"|cfg:bash/bashrc.sh|home:.bashrc"
	profile"|cfg:shell/profile.sh|home:.profile"
	zshenv"|cfg:zsh/.zshenv|home:.zshenv"
	cfg:'.gtktermrc'
	cfg:'rofi-json-menu.json'
	cfg:'aerc/aerc.conf'
	cfg:'aerc/binds.conf'
	cfg:'alacritty'
	cfg:'albert/albert.conf'
	cfg:'alsa'
	cfg:'appimagelauncher.cfg'
	cfg:'aria2'
	cfg:'awesome'
	cfg:'bash'
	cfg:'bat'
	cfg:'bpython'
	cfg:'broot'
	cfg:'bspwm'
	cfg:'cabal/config'
	cfg:'cactus'
	cfg:'calcurse'
	cfg:'cargo'
	cfg:'cava'
	cfg:'ccache'
	cfg:'cdm'
	cfg:'cliflix'
	cfg:'conda'
	cfg:'conky'
	cfg:'cookiecutter'
	cfg:'cmus/rc'
	cfg:'Code/User/keybindings.json'
	cfg:'Code/User/settings.json'
	vscode-settings"|cfg:Code/User/settings.json|cfg:Code - OSS/User/settings.json"
	cfg:'curl'
	cfg:'ddcutil'
	cfg:'dircolors'
	cfg:'discocss'
	cfg:'dunst'
	cfg:'dxhd'
	cfg:'emptty'
	cfg:'environment.d'
	cfg:'eww'
	cfg:'fish'
	cfg:'fontconfig'
	cfg:'fox-default'
	cfg:'gh/config.yml'
	cfg:'gdb'
	cfg:'git'
	cfg:'glue'
	cfg:'octave'
	cfg:'osc'
	cfg:'helix'
	cfg:'hg'
	cfg:'htop'
	cfg:'i3'
	cfg:'i3blocks'
	cfg:'i3status'
	cfg:'info'
	cfg:'ion'
	cfg:'irb'
	cfg:'irssi'
	cfg:'kak'
	cfg:'quasipanacea'
	cfg:'kermit'
	cfg:'kitty'
	cfg:'lazydocker'
	cfg:'less'
	cfg:'libfsguest'
	cfg:'liquidprompt'
	cfg:'llpp.conf'
	cfg:'ltrace'
	cfg:'ly'
	cfg:'maven'
	cfg:'micro/bindings.json'
	cfg:'micro/settings.json'
	cfg:'mnemosyne/config.py'
	cfg:'most'
	cfg:'mpd'
	cfg:'mpv'
	cfg:'namur'
	cfg:'nano'
	cfg:'nb'
	cfg:'ncmpcpp'
	cfg:'ncpamixer.conf'
	cfg:'neofetch'
	cfg:'neomutt'
	cfg:'nimble'
	cfg:'nitrogen'
	cfg:'notmuch'
	cfg:'npm'
	cfg:'nu'
	cfg:'nvchecker'
	cfg:'nvim'
	cfg:'openbox'
	cfg:'OpenSCAD'
	cfg:'ox'
	cfg:'pacman'
	cfg:'pacmixer'
	cfg:'pamix.conf'
	cfg:'paru'
	cfg:'pavucontrol.ini'
	cfg:'pgcli'
	cfg:'picom'
	cfg:'pijul'
	cfg:'please'
	cfg:'polybar'
	cfg:'powerline'
	cfg:'pudb'
	cfg:'pulse/client.conf'
	cfg:'pulsemixer.cfg'
	cfg:'pylint'
	cfg:'pypoetry'
	cfg:'python'
	cfg:'quark'
	cfg:'ranger'
	cfg:'readline'
	cfg:'redshift'
	cfg:'repoctl'
	cfg:'ripgrep'
	cfg:'rofi'
	cfg:'rtorrent'
	cfg:'salamis'
	cfg:'sheldon'
	cfg:'shell'
	cfg:'slack-term'
	cfg:'starship'
	cfg:'sticker-selector'
	cfg:'sublime-text-3/Packages/User/Preferences.sublime-settings'
	cfg:'sublime-text-3/Packages/User/Package Control.sublime-settings'
	cfg:'sx'
	cfg:'sxhkd'
	cfg:'swaylock'
	cfg:'taffybar'
	cfg:'taskwarrior'
	cfg:'terminator'
	cfg:'termite'
	cfg:'tig'
	cfg:'tmux'
	cfg:'toast'
	cfg:'twmn'
	cfg:'udiskie'
	cfg:'urlwatch'
	cfg:'urxvt'
	# cfg:'user-dirs.dirs' # Handled by '~/scripts/idempotent.sh'.
	cfg:'viewnior'
	cfg:'vim'
	cfg:'wget'
	cfg:'wtf'
	cfg:'xbindkeys'
	cfg:'X11'
	cfg:'xkb'
	cfg:'xmobar'
	cfg:'xob'
	cfg:'xplr'
	cfg:'yapf'
	cfg:'yay'
	cfg:'youtube-dl'
	cfg:'zathura'
	cfg:'zsh'
	data:'applications/FoxBlender.desktop'
	data:'sdkman/etc/config'
	data:'albert/python/plugins'
)
{
	# Print dotfiles programatically
	source "$g_dotfiles_dir/os/unix/scripts/xdg.sh" --set-type
	if [ "$REPLY" = default ]; then
		g_dotfiles+=("pam|home:.pam_environment/xdg-default.conf|home:.pam_environment")
	elif [ "$REPLY" = custom ]; then
		g_dotfiles+=("pam|home:.pam_environment/xdg-custom.conf|home:.pam_environment")
	fi
}


c.export_xdg_vars() {
	if [ -f "$g_dotfiles_dir/os/unix/scripts/xdg.sh" ]; then
		source "$g_dotfiles_dir/os/unix/scripts/xdg.sh" --export-vars
		if ! [[ -v 'XDG_CONFIG_HOME' ]]; then
			core.print_die "Error: XDG Variables cannot be empty. Exiting"
		fi
	else
		core.print_die "Error: $g_dotfiles_dir/os/unix/scripts/xdg.sh not found. Exiting"
	fi
}

c.dotfiles() {
	local line=
	for line in "${g_dotfiles[@]}"; do
		if [[ "$line" == *\|* ]]; then
			local name=${line%%|*}
			local src=${line#*|}; src=${src%|*}
			local dest=${line#*|}; dest=${dest#*|}
			local src_prefix=${src%%:*}
			local dest_prefix=${dest%%:*}
			local src_relfile=${src#*:}
			local dest_relfile=${dest#*:}

			printf '%s\n' "  '$name':
    src: '{{@@ ${src_prefix}_src @@}}/$src_relfile'
    dst: '{{@@ ${dest_prefix}_dst @@}}/$dest_relfile'" >> "$dotdrop_file"
			printf '%s\n' "  - '$name'" >> "$dotdrop_include_file"
		elif [[ "$line" == *:* ]]; then
			local prefix=${line%%:*}
			local relfile=${line#*:}

			if [ -z "${g_dotfiles_src[$prefix]}" ] || [ -z "${g_dotfiles_dst[$prefix]}" ]; then
				core.print_die "Error: Prefix '$prefix' not supported (for relfile '$relfile'). Exiting"
			fi

			local name="${g_dotfiles_dst[$prefix]}/$relfile"
			name=${name#~/}
			# name=${name//\//__}
			printf '%s\n' "  '$name':
    src: '{{@@ ${prefix}_src @@}}/$relfile'
    dst: '{{@@ ${prefix}_dst @@}}/$relfile'" >> "$dotdrop_file"
			printf '%s\n' "  - '$name'" >> "$dotdrop_include_file"
		else
			core.print_die "Error: Line does not match glob"
		fi
	done; unset -v line
}

main() {
	c.export_xdg_vars

	local dotdrop_file="$g_dotfiles_dir/os/unix/config/dotdrop/dotdrop.yaml"
	local dotdrop_include_file="$g_dotfiles_dir/os/unix/config/dotdrop/dotdrop-include.yaml"

	mkdir -p "${dotdrop_file%/*}"
	> "$dotdrop_include_file" :
	> "$dotdrop_file" :

	cat <<"EOF" > "$dotdrop_include_file"
---
dotfiles:
EOF
	cat <<"EOF" > "$dotdrop_file"
---
config:
  backup: true
  banner: false
  check_version: true
  create: true
  dotpath: '~/.dotfiles/os/unix/user'
  link_dotfile_default: 'relative'
  link_on_import: 'relative'
  template_dotfile_default: false
  workdir: '~/.dotfiles/.dotdrop-workdir'

profiles:
  nullptr:
    variables:
      email: 'edwin@kofler.dev'
      home_src: './'
      cfg_src: '.config'
      state_src: '.local/state'
      data_src: '.local/share'
    dynvariables:
      home_dst: 'printf "%s\n" "$HOME"'
      cfg_dst: 'printf "%s\n" "$XDG_CONFIG_HOME"'
      state_dst: 'printf "%s\n" "$XDG_STATE_HOME"'
      data_dst: 'printf "%s\n" "$XDG_DATA_HOME"'
    import:
      - './dotdrop-include.yaml'

dotfiles:
EOF

	c.dotfiles
}

main "$@"
