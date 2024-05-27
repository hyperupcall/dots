# TODO
function ls() {
	Get-ChildItem -Attributes 'Hidden,!Hidden'
}

function New-TemporaryDirectory {
	$parent = [System.IO.Path]::GetTempPath()
	$name = [System.IO.Path]::GetRandomFileName()
	New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

function mkt() {
	# TODO
	# $randomfile = [System.IO.Path]::GetRandomFileName()
	# Out-File "$randomFile"

	$file = New-TemporaryFile
	Remove-Item "$file" | Out-Null
	New-Item -ItemType Directory "$file-dir" | Out-Null
	Set-Location "$file-dir" | Out-Null

	# $tempFolderPath = Join-Path $Env:Temp $(New-Guid)
	# New-Item -Type Directory -Path $tempFolderPath | Out-Null
}

function rmrf() {
	Remove-Item -Recurse -Force @args
}

function gclone {
	git clone @args
}

function ginit {
	git init @args
}

function mkcd() {
	New-Item -Type Directory "$($args[0])"
	Set-Location "$($args[0])"
}

function cdls() {
	Set-Location "$($args[0])"
	if (!$?) {
		_powershell_util_die "cdls failed"
	}
	_powershell_util_ls
}

function mkmv() {

}

function lsblk() {
	Get-Disk | ForEach-Object { Get-Partition -DiskNumber $($_.Number) }
}

function cd- {
	Set-Location -
}

function l {
	Get-ChildItem @args
}

function source {
	. @args
}

function sop() {
	. "$profile"
}

function o() {
	explorer .
}

function cmdv([string]$Name) {
	$(Get-Command "$Name").Source
}

function Relaunch-Admin {
	Start-Process -Verb RunAs (Get-Process -Id $PID).Path
}

# With-Env GIT_TRACE=1 git commit -vv --allow-empty --message 'four'
function With-Env {
	$ori = @{}
	Try {
		$i = 0

		# Loading .env files
		if (Test-Path $args[0]) {
			foreach ($line in (Get-Content $args[0])) {
				if ($line -Match '^\s*$' -Or $line -Match '^#') {
					continue
				}

				$key, $val = $line.Split("=")
				$ori[$key] = if (Test-Path Env:\$key) { (Get-Item Env:\$key).Value } else { "" }
				New-Item -Name $key -Value $val -ItemType Variable -Path Env: -Force > $null
			}

			$i++
		}

		while (1) {
			if ($i -ge $args.length) {
				exit
			}

			if (!($args[$i] -Match '^[^ ]+=[^ ]+$')) {
				break
			}

			$key, $val = $args[$i].Split("=")
			$ori[$key] = if (Test-Path Env:\$key) { (Get-Item Env:\$key).Value } else { "" }
			New-Item -Name $key -Value $val -ItemType Variable -Path Env: -Force > $null

			$i++
		}


		Invoke-Expression ($args[$i..$args.length] -Join " ")
	}
 Finally {
		foreach ($key in $ori.Keys) {
			New-Item -Name $key -Value $ori.Item($key) -ItemType Variable -Path Env: -Force > $null
		}
	}
}

function unlink {
	for ($i = 0; $i -lt $args.Length; $i++) {
		# (Get-Item) -is [System.IO.DirectoryInfo]
		if ((Test-Path "$($args[$i])") -and (Get-Item -ItemType Symlink "$($args[$i])")) {

		}
		Write-host "folder: $($args[$i])"
		# does something with the arguments
	}
}

# FIXME: export all functions that do not begin with '_'?
function _powershell_util_die {
	Write-Host ""
	return 1
}

function _powershell_util_ls() {
	Get-ChildItem -Attributes 'Hidden,!Hidden'
}

# https://www.reddit.com/r/PowerShell/comments/b06gtw/til_that_powershell_can_do_colors/
function Print-Color() {
	$ansi_escape = [char]27

	for ($r = 0; $r -le 255; $r += 16) {
		for ($g = 0; $g -le 255; $g += 8) {
			write-host ""
			for ($b = 0; $b -le 255; $b += 4) {
				$ansi_command = "$ansi_escape[48;2;{0};{1};{2}m" -f $r, $g, $b
				$text = " "
				$ansi_terminate = "$ansi_escape[0m"
				$out = $ansi_command + $text + $ansi_terminate
				write-host -nonewline $out
			}
		}
	}
}
