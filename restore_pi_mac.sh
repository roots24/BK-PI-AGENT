#!/bin/bash

# Pi Coding Agent Configuration Restoration Script (macOS/Linux)
# This script restores the configuration, skills, and settings from a backup folder.

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$SCRIPT_DIR/pi_coding_agent_backup"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory not found at $BACKUP_DIR"
    echo "Please ensure the backup folder is in the same directory as this script."
    exit 1
fi

echo "Starting restoration of Pi Coding Agent configuration..."

# 1. Restore Files and Folders
# Find all files and directories inside the backup folder
find "$BACKUP_DIR" -mindepth 1 | while read -r ITEM; do
    # Calculate the relative path from the backup directory
    REL_PATH="${ITEM#$BACKUP_DIR/}"
    DEST_PATH="$HOME/$REL_PATH"
    
    if [ -d "$ITEM" ]; then
        mkdir -p "$DEST_PATH"
        echo "Created directory: $REL_PATH"
    else
        DEST_DIR=$(dirname "$DEST_PATH")
        mkdir -p "$DEST_DIR"
        cp "$ITEM" "$DEST_PATH"
        echo "Restored file: $REL_PATH"
    fi
done

# 2. Environment Variables Guidance
if [ -f "$BACKUP_DIR/pi_env_vars.txt" ]; then
    echo -e "\nEnvironment variables backup found!"
    echo "Please add the following variables to your shell configuration file (e.g., ~/.zshrc or ~/.bash_profile):"
    echo "--------------------------------------------------------------------------------"
    cat "$BACKUP_DIR/pi_env_vars.txt" | sed 's/^/export /'
    echo "--------------------------------------------------------------------------------"
    echo "After adding them, run: source ~/.zshrc (or the file you edited)"
fi

echo -e "\nRestoration completed successfully!"
echo "Please restart your terminal or Pi Coding Agent for changes to take effect."
