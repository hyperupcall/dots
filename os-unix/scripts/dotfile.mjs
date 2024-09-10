#!/usr/bin/env node
import { promises as fs, existsSync } from 'node:fs'
import path from 'node:path'
import os from 'node:os'
import { parseArgs } from 'node:util'

const Home = (/** @type {string} */ filepath) => ({
	source: filepath,
	destination: filepath,
})
const Config = (/** @type {string} */ filepath) => ({
	source: `.config/${filepath}`,
	destination: `.config/${filepath}`
})
const Data = (/** @type {string} */ filepath) => ({
	source: `.local/share/${filepath}`,
	destination: `.local/share/${filepath}`
})

const Configuration = {
	'config-application': [
		Config('albert/albert.conf'),
		Config('broot/'),
		Config('calcurse/'),
		Config('cmus/rc'),
		// Config('espanso'), // TODO
		Config('htop/'),
		Config('irssi/'),
		Config('lazydocker/'),
		Config('mnemosyne/config.py'),
		Config('mpv/'),
		Config('nb/'),
		Config('ncmpcpp/'),
		Config('octave/'),
		Config('OpenSCAD/'),
		Config('ranger/'),
		Config('slack-term/'),
		Config('taskwarrior/'),
		Config('viewnior/'),
		Config('vimiv/'),
		Config('wtf/'),
		Config('xplr/'),
		Config('zathura/'),
		Config('appimagelauncher.cfg'),
		Config('llpp.conf'),
		Data('albert/python/plugins/'),
		Data('applications/FoxBlender.desktop'),
		Home('.gnuplot'),
	],
	'config-cli': [
		Config('aria2/'),
		Config('bat/'),
		Config('ccache/'),
		Config('cookiecutter/'),
		Config('fox-default/'),
		Config('neofetch/'),
		Config('pgcli/'),
		Config('ripgrep/'),
		Config('rtorrent/'),
		Config('wget/'),
		Config('youtube-dl/'),
		Home('.agignore'),
		Home('.psqlrc'),
	],
	'config-dotfile-manager': [
		Config('chezmoi/'),
		Config('dotdrop/'),
		Config('dotgen/'),
		Home('.rcrc'),
	],
	'config-editor': [
		Config('Code/User/keybindings.json'),
		Config('Code/User/settings.json'),
		{
			source: '.config/Code/User/settings.json',
			destination: '.config/Code - OSS/User/settings.json'
		},
		Config('helix/'),
		Config('kak/'),
		Config('micro/bindings.json'),
		Config('micro/settings.json'),
		Config('nano/'),
		Config('nvim/'),
		Config('ox/'),
		Config('sublime-text-3/Packages/User/Preferences.sublime-settings'),
		Config('sublime-text-3/Packages/User/Package Control.sublime-settings'),
		Config('vim/'),
		Home('.exrc'),
	],
	'config-email': [
		Config('aerc/aerc.conf'),
		Config('aerc/binds.conf'),
		Config('neomutt/'),
		Config('notmuch/'),
	],
	'config-lang': [
		Config('bpython/'),
		Config('cabal/config'),
		Config('cargo/'),
		Config('conda/'),
		Config('gdb/'),
		Config('irb/'),
		Config('maven/'),
		Config('nimble/'),
		Config('npm/'),
		Config('please/'),
		Config('pudb/'),
		Config('pylint/'),
		Config('pypoetry/'),
		Config('python/'),
		Config('yapf/'),
		Home('.cpan/CPAN/MyConfig.pm'),
		Data('sdkman/etc/config')
	],
	'config-linux-core': [
		Config('curl/'),
		Config('dircolors/'),
		Config('environment.d/'),
		Config('fontconfig/'),
		Config('info/'),
		Config('less/'),
		Config('most/'),
		Config('readline/'),
		// Config('systemd/'),
		// Config('user-dirs.dirs/'), Handled by '~/scripts/idempotent.sh'.
		Config('user-dirs.conf'),
		Home('.gnupg/dirmngr.conf'),
		Home('.gnupg/gpg.conf'),
		Home('.gnupg/gpg-agent.conf'),
		{
			source: true ? '.pam_environment/xdg-default.conf' : '.pam_environment/xdg-custom.conf',
			destination: '.pam_environment',
		},
		Home('.digrc'),
		Home('.hushlogin'),
	],
	'config-linux-extra': [
		Config('ltrace/'),
		Config('pacman/'),
		Config('paru/'),
		Config('toast/'),
		Config('udiskie/'),
		Config('yay/'),
		Home('.aspell.conf'),
	],
	'config-linux-rice': [
		Config('awesome/'),
		Config('bspwm/'),
		Config('cava/'),
		Config('cdm/'),
		Config('conky/'),
		Config('dunst/'),
		Config('dxhd/'),
		Config('eww/'),
		Config('i3/'),
		Config('i3blocks/'),
		Config('i3status/'),
		Config('i3status-rust/'),
		Config('ly/'),
		Config('mako/config'),
		Config('mpd/'),
		Config('nitrogen/'),
		Config('openbox/'),
		Config('pacmixer/'),
		Config('picom/'),
		Config('polybar/'),
		Config('rofi/'),
		Config('swaylock/'),
		Config('sx/'),
		Config('sxhkdrc/'),
		Config('taffybar/'),
		Config('twmn/'),
		Config('wofi/'),
		Config('X11/'),
		Config('xbindkeys/'),
		Config('xkb/'),
		Config('xmobar/'),
		Config('xob/'),
		Config('emptty'),
		Config('ncpamixer.conf'),
		Config('pamix.conf'),
		Config('pavucontrol.ini'),
		Config('pulsemixer.cfg'),
	],
	'config-shell': [
		Config('bash/'),
		Config('fish/'),
		Config('ion/'),
		Config('liquidprompt/'),
		Config('nu/'),
		Config('powerline/'),
		Config('shell/'),
		Config('starship/'),
		Config('zsh/'),
		Home('.bash_logout'),
		Home('.bash_profile'),
		Home('.bashrc'),
		Home('.cshrc'),
		Home('.kshrc'),
		Home('.login'),
		Home('.mkshrc'),
		Home('.profile'),
		Home('.tcshrc'),
		Home('.zshenv'),
	],
	'config-terminal': [
		Config('alacritty/'),
		Config('kermit/'),
		Config('kitty/'),
		Config('screen/'),
		Config('terminator/'),
		Config('termite/'),
		Config('tmux/'),
		// Config('urxvt'),
		Config('.gtktermrc'),
		Home('.hyper.js'),
	],
	'config-tool': [
		Config('cspell/'),
		Config('libfsguest/'),
		Config('nvchecker/'),
		Config('osc/'),
		Config('redshift/'),
		Config('sheldon/'),
		Config('urlwatch/'),
	],
	'config-unused': [

	],
	'config-version-control': [
		Config('gh/config.yml'),
		Config('git/'),
		Config('hg/'),
		Config('pijul/'),
		Config('tig/'),
	]
}

