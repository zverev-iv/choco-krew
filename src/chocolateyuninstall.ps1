#TODO: Uninstall-ChocolateyPath if https://github.com/chocolatey/choco/issues/310 or https://github.com/chocolatey/choco/pull/1019 or https://github.com/chocolatey/choco/pull/166 closed
$ErrorActionPreference = 'Stop';

Remove-Item -Path "$($HOME)\.krew"  -Recurse -Force | Out-Null
Update-SessionEnvironment
