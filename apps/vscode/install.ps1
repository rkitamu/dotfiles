$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "..\..\lib\common.ps1")

Write-Output "[vscode] Installing VS Code settings..."

$VscodeDir = Join-Path $env:APPDATA "Code\User"
if (-not (Test-Path $VscodeDir)) {
    New-Item -ItemType Directory -Path $VscodeDir -Force | Out-Null
}

foreach ($File in @("settings.json", "keybindings.json")) {
    $Source = Join-Path $ScriptDir $File
    if (-not (Test-Path $Source)) {
        Write-Output "  Skipping $File (not found)"
        continue
    }
    Install-SymbolicLink -Source $Source -Target (Join-Path $VscodeDir $File) -Label "vscode"
}

