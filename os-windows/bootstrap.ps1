#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function main() {
	New-Item -ItemType Directory -Force "$HOME/.bootstrap" >$null

	# Install essential commands
	updatesystem
	if (iscmd scoop) {
		log 'Already installed Scoop'
	}
	else {
		log 'Installing Scoop'

		Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
		Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
	}
	installcmd 'sudo'
	installcmd 'git'
	installcmd 'neovim'

	# Install hyperupcall/dotfiles
	clonerepo 'https://github.com/hyperupcall/dotfiles' "$HOME/.dotfiles"
	Push-Location ~/.dotfiles
	git remote set-url me 'git@github.com:hyperupcall/dotfiles'
	Pop-Location

	# Symlink scripts
	New-Item -Type SymbolicLink -Force -Path ~/scripts -Value "$HOME/.dotfiles/os/windows/scripts" >$null

	# Export variables
	Write-Output @"
`$Env:NAME = 'Edwin Kofler'
`$Env:EMAIL = 'edwin@kofler.dev'
`$Env:EDITOR = 'nvim'
`$Env:VISUAL = "`$Env:EDITOR"
`$Env:Path = "`$HOME/.dotfiles/.data/bin;`$Env:Path"
"@ | Out-File -FilePath ~/.bootstrap/bootstrap-out.ps1

	# Next Steps
	Write-Host @"
---
. "`$HOME/.bootstrap/bootstrap-out.ps1"
~/scripts/doctor.ps1
~/scripts/bootstrap.ps1
~/scripts/idempotent.ps1
---
"@
}

function die([string]$message) {
	error "$message"
	[Console]::Error.WriteLine("=> Exiting")
	exit 1
}

function error([string]$message) {
	[Console]::Error.WriteLine("=> Error: $message")
}

function log([string]$message) {
	Write-Output "=> Info: $message"
}

function iscmd([string]$command) {
	Get-Command "$command" -ErrorAction SilentlyContinue
}

function updatesystem() {
	scoop update
}

function installcmd([string]$command) {
	scoop info "$command" >$null
	if ($?) {
		log "Already installed $command"
	}
	else {
		log "Installing $command"

		scoop install "$command"

		scoop info "$command" >$null
		if (!($?)) {
			die "Automatic installation of $command failed"
		}
	}
}

function clonerepo([string]$uri, [string]$directory) {
	if (Test-Path -Path $directory) {
		log "Already cloned $uri"
	}
	else {
		log "Cloning $uri"
		git clone --quiet "$uri" "$directory" --recurse-submodules

		[array] $git_remote = git -C "$directory" remote
		if ($git_remote[0] -eq 'origin') {
			git -C "$directory" remote rename origin me
		}
	}
}

main
