#Requires -Version 5.1
. "$PSScriptRoot/../source.ps1"

function Symlink-RelativePath {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$RelativePath,

		[switch]
		$Dry
	)

	$symlinkFile = Join-Path -Path "$HOME" -ChildPath "$relativePath"
	$targetFile = Join-Path -Path "$HOME/.dotfiles/os/windows/user" -ChildPath "$relativePath"

	# Symlink file must either not exist or be a symlink link. With the original dotfox code, this
	# is handled in a more elegant way, but here we just fail. Not worth the trouble for Windows
	if ((Test-Path -Path "$symlinkFile") -and ((Get-Item "$symlinkFile").LinkType -ne 'SymbolicLink')) {
		Write-Error "Path '$symlinkFile' already exists and it is not a symlink"
		return 1
	}

	# The target file must exist
	if (!(Test-Path -Path "$targetFile")) {
		Write-Error "Path '$targetFile' does not exist, but it is expected to"
		return 1
	}

	# Create parent directory of symlink
	$symlinkFileParent = Split-Path -Path "$symlinkFile" -Parent
	if (!(Test-Path -Path "$symlinkFileParent")) {
		New-Item -Type Directory "$symlinkFileParent" >$null
	}

	if ($Dry) {
		Write-Host "Would have symlinked '$symlinkFile' -> '$targetFile'"
	}
 else {
		Write-Host "Symlinking '$symlinkFile' -> '$targetFile'"
		New-Item -ItemType SymbolicLink -Force -Path "$(Split-Path $symlinkFile -Parent)" -Name "$(Split-Path $symlinkFile -Leaf)" -Target "$targetFile"
	}

	return 0
}

function Assert-ScoopBucket {
	[CmdletBinding()]
	Param (
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]
		$Name
	)

	$bucketPath = Join-Path -Path "$HOME/scoop/buckets" -ChildPath "$Name"
	if (!(Test-Path "$bucketPath")) {
		scoop bucket add "$Name"
	}
}

function Assert-ScoopPackage {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern("[a-z]+")]
		[String]
		$Name
	)

	$appDir = Join-Path -Path "$HOME/scoop/apps" -ChildPath "$Name"
	if (Test-Path "$appDir") {
		scoop update "$Name"
	}
 else {
		scoop install "$Name"
	}
}

function Test-RegistryKeyValue {

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string]
		# The path to the registry key where the value should be set.  Will be created if it doesn't exist.
		$Path,

		[Parameter(Mandatory = $true)]
		[string]
		# The name of the value being set.
		$Name
	)

	if (!(Test-Path -Path $Path -PathType Container)) {
		return $false
	}

	$properties = Get-ItemProperty -Path $Path
	if (!$properties) {
		return $false
	}

	if (!(Get-Member -InputObject $properties -Name $Name)) {
		return $false
	}

	return $true
}

foreach ($relativePath in @(
		'.config/git/attributes',
		'.config/git/config',
		'Documents/PowerShell/Microsoft.PowerShell_profile.ps1',
		'Documents/PowerShell/Modules/Dots',
		'Documents/WindowsPowershell/Microsoft.PowerShell_profile.ps1'
		'AppData/Roaming/gnupg/gpg-agent.conf'
	)) {
	[void](Symlink-RelativePath -RelativePath "$relativePath")
}

# TODO
# $__dirname = Split-Path -Parent "$PSCommandPath"

# winget install --id GNUPG.Gpg4win --source winget
# winget install --id PuTTY.PuTTY --source winget
# winget install --id Microsoft.PowerToys --source winget

# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Assert-ScoopBucket -Name extras
# Assert-ScoopBucket -Name versions
# Assert-ScoopBucket -Name php
# Assert-ScoopBucket -Name nerd-fonts
# Assert-ScoopBucket -Name java
# Assert-ScoopBucket -Name games

# Get-Content "$(Join-Path -Path "$__dirname" -ChildPath 'packages.conf')" | ForEach-Object {
# 	if (!$_) {
# 		return
# 	}

# 	if ($_.StartsWith("#")) {
# 		return
# 	}

# 	$octothorpIndex = $_.IndexOf('#')
# 	if ($octothorpIndex -lt 0) {
# 		$line = $_.Trim()
# 	}
# 	else {
# 		$line = $_.Substring(0, $octothorpIndex).Trim()
# 	}

# 	$package = "$line"
# 	Write-Host "line: $package"
# 	Ensure-ScoopPackage -Name "$package"
# }

# $ENV:PATH="$HOME\scoop\apps\python\current\Scripts:$ENV:PATH"
# 'C:\Users\Edwin\scoop\apps\sublime-text\current\install-context.reg'"
# "C:\Users\Edwin\scoop\apps\python\current\install-pep-514.reg"

# Checkpoint-Computer -Description 'Clean Install' -RestorePointType 'MODIFY_SETTINGS' # 5.1

# Ensure devleoper mode is enabled
# $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
# if (!(Test-Path -Path $RegistryKeyPath)) {
#     Write-Host "Creating registry directory"
#     sudo New-Item -Path $RegistryKeyPath -ItemType Directory -Force
# }

# # Enable developer mode
# if(!(Test-RegistryKeyValue -Path "$RegistryKeyPath" -Name 'AllowDevelopmentWithoutDevLicense')) {
#     Write-Host "Enabling developer mode"
#     sudo New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1
# }

# Ensure is admin
# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
#     Write-Error "Not Administrator"
#     exit 1
# }
# Write-Output 'Installing a newer PowerShellGet'
# sudo Install-PackageProvider -Name NuGet -Force

# Install-Module -Name PowerShellGet -Force
# Install-Module -Name PSReadLine -AllowPrerelease -Force
# sudo Install-Module -Name PackageManagement

# Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# PowerToys
# if (!(Test-Path -Path "$env:APPDATA\git-boxstarter")) {
# 	git clone 'https://github.com/chocolatey/boxstarter' "$env:APPDATA\git-boxstarter"
# }

# nim
# sudo New-Item -Type SymbolicLink -Path ~ -Name .ssh -Value G:\storage_other\ssh\

# Write-Host 'nim, powertoys, gpg4win-portable, autohotkey dont really work'

# for espanso?
# [Environment]::SetEnvironmentVariable('PASSWORD_STORE_DIR', "$env:USERPROFILE\Dropbox\password-store", [System.EnvironmentVariableTarget]::User)
# [Environment]::SetEnvironmentVariable('VISUAL', "neovide", [System.EnvironmentVariableTarget]::User)
# [Environment]::SetEnvironmentVariable('EDITOR', "neovide", [System.EnvironmentVariableTarget]::User)

# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.HyperV\Boxstarter.HyperV.psd1" -Force
# Import-Module "$env:APPDATA\git-boxstarter\Boxstarter.WinConfig\Boxstarter.WinConfig.psd1" -Force

# Set-WindowsExplorerOptions ...

Write-Host 'Done.'