{
	const { values, positionals } = parseArgs({
		allowPositionals: true,
		options: {
			help: {
				type: 'boolean'
			}
		}
	})

	const helpMenu = `dotfile.js <deploy|undeploy>\n`
	if (values['help']) {
		process.stdout.write(helpMenu)
		process.exit(0)
	}

	if (!positionals[0]) {
		process.stdout.write(helpMenu)
		process.exit(1)
	}

	if (positionals[0] !== 'deploy' && positionals[0] !== 'undeploy') {
		console.error(`Unexpected subcommand: \"${positionals[0]}\"`)
		process.exit(1)
	}

	for (const [configurationCategory, dotfiles] of Object.entries(Configuration)) {
		const categoryDir = path.join(os.homedir(), '.dotfiles/os-unix', configurationCategory)

		// TODO: make sure each file in os-unix is accounted for by some filepath pattern in 'Configuration' variable

		if (!existsSync(categoryDir)) {
			throw new Error(`Directory does not exist: ${categoryDir}`)
		}

		if (configurationCategory === 'config-unused' || configurationCategory === 'config-linux-rice' || configurationCategory === 'config-dotfile-manager') {
			continue
		}

		for (const dotfile of dotfiles) {
			const sourcePath = path.join(categoryDir, dotfile.source)
			const targetPath = path.join(os.homedir(), dotfile.destination.endsWith('/') ? dotfile.destination.slice(0, -1) : dotfile.destination) // TODO
			const [sourcePathStat, targetPathStat] = await Promise.all([
				await fs.lstat(sourcePath).catch((err) => {
					if (err.code !== 'ENOENT') throw err

					console.error(`Expected to find file or directory at \"${sourcePath}\"`)
					process.exit(1)
				}),
				await fs.lstat(targetPath).catch((err) => {
					if (err.code !== 'ENOENT') throw err
				}),
			])

			if (sourcePathStat.isSymbolicLink()) {
				console.error(`Expected to not find a symbolic link at \"${sourcePathStat}\"`)
				process.exit(1)
			} else if (sourcePath.endsWith('/') && !sourcePathStat.isDirectory()) {
				console.error(`Expected to find directory at \"${sourcePath}\"`)
				process.exit(1)
			} else if (!sourcePath.endsWith('/') && !sourcePathStat.isFile()) {
				console.error(`Expected to find file at \"${sourcePath}\"`)
				process.exit(1)
			}

			if (targetPath.endsWith('/')) {
				console.error(`Path should not end with slash: \"${targetPath}\"`)
				process.exit(1)
			} else if (targetPathStat && !targetPathStat.isSymbolicLink()) {
				console.error(`Expected to find no file or only a symolic link at \"${targetPath}\"`)
				process.exit(1)
			}

			if (positionals[0] === 'deploy') {
				console.info(`Symlinking \"${targetPath}\" to \"${sourcePath}\"`) // TODO: Only print if changed it
				if (targetPathStat?.isSymbolicLink()) {
					await fs.rm(targetPath)
				}
				await fs.mkdir(path.dirname(targetPath), { recursive: true })
				await fs.symlink(sourcePath, targetPath) // NOT ABSOLUTE?
			} else if (positionals[0] === 'undeploy') {
				if (targetPathStat?.isSymbolicLink()) {
					console.info(`Removing symlink at \"${targetPath}\"`)
					await fs.rm(targetPath)
				}
			}

		}
	}
}

