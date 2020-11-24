$ErrorActionPreference = 'Stop';

#TODO: Uninstall-ChocolateyPath if https://github.com/chocolatey/choco/issues/310 or https://github.com/chocolatey/choco/pull/1019 or https://github.com/chocolatey/choco/pull/166 closed

Remove-Item -Path "$($HOME)\.krew"  -Recurse -Force | Out-Null
Update-SessionEnvironment
