# Installation

## Prerequisites

A network connection is required. A basic network configuration for `systemd-networkd` is shown below:

```sh
>/etc/systemd/network/90-wired.network <<-EOF cat
	[Match]
	Name=en*

	[Network]
	Description=Wired Connection
	DHCP=yes
	DNS=1.1.1.1
EOF

systemctl daemon-reload
systemctl enable --now systemd-{network,resolve}d
```

## Bootstrap

Download and execute `bootstrap.sh` to begin the bootstrap process:

```sh
mkdir -p ~/.bootstrap
curl -#fsSLo ~/.bootstrap/bootstrap.sh 'https://raw.githubusercontent.com/hyperupcall/dotfiles/trunk/os-unix/bootstrap.sh'
chmod +x ~/.bootstrap/bootstrap.sh
~/.bootstrap/bootstrap.sh
```

The `bootstrap.sh` script performs the following steps:

- Installs Homebrew on macOS
- Installs cURL, Git and Neovim
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Symlinks scripts to `~/scripts`
- Creates a `~/.bootstrap/bootstrap-out.sh`; sourcing it does the following:
  - Sets `NAME`, `EMAIL`, `EDITOR`, and `VISUAL`
  - Appends `$HOME/.dotfiles/.data/bin` to `PATH`
  - Sources `~/.dotfiles/os-unix/data/xdg.sh`, if it exists

Now, execute:

```sh
. ~/.bootstrap/bootstrap-out.sh
~/scripts/bootstrap.sh
~/scripts/doctor.sh
~/scripts/idempotent.sh
~/scripts/dotfile.mjs deploy
```

## Next Steps

Some scripts should be executed. They include:

- Setup ZFS, BTRFS
  - Modify `/etc/fstab`
- Retrieve SSH, PGP keys
- `~/scripts/doctor.sh`
  - Setup Git (at least v2.37.0)
  - Setup neovim (at least v0.10.0)
  - Setup pass
  - Setup Browsers (Firefox, Brave)
    - Sync data (do manually)
  - Setup Maestral
  - Setup Mise
- Setup Albert
  - Enable plugins
- Setup Obsidian
- Setup default, my-tools, hub, etc.
- Setup Visual Studio Code
  - Enable plugins
- Setup Thunderbird
  - Enable plugins
- Configure keybindings
- Test spellchecker
- Add favorites to file explorer and dock
- Run doctor
