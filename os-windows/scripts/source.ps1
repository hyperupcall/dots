if ($MyInvocation.InvocationName -ne '.' -and $MyInvocation.Line -ne ''
) {
	[Console]::Error.WriteLine("This script should only be sourced.")
	exit 1
}

if (([Version](Get-CimInstance Win32_OperatingSystem).version).Major -lt 10) {
	Write-Host "Windows versions under 10 is not supported"
	return 1
}
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function util.install_command([string]$command) {
	scoop info "$command" >$null
	if ($?) {
		util.log "Already installed $command"
	}
	else {
		util.log "Installing $command"

		scoop install "$command"

		scoop info "$command" >$null
		if (!($?)) {
			util.die "Automatic installation of $command failed"
		}
	}
}

function util.die([string]$message) {
	util.error "$message"
	[Console]::Error.WriteLine("=> Exiting")
	exit 1
}

function util.error([string]$message) {
	[Console]::Error.WriteLine("=> Error: $message")
}

function util.log([string]$message) {
	Write-Output "=> Info: $message"
}
