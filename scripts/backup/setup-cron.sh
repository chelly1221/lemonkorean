#!/bin/bash

# ================================================================
# Setup Cron Jobs for Automated Backups
# ================================================================
# Configures cron to run daily backups automatically
# ================================================================

set -e

# Get absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2
    exit 1
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== Setting up Cron Jobs ==="

    # Create cron job entry
    CRON_JOB="0 2 * * * cd $PROJECT_DIR && bash $SCRIPT_DIR/backup-all.sh >> $PROJECT_DIR/backups/backup.log 2>&1"

    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "backup-all.sh"; then
        log "Cron job already exists"
        read -p "Do you want to replace it? (yes/no): " replace
        if [ "$replace" != "yes" ]; then
            log "Keeping existing cron job"
            exit 0
        fi

        # Remove existing job
        crontab -l 2>/dev/null | grep -v "backup-all.sh" | crontab -
        log "Removed existing cron job"
    fi

    # Add new cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

    log "Cron job added successfully"
    log ""
    log "Backup Schedule:"
    log "  - Daily at 2:00 AM (server time)"
    log "  - Logs: $PROJECT_DIR/backups/backup.log"
    log ""
    log "Current cron jobs:"
    crontab -l

    log ""
    log "=== Cron Setup Completed ==="
}

main

exit 0
