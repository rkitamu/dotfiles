$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== dotfiles installer ==="
Write-Host "OS: Windows"
Write-Host ""

# List of app directories with install scripts
$Apps = @("git", "vim", "vscode")

foreach ($App in $Apps) {
    $Installer = Join-Path $ScriptDir "apps\$App\install.ps1"
    if (Test-Path $Installer) {
        Write-Host "--- $App ---"
        & $Installer
        Write-Host ""
    } else {
        Write-Host "--- $App --- (skipped: no install.ps1 found)"
    }
}

Write-Host "=== Done ==="
