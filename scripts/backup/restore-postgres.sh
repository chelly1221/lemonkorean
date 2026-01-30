#!/bin/bash

# ================================================================
# PostgreSQL Database Restore Script
# ================================================================
# Restores PostgreSQL database from backup file
# ================================================================

set -e
set -u

# ================================================================
# CONFIGURATION
# ================================================================

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

CONTAINER_NAME="${POSTGRES_CONTAINER:-lemon-postgres}"
DB_NAME="${POSTGRES_DB:-lemon_korean}"
DB_USER="${POSTGRES_USER:-3chan}"

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

Restore PostgreSQL database from a backup file.

Arguments:
    backup_file    Path to the backup file (*.sql.gz)

Examples:
    $0 backups/postgres/daily/backup_20260128_120000.sql.gz
    $0 backups/postgres/weekly/backup_20260121_120000.sql.gz

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

    # Drop existing connections
    log "Dropping existing connections..."
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c \
        "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$DB_NAME' AND pid <> pg_backend_pid();" \
        || true

    # Drop and recreate database
    log "Dropping and recreating database..."
    docker exec "$CONTAINER_NAME" dropdb -U "$DB_USER" --if-exists "$DB_NAME"
    docker exec "$CONTAINER_NAME" createdb -U "$DB_USER" "$DB_NAME"

    # Restore backup
    log "Restoring backup..."
    if gunzip -c "$backup_file" | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"; then
        log "Database restore completed successfully"
    else
        error "Database restore failed"
    fi
}

verify_restore() {
    log "Verifying restore..."

    # Check if database exists and has tables
    local table_count=$(docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -t -c \
        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")

    table_count=$(echo "$table_count" | tr -d ' ')

    if [ "$table_count" -gt 0 ]; then
        log "Restore verified: $table_count tables found"
    else
        error "Restore verification failed: no tables found"
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

    log "=== PostgreSQL Restore Started ==="

    check_container
    confirm_restore "$backup_file"
    restore_database "$backup_file"
    verify_restore

    log "=== PostgreSQL Restore Completed ==="
}

main "$@"

exit 0
