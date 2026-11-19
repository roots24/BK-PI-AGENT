# Pi Coding Agent Configuration Restoration Script
# This script restores the configuration, skills, and settings from a backup folder.

$BackupDir = "$PSScriptRoot\pi_coding_agent_backup"

if (!(Test-Path $BackupDir)) {
    Write-Error "Backup directory not found at $BackupDir. Please ensure the backup folder is in the same directory as this script."
    exit
}

Write-Host "Starting restoration of Pi Coding Agent configuration..." -ForegroundColor Cyan

# 1. Restore Files and Folders
$BackupItems = Get-ChildItem -Path $BackupDir -Recurse

foreach ($Item in $BackupItems) {
    # Calculate the relative path from the backup directory
    $RelativePath = $Item.FullName.Replace($BackupDir, "").TrimStart('\')
    $DestPath = Join-Path $HOME $RelativePath
    
    if ($Item.PSIsContainer) {
        if (!(Test-Path $DestPath)) {
            New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
            Write-Host "Created directory: $RelativePath"
        }
    } else {
        $DestDir = Split-Path $DestPath -Parent
        if (!(Test-Path $DestDir)) {
            New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
        }
        Copy-Item -Path $Item.FullName -Destination $DestPath -Force
        Write-Host "Restored file: $RelativePath"
    }
}

# 2. Environment Variables Guidance
if (Test-Path "$BackupDir\pi_env_vars.txt") {
    Write-Host "`nEnvironment variables backup found!" -ForegroundColor Yellow
    Write-Host "Please manually set the following variables on the new PC (see $BackupDir\pi_env_vars.txt):"
    Get-Content "$BackupDir\pi_env_vars.txt"
    Write-Host "`nYou can set them via PowerShell using: [Environment]::SetEnvironmentVariable('NAME', 'VALUE', 'User')" -ForegroundColor Gray
}

Write-Host "`nRestoration completed successfully!" -ForegroundColor Green
Write-Host "Please restart your terminal or Pi Coding Agent for changes to take effect." -ForegroundColor White
