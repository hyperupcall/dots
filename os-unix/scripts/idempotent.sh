#!/usr/bin/env bash
#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	~/.dotfiles/bake -f ~/.dotfiles/Bakefile.sh init

	local part_uuid="c875b5ca-08a6-415e-bc11-fc37ec94ab8f"
	local mnt='/storage/short'
	if ! grep -q "$mnt" /etc/fstab; then
		if [ ! -f ~/.dotfiles/.data/option_no_ask_edit_fstab ]; then
			if util.confirm "Would you like to edit /etc/fstab to add ${mnt}?"; then
				printf '%s\n' "PARTUUID=$part_uuid  $mnt  btrfs  defaults,nofail,noatime,X-mount.mkdir  0 0" \
					| sudo tee -a /etc/fstab >/dev/null
				sudo mount "$mnt"
			else
				mkdir -p ~/.dotfiles/.data/state
				touch ~/.dotfiles/.data/option_no_ask_edit_fstab
			fi
		fi
	fi

	util.add_user_to_group "$USER" 'docker'
	util.add_user_to_group "$USER" 'vboxusers'
	util.add_user_to_group "$USER" 'libvirt'
	util.add_user_to_group "$USER" 'kvm'
	util.add_user_to_group "$USER" 'input'

	{
		cat > "${XDG_DATA_HOME:-$HOME/.local/share}/systemd/user/dev.service" <<-'EOF'
[Unit]
Description=Dev
ConditionPathIsDirectory=%h/.dev

[Service]
Type=simple
WorkingDirectory=%h/.dev
ExecStart=%h/.dotfiles/.data/node %h/.dev/bin/dev.js start-dev-server
Environment=PORT=40008
Restart=on-failure

[Install]
WantedBy=default.target
EOF
		systemctl --user daemon-reload
		systemctl --user enable --now dev.service
	}

	~/.dotfiles/os-unix/scripts/lib/util-create-dirs.sh
	~/.dotfiles/os-unix/scripts/lib/util-generate-aliases.sh
	~/.dotfiles/os-unix/scripts/lib/util-generate-dotgen.sh
}

main "$@"
