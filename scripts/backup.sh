#!/bin/bash

################################################################################
# Lemon Korean - Backup Script
# 柠檬韩语 - 백업 스크립트
#
# This script creates backups of:
# 1. PostgreSQL database
# 2. MongoDB database
# 3. MinIO object storage
# 4. Cleanup of old backups (retention period)
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Backup configuration
BACKUP_DIR="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RETENTION_DAYS=30  # Keep backups for 30 days

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Load environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    log_error ".env file not found!"
    exit 1
fi

################################################################################
# 1. PostgreSQL Backup
################################################################################

log_info "Starting PostgreSQL backup..."

POSTGRES_BACKUP_DIR="$BACKUP_DIR/postgres"
mkdir -p "$POSTGRES_BACKUP_DIR"

POSTGRES_BACKUP_FILE="$POSTGRES_BACKUP_DIR/lemon_korean_${TIMESTAMP}.sql"
POSTGRES_BACKUP_COMPRESSED="$POSTGRES_BACKUP_FILE.gz"

# Check if PostgreSQL container is running
if ! docker-compose ps postgres | grep -q "Up"; then
    log_error "PostgreSQL container is not running!"
    exit 1
fi

# Create backup using pg_dump
log_info "Creating PostgreSQL dump..."

docker-compose exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists > "$POSTGRES_BACKUP_FILE"

if [ $? -eq 0 ]; then
    # Compress backup
    gzip "$POSTGRES_BACKUP_FILE"

    BACKUP_SIZE=$(du -h "$POSTGRES_BACKUP_COMPRESSED" | cut -f1)
    log_success "PostgreSQL backup created: $(basename "$POSTGRES_BACKUP_COMPRESSED") ($BACKUP_SIZE)"
else
    log_error "PostgreSQL backup failed!"
    rm -f "$POSTGRES_BACKUP_FILE"
    exit 1
fi

################################################################################
# 2. MongoDB Backup
################################################################################

log_info "Starting MongoDB backup..."

MONGO_BACKUP_DIR="$BACKUP_DIR/mongo"
mkdir -p "$MONGO_BACKUP_DIR"

MONGO_BACKUP_PATH="$MONGO_BACKUP_DIR/lemon_korean_${TIMESTAMP}"

# Check if MongoDB container is running
if ! docker-compose ps mongo | grep -q "Up"; then
    log_error "MongoDB container is not running!"
    exit 1
fi

# Create backup using mongodump
log_info "Creating MongoDB dump..."

docker-compose exec -T mongo mongodump --quiet --out=/tmp/backup

if [ $? -eq 0 ]; then
    # Copy backup from container
    docker cp $(docker-compose ps -q mongo):/tmp/backup "$MONGO_BACKUP_PATH"

    # Clean up inside container
    docker-compose exec -T mongo rm -rf /tmp/backup

    # Compress backup
    tar -czf "${MONGO_BACKUP_PATH}.tar.gz" -C "$MONGO_BACKUP_DIR" "$(basename "$MONGO_BACKUP_PATH")"
    rm -rf "$MONGO_BACKUP_PATH"

    BACKUP_SIZE=$(du -h "${MONGO_BACKUP_PATH}.tar.gz" | cut -f1)
    log_success "MongoDB backup created: $(basename "${MONGO_BACKUP_PATH}.tar.gz") ($BACKUP_SIZE)"
else
    log_error "MongoDB backup failed!"
    exit 1
fi

################################################################################
# 3. MinIO Backup
################################################################################

log_info "Starting MinIO backup..."

MINIO_BACKUP_DIR="$BACKUP_DIR/minio"
mkdir -p "$MINIO_BACKUP_DIR"

MINIO_BACKUP_PATH="$MINIO_BACKUP_DIR/lemon_korean_${TIMESTAMP}"

# Check if MinIO container is running
if ! docker-compose ps minio | grep -q "Up"; then
    log_error "MinIO container is not running!"
    exit 1
fi

# Get MinIO data volume path
MINIO_VOLUME=$(docker-compose config | grep -A 5 "minio:" | grep "source:" | head -1 | awk '{print $2}')

if [ -z "$MINIO_VOLUME" ]; then
    log_warning "MinIO volume not found, using default path"
    MINIO_DATA_PATH="./data/minio"
else
    MINIO_DATA_PATH="$MINIO_VOLUME"
fi

if [ -d "$MINIO_DATA_PATH" ]; then
    log_info "Creating MinIO data backup..."

    # Create backup directory
    mkdir -p "$MINIO_BACKUP_PATH"

    # Copy MinIO data
    cp -r "$MINIO_DATA_PATH"/* "$MINIO_BACKUP_PATH/" 2>/dev/null || true

    if [ $? -eq 0 ]; then
        # Compress backup
        tar -czf "${MINIO_BACKUP_PATH}.tar.gz" -C "$MINIO_BACKUP_DIR" "$(basename "$MINIO_BACKUP_PATH")"
        rm -rf "$MINIO_BACKUP_PATH"

        BACKUP_SIZE=$(du -h "${MINIO_BACKUP_PATH}.tar.gz" | cut -f1)
        log_success "MinIO backup created: $(basename "${MINIO_BACKUP_PATH}.tar.gz") ($BACKUP_SIZE)"
    else
        log_warning "MinIO backup completed with warnings"
        rm -rf "$MINIO_BACKUP_PATH"
    fi
else
    log_warning "MinIO data directory not found at $MINIO_DATA_PATH"
fi

################################################################################
# 4. Cleanup Old Backups
################################################################################

log_info "Cleaning up old backups (older than $RETENTION_DAYS days)..."

DELETED_COUNT=0

# Clean PostgreSQL backups
if [ -d "$POSTGRES_BACKUP_DIR" ]; then
    DELETED=$(find "$POSTGRES_BACKUP_DIR" -name "*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete -print | wc -l)
    DELETED_COUNT=$((DELETED_COUNT + DELETED))
fi

# Clean MongoDB backups
if [ -d "$MONGO_BACKUP_DIR" ]; then
    DELETED=$(find "$MONGO_BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete -print | wc -l)
    DELETED_COUNT=$((DELETED_COUNT + DELETED))
fi

# Clean MinIO backups
if [ -d "$MINIO_BACKUP_DIR" ]; then
    DELETED=$(find "$MINIO_BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete -print | wc -l)
    DELETED_COUNT=$((DELETED_COUNT + DELETED))
fi

if [ $DELETED_COUNT -gt 0 ]; then
    log_success "Deleted $DELETED_COUNT old backup(s)"
else
    log_info "No old backups to delete"
fi

################################################################################
# Summary
################################################################################

echo ""
echo "========================================"
echo "Backup Summary"
echo "========================================"
echo "Timestamp: $TIMESTAMP"
echo "Location:  $BACKUP_DIR"
echo ""

# Calculate total backup size
TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
echo "Total backup size: $TOTAL_SIZE"

# List recent backups
echo ""
echo "Recent backups:"
echo "PostgreSQL:"
ls -lh "$POSTGRES_BACKUP_DIR" | tail -5 | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "MongoDB:"
ls -lh "$MONGO_BACKUP_DIR" | tail -5 | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "MinIO:"
ls -lh "$MINIO_BACKUP_DIR" | tail -5 | awk '{print "  " $9 " (" $5 ")"}'

echo ""
log_success "Backup completed successfully!"
echo ""
echo "To restore from this backup, run:"
echo "  ./scripts/restore.sh $TIMESTAMP"
