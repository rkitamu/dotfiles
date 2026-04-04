$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "..\..\lib\common.ps1")

Write-Host "[git] Installing gitconfig..."
Install-SymbolicLink -Source (Join-Path $ScriptDir ".gitconfig") -Target (Join-Path $env:USERPROFILE ".gitconfig") -Label "git"
