$ErrorActionPreference = 'Stop';

$packageArgs = @{
	softwareName   = 'krew'
	packageName    = $env:ChocolateyPackageName
	fileFullPath  = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "krew.exe")"
	url64bit       = 'https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew.exe'
	checksum64     = '317D64BA05D6CFCD153418C62D9251CC18CA05DCF35DDC5162FB00315E9F456C'
	checksumType64 = 'sha256'
}

$exeLocation = Get-ChocolateyWebFile @packageArgs

New-Item -Path "$($exeLocation + ".ignore")" -ItemType File -Force | Out-Null

$installLog = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "install.log")"
Start-Process  -FilePath  "$($exeLocation)" -Args "install krew" -WindowStyle Hidden -Wait -RedirectStandardError $installLog

Install-ChocolateyPath -PathToInstall "$($HOME)\.krew\bin"  -PathType User
Update-SessionEnvironment
