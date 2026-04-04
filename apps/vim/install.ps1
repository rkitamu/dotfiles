$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "..\..\lib\common.ps1")

Write-Host "[vim] Installing vimrc..."
Install-SymbolicLink -Source (Join-Path $ScriptDir ".vimrc") -Target (Join-Path $env:USERPROFILE ".vimrc") -Label "vim"
