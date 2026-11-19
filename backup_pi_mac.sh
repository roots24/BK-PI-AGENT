#!/bin/bash

# Pi Coding Agent Configuration Transfer Script (macOS/Linux)
# This script backups the configuration, skills, and settings of the Pi Coding Agent.

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$SCRIPT_DIR/pi_coding_agent_backup"

echo "Starting backup of Pi Coding Agent configuration..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# 1. Backup Environment Variables
echo "Exporting PI environment variables..."
env | grep '^PI_' > "$BACKUP_DIR/pi_env_vars.txt"

# 2. Define paths to backup
# Using an array for paths relative to the home directory
PATHS_TO_BACKUP=(
    ".pi/models.json"
    ".pi/agent/auth.json"
    ".pi/agent/settings.json"
    ".pi/agent/models-store.json"
    ".pi/agent/models.json"
    ".pi/agent/models0.json"
    ".pi/agent/run-history.jsonl"
    ".pi/agent/extensions"
    ".pi/agent/missions"
    ".pi/agent/sessions"
    ".agents/skills"
)

# 3. Perform the copy
for REL_PATH in "${PATHS_TO_BACKUP[@]}"; do
    FULL_PATH="$HOME/$REL_PATH"
    
    if [ -e "$FULL_PATH" ]; then
        DEST_PATH="$BACKUP_DIR/$REL_PATH"
        DEST_DIR=$(dirname "$DEST_PATH")
        
        mkdir -p "$DEST_DIR"
        cp -R "$FULL_PATH" "$DEST_PATH"
        echo "Backed up: $REL_PATH"
    else
        echo "Warning: Path not found, skipping: $REL_PATH"
    fi
done

echo -e "\nBackup completed successfully! Files are located in: $BACKUP_DIR"
echo "To transfer to another Mac, copy the entire 'BK-PI' folder."
