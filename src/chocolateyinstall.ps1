$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = $env:ChocolateyPackageName
	softwareName   = "${softwareName}"
	url64bit       = "${url64bit}"
	checksum64     = "${checksum64}"
	checksumType64 = "${checksumType64}"
	fileFullPath  = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "krew.exe")"
}

$exeLocation = Get-ChocolateyWebFile @packageArgs

New-Item -Path "$($exeLocation + ".ignore")" -ItemType File -Force | Out-Null

$installLog = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "install.log")"
Start-Process  -FilePath  "$($exeLocation)" -Args "install krew" -WindowStyle Hidden -Wait -RedirectStandardError $installLog

Install-ChocolateyPath -PathToInstall "$($HOME)\.krew\bin"  -PathType User
Update-SessionEnvironment
