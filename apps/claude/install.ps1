$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "..\..\lib\common.ps1")

Write-Output "[claude] Installing Claude Code user CLAUDE.md..."

# ~/.claude also holds session history and credentials, so link only the file
$ClaudeDir = Join-Path $HOME ".claude"
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
}

Install-SymbolicLink -Source (Join-Path $ScriptDir "CLAUDE.md") -Target (Join-Path $ClaudeDir "CLAUDE.md") -Label "claude"
