$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Output "=== dotfiles installer ==="
Write-Output "OS: Windows"
Write-Output ""

# List of app directories with install scripts
$Apps = @("git", "vim", "vscode")

foreach ($App in $Apps) {
    $Installer = Join-Path $ScriptDir "apps\$App\install.ps1"
    if (Test-Path $Installer) {
        Write-Output "--- $App ---"
        & $Installer
        Write-Output ""
    } else {
        Write-Output "--- $App --- (skipped: no install.ps1 found)"
    }
}

Write-Output "=== Done ==="

