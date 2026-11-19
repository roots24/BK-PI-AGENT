# Pi Coding Agent Configuration Transfer Script
# This script backups the configuration, skills, and settings of the Pi Coding Agent.

# The backup folder will now be created in the same directory as the script
$BackupDir = Join-Path $PSScriptRoot "pi_coding_agent_backup"
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir }

Write-Host "Starting backup of Pi Coding Agent configuration..." -ForegroundColor Cyan

# 1. Backup Environment Variables
Write-Host "Exporting PI environment variables..."
Get-ChildItem Env:PI_* | ForEach-Object {
    "$($_.Name)=$($_.Value)" | Out-File -FilePath "$BackupDir\pi_env_vars.txt" -Append
}

# 2. Define paths to backup (these are always in the user home directory)
$PathsToBackup = @(
    "$HOME\.pi\models.json",
    "$HOME\.pi\agent\auth.json",
    "$HOME\.pi\agent\settings.json",
    "$HOME\.pi\agent\models-store.json",
    "$HOME\.pi\agent\models.json",
    "$HOME\.pi\agent\models0.json",
    "$HOME\.pi\agent\run-history.jsonl",
    "$HOME\.pi\agent\extensions",
    "$HOME\.pi\agent\missions",
    "$HOME\.pi\agent\sessions",
    "$HOME\.agents\skills"
)

# 3. Perform the copy
foreach ($Path in $PathsToBackup) {
    if (Test-Path $Path) {
        $RelativePath = $Path.Replace($HOME, "").TrimStart('\')
        $DestPath = Join-Path $BackupDir $RelativePath
        $DestDir = Split-Path $DestPath -Parent
        
        if (!(Test-Path $DestDir)) { New-Item -ItemType Directory -Path $DestDir -Force }
        
        if (Test-Path $Path -PathType Container) {
            Copy-Item -Path $Path -Destination $DestPath -Recurse -Force
            Write-Host "Backed up folder: $RelativePath"
        } else {
            Copy-Item -Path $Path -Destination $DestPath -Force
            Write-Host "Backed up file: $RelativePath"
        }
    } else {
        Write-Host "Warning: Path not found, skipping: $Path" -ForegroundColor Yellow
    }
}

Write-Host "`nBackup completed successfully! Files are located in: $BackupDir" -ForegroundColor Green
Write-Host "To transfer to another PC, copy the entire 'BK-PI' folder." -ForegroundColor White
