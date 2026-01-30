#!/bin/bash

# ================================================================
# MongoDB Database Restore Script
# ================================================================
# Restores MongoDB database from backup file
# ================================================================

set -e
set -u

# ================================================================
# CONFIGURATION
# ================================================================

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

CONTAINER_NAME="${MONGO_CONTAINER:-lemon-mongo}"
DB_NAME="${POSTGRES_DB:-lemon_korean}"
DB_USER="3chan"
DB_PASSWORD="${DB_PASSWORD}"

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

usage() {
    cat <<EOF
Usage: $0 <backup_file>

Restore MongoDB database from a backup file.

Arguments:
    backup_file    Path to the backup file (*.archive)

Examples:
    $0 backups/mongodb/daily/backup_20260128_120000.archive
    $0 backups/mongodb/weekly/backup_20260121_120000.archive

EOF
    exit 1
}

check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        error "Container $CONTAINER_NAME is not running"
    fi
    log "Container $CONTAINER_NAME is running"
}

confirm_restore() {
    echo ""
    echo "WARNING: This will REPLACE the existing database!"
    echo "Database: $DB_NAME"
    echo "Backup file: $1"
    echo ""
    read -p "Are you sure you want to proceed? (yes/no): " confirm

    if [ "$confirm" != "yes" ]; then
        log "Restore cancelled by user"
        exit 0
    fi
}

restore_database() {
    local backup_file=$1

    log "Starting database restore from: $backup_file"

    # Copy backup to container
    docker cp "$backup_file" "$CONTAINER_NAME:/tmp/restore.archive"

    # Drop existing database
    log "Dropping existing database..."
    docker exec "$CONTAINER_NAME" mongosh \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        --authenticationDatabase=admin \
        --eval "db.getSiblingDB('$DB_NAME').dropDatabase()" \
        || true

    # Restore backup
    log "Restoring backup..."
    if docker exec "$CONTAINER_NAME" mongorestore \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        --authenticationDatabase=admin \
        --archive="/tmp/restore.archive" \
        --gzip; then

        # Clean up
        docker exec "$CONTAINER_NAME" rm -f /tmp/restore.archive

        log "Database restore completed successfully"
    else
        error "Database restore failed"
    fi
}

verify_restore() {
    log "Verifying restore..."

    # Check if database exists and has collections
    local collection_count=$(docker exec "$CONTAINER_NAME" mongosh \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        --authenticationDatabase=admin \
        --quiet \
        --eval "db.getSiblingDB('$DB_NAME').getCollectionNames().length" | tail -n 1)

    if [ "$collection_count" -gt 0 ]; then
        log "Restore verified: $collection_count collections found"
    else
        error "Restore verification failed: no collections found"
    fi
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    if [ $# -ne 1 ]; then
        usage
    fi

    local backup_file=$1

    if [ ! -f "$backup_file" ]; then
        error "Backup file not found: $backup_file"
    fi

    log "=== MongoDB Restore Started ==="

    check_container
    confirm_restore "$backup_file"
    restore_database "$backup_file"
    verify_restore

    log "=== MongoDB Restore Completed ==="
}

main "$@"

exit 0
