#!/bin/bash

# ================================================================
# All Databases Backup Script
# ================================================================
# Backs up all databases (PostgreSQL, MongoDB)
# ================================================================

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ================================================================
# CONFIGURATION
# ================================================================

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== Starting Full Backup ==="

    local failed=0

    # Backup PostgreSQL
    log "Backing up PostgreSQL..."
    if bash "$SCRIPT_DIR/backup-postgres.sh"; then
        log "PostgreSQL backup completed"
    else
        error "PostgreSQL backup failed"
        failed=$((failed + 1))
    fi

    # Backup MongoDB
    log "Backing up MongoDB..."
    if bash "$SCRIPT_DIR/backup-mongodb.sh"; then
        log "MongoDB backup completed"
    else
        error "MongoDB backup failed"
        failed=$((failed + 1))
    fi

    # Summary
    if [ $failed -eq 0 ]; then
        log "=== All Backups Completed Successfully ==="
        exit 0
    else
        error "=== $failed Backup(s) Failed ==="
        exit 1
    fi
}

main

exit 0
