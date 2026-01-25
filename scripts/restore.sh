#!/bin/bash

################################################################################
# Lemon Korean - Restore Script
# 柠檬韩语 - 복구 스크립트
#
# This script restores from backups:
# 1. PostgreSQL database
# 2. MongoDB database
# 3. MinIO object storage
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

# Backup directory
BACKUP_DIR="$PROJECT_ROOT/backups"

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
# Parse Arguments
################################################################################

if [ $# -eq 0 ]; then
    log_info "Available backups:"
    echo ""

    if [ ! -d "$BACKUP_DIR" ]; then
        log_error "No backups found at $BACKUP_DIR"
        exit 1
    fi

    # List available timestamps from PostgreSQL backups
    if [ -d "$BACKUP_DIR/postgres" ]; then
        echo "Timestamps:"
        ls -1 "$BACKUP_DIR/postgres" | grep -o '[0-9]\{8\}_[0-9]\{6\}' | sort -r | uniq | while read timestamp; do
            echo "  - $timestamp"
        done
    else
        log_error "No backups found"
        exit 1
    fi

    echo ""
    echo "Usage: $0 <timestamp>"
    echo "Example: $0 20240115_143022"
    exit 0
fi

TIMESTAMP=$1

# Validate timestamp format
if ! [[ $TIMESTAMP =~ ^[0-9]{8}_[0-9]{6}$ ]]; then
    log_error "Invalid timestamp format. Expected: YYYYMMDD_HHMMSS"
    exit 1
fi

log_warning "⚠️  WARNING: This will REPLACE all current data with backup from $TIMESTAMP"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    log_info "Restore cancelled"
    exit 0
fi

################################################################################
# 1. PostgreSQL Restore
################################################################################

log_info "Starting PostgreSQL restore..."

POSTGRES_BACKUP_FILE="$BACKUP_DIR/postgres/lemon_korean_${TIMESTAMP}.sql.gz"

if [ ! -f "$POSTGRES_BACKUP_FILE" ]; then
    log_error "PostgreSQL backup not found: $POSTGRES_BACKUP_FILE"
    exit 1
fi

# Check if PostgreSQL container is running
if ! docker-compose ps postgres | grep -q "Up"; then
    log_error "PostgreSQL container is not running!"
    log_info "Start services first: docker-compose up -d postgres"
    exit 1
fi

# Wait for PostgreSQL to be ready
log_info "Waiting for PostgreSQL to be ready..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker-compose exec -T postgres pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; then
        break
    fi

    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
        log_error "PostgreSQL failed to start within timeout"
        exit 1
    fi

    echo -n "."
    sleep 1
done
echo ""

log_info "Restoring PostgreSQL database..."

# Decompress and restore
gunzip -c "$POSTGRES_BACKUP_FILE" | docker-compose exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

if [ $? -eq 0 ]; then
    log_success "PostgreSQL database restored successfully"
else
    log_error "PostgreSQL restore failed!"
    exit 1
fi

################################################################################
# 2. MongoDB Restore
################################################################################

log_info "Starting MongoDB restore..."

MONGO_BACKUP_FILE="$BACKUP_DIR/mongo/lemon_korean_${TIMESTAMP}.tar.gz"

if [ ! -f "$MONGO_BACKUP_FILE" ]; then
    log_error "MongoDB backup not found: $MONGO_BACKUP_FILE"
    exit 1
fi

# Check if MongoDB container is running
if ! docker-compose ps mongo | grep -q "Up"; then
    log_error "MongoDB container is not running!"
    log_info "Start services first: docker-compose up -d mongo"
    exit 1
fi

# Extract backup
TEMP_MONGO_DIR="/tmp/mongo_restore_${TIMESTAMP}"
mkdir -p "$TEMP_MONGO_DIR"

log_info "Extracting MongoDB backup..."
tar -xzf "$MONGO_BACKUP_FILE" -C "$TEMP_MONGO_DIR"

# Find the backup directory
MONGO_BACKUP_PATH=$(find "$TEMP_MONGO_DIR" -type d -name "lemon_korean_*" | head -1)

if [ -z "$MONGO_BACKUP_PATH" ]; then
    log_error "Could not find MongoDB backup data in archive"
    rm -rf "$TEMP_MONGO_DIR"
    exit 1
fi

log_info "Restoring MongoDB database..."

# Copy backup to container
docker cp "$MONGO_BACKUP_PATH" $(docker-compose ps -q mongo):/tmp/restore

# Restore using mongorestore
docker-compose exec -T mongo mongorestore --quiet --drop /tmp/restore

if [ $? -eq 0 ]; then
    # Clean up
    docker-compose exec -T mongo rm -rf /tmp/restore
    rm -rf "$TEMP_MONGO_DIR"

    log_success "MongoDB database restored successfully"
else
    log_error "MongoDB restore failed!"
    docker-compose exec -T mongo rm -rf /tmp/restore
    rm -rf "$TEMP_MONGO_DIR"
    exit 1
fi

################################################################################
# 3. MinIO Restore
################################################################################

log_info "Starting MinIO restore..."

MINIO_BACKUP_FILE="$BACKUP_DIR/minio/lemon_korean_${TIMESTAMP}.tar.gz"

if [ ! -f "$MINIO_BACKUP_FILE" ]; then
    log_warning "MinIO backup not found: $MINIO_BACKUP_FILE"
    log_info "Skipping MinIO restore"
else
    # Check if MinIO container is running
    if ! docker-compose ps minio | grep -q "Up"; then
        log_error "MinIO container is not running!"
        log_info "Start services first: docker-compose up -d minio"
        exit 1
    fi

    # Get MinIO data volume path
    MINIO_VOLUME=$(docker-compose config | grep -A 5 "minio:" | grep "source:" | head -1 | awk '{print $2}')

    if [ -z "$MINIO_VOLUME" ]; then
        MINIO_DATA_PATH="./data/minio"
    else
        MINIO_DATA_PATH="$MINIO_VOLUME"
    fi

    # Stop MinIO temporarily
    log_info "Stopping MinIO for restore..."
    docker-compose stop minio

    # Backup current data (just in case)
    if [ -d "$MINIO_DATA_PATH" ]; then
        log_info "Backing up current MinIO data..."
        mv "$MINIO_DATA_PATH" "${MINIO_DATA_PATH}.pre_restore_$(date +%s)"
    fi

    # Create directory
    mkdir -p "$MINIO_DATA_PATH"

    # Extract backup
    log_info "Extracting MinIO backup..."
    TEMP_MINIO_DIR="/tmp/minio_restore_${TIMESTAMP}"
    mkdir -p "$TEMP_MINIO_DIR"
    tar -xzf "$MINIO_BACKUP_FILE" -C "$TEMP_MINIO_DIR"

    # Find the backup directory
    MINIO_BACKUP_PATH=$(find "$TEMP_MINIO_DIR" -type d -name "lemon_korean_*" | head -1)

    if [ -z "$MINIO_BACKUP_PATH" ]; then
        log_error "Could not find MinIO backup data in archive"
        rm -rf "$TEMP_MINIO_DIR"
        exit 1
    fi

    # Copy data
    log_info "Restoring MinIO data..."
    cp -r "$MINIO_BACKUP_PATH"/* "$MINIO_DATA_PATH/"

    # Clean up
    rm -rf "$TEMP_MINIO_DIR"

    # Restart MinIO
    log_info "Restarting MinIO..."
    docker-compose start minio

    log_success "MinIO data restored successfully"
fi

################################################################################
# Summary
################################################################################

echo ""
echo "========================================"
echo "Restore Summary"
echo "========================================"
echo "Restored from timestamp: $TIMESTAMP"
echo ""
log_success "Restore completed successfully!"
echo ""
echo "Services status:"
docker-compose ps
echo ""
log_info "It's recommended to restart all services:"
echo "  docker-compose restart"
