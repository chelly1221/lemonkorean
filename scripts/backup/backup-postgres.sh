#!/bin/bash

# ================================================================
# PostgreSQL Database Backup Script
# ================================================================
# Backs up PostgreSQL database with automatic retention policy
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
BACKUP_DIR="${BACKUP_DIR:-./backups/postgres}"
CONTAINER_NAME="${POSTGRES_CONTAINER:-lemon-postgres}"
DB_NAME="${POSTGRES_DB:-lemon_korean}"
DB_USER="${POSTGRES_USER:-3chan}"

# Retention policy (days)
DAILY_RETENTION=7
WEEKLY_RETENTION=30
MONTHLY_RETENTION=90

# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DATE=$(date +"%Y%m%d")
DAY_OF_WEEK=$(date +"%u")  # 1=Monday, 7=Sunday
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

# Check if Docker container is running
check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        error "Container $CONTAINER_NAME is not running"
    fi
    log "Container $CONTAINER_NAME is running"
}

# Create backup directory
create_backup_dir() {
    mkdir -p "$BACKUP_DIR"/{daily,weekly,monthly}
    log "Backup directories created/verified"
}

# Perform backup
backup_database() {
    local backup_type=$1
    local backup_file="${BACKUP_DIR}/${backup_type}/backup_${DATE}_${TIMESTAMP}.sql.gz"

    log "Starting $backup_type backup: $backup_file"

    # Run pg_dump inside Docker container
    if docker exec "$CONTAINER_NAME" pg_dump \
        -U "$DB_USER" \
        -d "$DB_NAME" \
        --verbose \
        --no-owner \
        --no-acl \
        --format=plain | gzip > "$backup_file"; then

        local size=$(du -h "$backup_file" | cut -f1)
        log "$backup_type backup completed successfully: $size"
        echo "$backup_file"
    else
        error "$backup_type backup failed"
    fi
}

# Clean old backups based on retention policy
cleanup_old_backups() {
    local backup_type=$1
    local retention_days=$2
    local backup_path="${BACKUP_DIR}/${backup_type}"

    log "Cleaning up $backup_type backups older than $retention_days days"

    find "$backup_path" -name "backup_*.sql.gz" -type f -mtime +$retention_days -delete

    local remaining=$(find "$backup_path" -name "backup_*.sql.gz" -type f | wc -l)
    log "Remaining $backup_type backups: $remaining"
}

# Verify backup integrity
verify_backup() {
    local backup_file=$1

    log "Verifying backup integrity: $backup_file"

    if ! gzip -t "$backup_file" 2>/dev/null; then
        error "Backup verification failed: $backup_file is corrupted"
    fi

    log "Backup verification passed"
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== PostgreSQL Backup Started ==="

    # Check prerequisites
    check_container
    create_backup_dir

    # Determine backup type based on date
    if [ "$DAY_OF_MONTH" = "01" ]; then
        # Monthly backup on 1st of month
        backup_file=$(backup_database "monthly")
        verify_backup "$backup_file"
        cleanup_old_backups "monthly" "$MONTHLY_RETENTION"
    elif [ "$DAY_OF_WEEK" = "7" ]; then
        # Weekly backup on Sundays
        backup_file=$(backup_database "weekly")
        verify_backup "$backup_file"
        cleanup_old_backups "weekly" "$WEEKLY_RETENTION"
    else
        # Daily backup
        backup_file=$(backup_database "daily")
        verify_backup "$backup_file"
        cleanup_old_backups "daily" "$DAILY_RETENTION"
    fi

    log "=== PostgreSQL Backup Completed ==="
}

# Run main function
main

exit 0
