# Common utility functions for dotfiles installers

# Install-SymbolicLink -Source <path> -Target <path> -Label <string>
#   Creates a symbolic link from Target -> Source.
#   If Target already exists and is not a symlink, backs it up as Target.bak.
function Install-SymbolicLink {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Label
    )

    if ((Test-Path $Target) -and -not (Get-Item $Target).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
        $Backup = "${Target}.bak"
        Write-Output "  Backing up existing $Target -> $Backup"
        Move-Item -Path $Target -Destination $Backup -Force
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
    Write-Output "[$Label] Linked $Target -> $Source"
}

