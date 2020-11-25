$ErrorActionPreference = 'Stop';

$meta = Get-Content -Path $env:ChocolateyPackageFolder\tools\packageArgs.json -Raw
$packageArgs = @{}
(ConvertFrom-Json $meta).psobject.properties | ForEach-Object { $packageArgs[$_.Name] = $_.Value }

$filename = if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       Split-Path $packageArgs["url64bit"] -Leaf }
else { Split-Path $packageArgs["url"] -Leaf }

$packageArgs["packageName"] = "$($env:ChocolateyPackageName)"
$packageArgs["fileFullPath"] = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) $filename)"

$exeLocation = Get-ChocolateyWebFile @packageArgs

New-Item -Path "$($exeLocation + ".ignore")" -ItemType File -Force | Out-Null

$installLog = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "install.log")"
Start-Process  -FilePath  "$($exeLocation)" -Args "install krew" -WindowStyle Hidden -Wait -RedirectStandardError $installLog

Install-ChocolateyPath -PathToInstall "$($HOME)\.krew\bin"  -PathType User
Update-SessionEnvironment
