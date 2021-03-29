$ErrorActionPreference = 'Stop';

$packageArgs = @{
	softwareName   = 'krew'
	packageName    = $env:ChocolateyPackageName
	fileFullPath  = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "krew.exe")"
	url64bit       = 'https://github.com/kubernetes-sigs/krew/releases/download/v0.4.1/krew.exe'
	checksum64     = 'D749605F076728452748B53A2D744A9A63D0472D37EDB5D37522267352745FD6'
	checksumType64 = 'sha256'
}

$exeLocation = Get-ChocolateyWebFile @packageArgs

New-Item -Path "$($exeLocation + ".ignore")" -ItemType File -Force | Out-Null

$installLog = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "install.log")"
Start-Process  -FilePath  "$($exeLocation)" -Args "install krew" -WindowStyle Hidden -Wait -RedirectStandardError $installLog

Install-ChocolateyPath -PathToInstall "$($HOME)\.krew\bin"  -PathType User
Update-SessionEnvironment
