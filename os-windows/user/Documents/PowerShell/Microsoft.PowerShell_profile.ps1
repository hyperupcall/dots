$ErrorView = 'ConciseView'

# Enable-ExperimentalFeature -Name PSCommandNotFoundSuggestion
#Enable-ExperimentalFeature -Name PSCultureInvariantReplaceOperator
#Enable-ExperimentalFeature -Name PSImplicitRemotingBatching
#Enable-ExperimentalFeature -Name PSNativePSPathResolution
#Enable-ExperimentalFeature -Name PSNotApplyErrorActionToStderr
#Enable-ExperimentalFeature -Name PSSubsystemPluginModel

$env:VCPKG_DISABLE_METRICS = " "

# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

Set-PSReadLineOption -EditMode Emacs
$__dirname = Split-Path -Parent "$PSCommandPath"

# Import-Module PSReadLine
#Set-PSReadlineKeyHandler -Key ctrl+p -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key ctrl+n -Function HistorySearchForward
#Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit
Set-Alias -Name bottom -Value btm
Set-Alias -Name alias -Value Set-Alias
Set-Alias -Name g -Value git
Alias r Remove-Item
Set-Alias sudobash Relaunch-Admin
Set-Alias asadmin Relaunch-Admin
Set-Alias psadmin Relaunch-Admin

Set-Alias -Name geth -Value Get-Help

Set-Alias -Name reboot -Value Restart-Computer
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path("$ChocolateyProfile")) {
  Import-Module "$ChocolateyProfile"
}

$PSReadLineOptions = @{
    CompletionQueryItems = 250
    EditMode = 'Emacs'
    HistoryNoDuplicates = $false
    HistorySaveStyle = 'SaveAtExit'
    HistorySearchCursorMovesToEnd = $false
    MaximumKillRingCount = 15
    # ShowToolTips = $true
}
Set-PSReadLineOption @PSReadLineOptions
Set-PSReadlineOption -BellStyle None

$splat = @{
    Key = 'Alt+h'
    BriefDescription = 'ShowHelpMenu'
    LongDescription = "Pass '--help' to the program in the buffer"
    ScriptBlock = {
        param($key, $arg)

        Write-Host 'Not implemented'

      #   $line = $null
      #   $cursor = $null
      #   [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

      #   echo 'so done'
      #   $cmd = $null
      #   $pos = $line.IndexOf(' ')
      #   echo 'RESULT' $pos
      #   if ($pos.Length -lt 0) {
      #       if (Get-Command "$line" -ErrorAction SilentlyContinue) {
      #           $cmd = "$line"
      #       }
      #   } else {
      #       $cmd = $line.Substring(0, $pos)
      #   }

      #   if (!$cmd) {
      #       & "$cmd" --help
      #   }

        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    }
}
Set-PSReadLineKeyHandler @splat

# Set-PSReadLineKeyHandler -Chord 'Alt+l' -ScriptBlock {
#     Get-ChildItem
# }
# $splat = @{
#     Key = 'Alt+l'
#     BriefDescription = 's'
#     LongDescription = "P buffer"
#     ScriptBlock = {
#         Get-ChildItem
#     }
# }
# Set-PSReadLineKeyHandler @splat

$splat = @{
	Key = 'Alt+m'
	BriefDescription = 'ShowManPage'
	LongDescription = 'Gathers the manual for the program in the buffer'
	ScriptBlock = {
		param($key, $arg)

		Write-Host 'Not implemented'

		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
	}
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
	if ($env:WT_SESSION -or ($env:TERM -eq 'xterm-256color')) {
		Invoke-Expression (&starship init powershell)
	}
}
