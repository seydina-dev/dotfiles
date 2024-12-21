oh-my-posh init pwsh | Invoke-Expression
Import-Module -Name Terminal-Icons


Function item { Get-ChildItem | Format-Wide}
Set-Alias ll item
Set-Alias -Name which -Value Get-Command
Set-Alias -Name rm -Value Remove-Item

Set-Alias clr clear
Set-Alias pn pnpm
Set-Alias px pnpx
Set-Alias arch Arch.exe
Set-Alias phone "./ -noconsole.vbs"
