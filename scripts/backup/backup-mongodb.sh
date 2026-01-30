#!/bin/bash

# ================================================================
# MongoDB Database Backup Script
# ================================================================
# Backs up MongoDB database with automatic retention policy
# ================================================================

set -e  # Exit on error
set -u  # Exit on undefined variable

# ================================================================
# CONFIGURATION
# ================================================================

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Backup configuration
BACKUP_DIR="${BACKUP_DIR:-./backups/mongodb}"
CONTAINER_NAME="${MONGO_CONTAINER:-lemon-mongo}"
DB_NAME="${POSTGRES_DB:-lemon_korean}"
DB_USER="3chan"
DB_PASSWORD="${DB_PASSWORD}"

# Retention policy (days)
DAILY_RETENTION=7
WEEKLY_RETENTION=30
MONTHLY_RETENTION=90

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DATE=$(date +"%Y%m%d")
DAY_OF_WEEK=$(date +"%u")
DAY_OF_MONTH=$(date +"%d")

# ================================================================
# FUNCTIONS
# ================================================================

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2
    exit 1
}

check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        error "Container $CONTAINER_NAME is not running"
    fi
    log "Container $CONTAINER_NAME is running"
}

create_backup_dir() {
    mkdir -p "$BACKUP_DIR"/{daily,weekly,monthly}
    log "Backup directories created/verified"
}

backup_database() {
    local backup_type=$1
    local backup_file="${BACKUP_DIR}/${backup_type}/backup_${DATE}_${TIMESTAMP}.archive"

    log "Starting $backup_type backup: $backup_file"

    # Run mongodump inside Docker container
    if docker exec "$CONTAINER_NAME" mongodump \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        --authenticationDatabase=admin \
        --db="$DB_NAME" \
        --archive="/tmp/backup.archive" \
        --gzip; then

        # Copy backup from container to host
        docker cp "$CONTAINER_NAME:/tmp/backup.archive" "$backup_file"

        # Clean up temp file in container
        docker exec "$CONTAINER_NAME" rm -f /tmp/backup.archive

        local size=$(du -h "$backup_file" | cut -f1)
        log "$backup_type backup completed successfully: $size"
        echo "$backup_file"
    else
        error "$backup_type backup failed"
    fi
}

cleanup_old_backups() {
    local backup_type=$1
    local retention_days=$2
    local backup_path="${BACKUP_DIR}/${backup_type}"

    log "Cleaning up $backup_type backups older than $retention_days days"

    find "$backup_path" -name "backup_*.archive" -type f -mtime +$retention_days -delete

    local remaining=$(find "$backup_path" -name "backup_*.archive" -type f | wc -l)
    log "Remaining $backup_type backups: $remaining"
}

verify_backup() {
    local backup_file=$1

    log "Verifying backup integrity: $backup_file"

    if [ ! -s "$backup_file" ]; then
        error "Backup verification failed: $backup_file is empty or missing"
    fi

    log "Backup verification passed"
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== MongoDB Backup Started ==="

    check_container
    create_backup_dir

    if [ "$DAY_OF_MONTH" = "01" ]; then
        backup_file=$(backup_database "monthly")
        verify_backup "$backup_file"
        cleanup_old_backups "monthly" "$MONTHLY_RETENTION"
    elif [ "$DAY_OF_WEEK" = "7" ]; then
        backup_file=$(backup_database "weekly")
        verify_backup "$backup_file"
        cleanup_old_backups "weekly" "$WEEKLY_RETENTION"
    else
        backup_file=$(backup_database "daily")
        verify_backup "$backup_file"
        cleanup_old_backups "daily" "$DAILY_RETENTION"
    fi

    log "=== MongoDB Backup Completed ==="
}

main

exit 0
