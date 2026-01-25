#!/bin/bash

################################################################################
# Lemon Korean - Deployment Script
# 柠檬韩语 - 배포 스크립트
#
# This script handles the complete deployment process:
# 1. Environment variable validation
# 2. Docker Compose image building
# 3. Database migration
# 4. Service startup
# 5. Health checks
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

################################################################################
# 1. Environment Variable Check
################################################################################

log_info "Checking environment variables..."

if [ ! -f .env ]; then
    log_error ".env file not found!"
    log_info "Creating .env from .env.example..."

    if [ -f .env.example ]; then
        cp .env.example .env
        log_warning "Please edit .env file with your configuration before deploying!"
        exit 1
    else
        log_error ".env.example not found!"
        exit 1
    fi
fi

# Required environment variables
REQUIRED_VARS=(
    "DB_PASSWORD"
    "POSTGRES_DB"
    "POSTGRES_USER"
    "JWT_SECRET"
    "MINIO_ACCESS_KEY"
    "MINIO_SECRET_KEY"
)

# Source .env file
set -a
source .env
set +a

MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    log_error "Missing required environment variables:"
    for var in "${MISSING_VARS[@]}"; do
        echo "  - $var"
    done
    exit 1
fi

log_success "Environment variables validated"

################################################################################
# 2. Docker Compose Build
################################################################################

log_info "Building Docker images..."

docker-compose build --no-cache

if [ $? -eq 0 ]; then
    log_success "Docker images built successfully"
else
    log_error "Failed to build Docker images"
    exit 1
fi

################################################################################
# 3. Database Migration
################################################################################

log_info "Starting PostgreSQL for migration..."

docker-compose up -d postgres

# Wait for PostgreSQL to be ready
log_info "Waiting for PostgreSQL to be ready..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker-compose exec -T postgres pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; then
        log_success "PostgreSQL is ready"
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

# Run migrations
log_info "Running database migrations..."

MIGRATION_DIR="$PROJECT_ROOT/init/postgres"

if [ -d "$MIGRATION_DIR" ]; then
    for migration_file in "$MIGRATION_DIR"/*.sql; do
        if [ -f "$migration_file" ]; then
            log_info "Running migration: $(basename "$migration_file")"
            docker-compose exec -T postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" < "$migration_file"

            if [ $? -eq 0 ]; then
                log_success "Migration completed: $(basename "$migration_file")"
            else
                log_error "Migration failed: $(basename "$migration_file")"
                exit 1
            fi
        fi
    done
else
    log_warning "No migration directory found at $MIGRATION_DIR"
fi

################################################################################
# 4. Start Services
################################################################################

log_info "Starting all services..."

docker-compose up -d

if [ $? -eq 0 ]; then
    log_success "All services started"
else
    log_error "Failed to start services"
    exit 1
fi

# Wait a bit for services to initialize
log_info "Waiting for services to initialize..."
sleep 10

################################################################################
# 5. Health Checks
################################################################################

log_info "Performing health checks..."

# Service endpoints
SERVICES=(
    "auth:3001:/api/auth/health"
    "content:3002:/api/content/health"
    "progress:3003:/api/progress/health"
    "media:3004:/health"
    "analytics:3005:/health"
    "admin:3006:/api/admin/health"
)

FAILED_SERVICES=()

for service_info in "${SERVICES[@]}"; do
    IFS=':' read -r service_name port endpoint <<< "$service_info"

    log_info "Checking $service_name service..."

    MAX_RETRIES=10
    RETRY_COUNT=0
    HEALTH_OK=false

    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port$endpoint" 2>/dev/null || echo "000")

        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "204" ]; then
            log_success "$service_name is healthy (HTTP $HTTP_CODE)"
            HEALTH_OK=true
            break
        fi

        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo -n "."
            sleep 2
        fi
    done
    echo ""

    if [ "$HEALTH_OK" = false ]; then
        log_error "$service_name health check failed"
        FAILED_SERVICES+=("$service_name")
    fi
done

# Check PostgreSQL
log_info "Checking PostgreSQL..."
if docker-compose exec -T postgres pg_isready -U "$POSTGRES_USER" > /dev/null 2>&1; then
    log_success "PostgreSQL is healthy"
else
    log_error "PostgreSQL health check failed"
    FAILED_SERVICES+=("postgres")
fi

# Check MongoDB
log_info "Checking MongoDB..."
if docker-compose exec -T mongo mongosh --quiet --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    log_success "MongoDB is healthy"
else
    log_error "MongoDB health check failed"
    FAILED_SERVICES+=("mongo")
fi

# Check Redis
log_info "Checking Redis..."
if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
    log_success "Redis is healthy"
else
    log_error "Redis health check failed"
    FAILED_SERVICES+=("redis")
fi

# Check MinIO
log_info "Checking MinIO..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:9000/minio/health/live" 2>/dev/null || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    log_success "MinIO is healthy"
else
    log_error "MinIO health check failed"
    FAILED_SERVICES+=("minio")
fi

################################################################################
# Summary
################################################################################

echo ""
echo "========================================"
echo "Deployment Summary"
echo "========================================"

if [ ${#FAILED_SERVICES[@]} -eq 0 ]; then
    log_success "All services are running and healthy!"
    echo ""
    echo "Services:"
    echo "  - Auth Service:      http://localhost:3001"
    echo "  - Content Service:   http://localhost:3002"
    echo "  - Progress Service:  http://localhost:3003"
    echo "  - Media Service:     http://localhost:3004"
    echo "  - Analytics Service: http://localhost:3005"
    echo "  - Admin Service:     http://localhost:3006"
    echo "  - MinIO Console:     http://localhost:9001"
    echo ""
    echo "Use './scripts/logs.sh' to view logs"
    echo "Use 'docker-compose ps' to check service status"
    exit 0
else
    log_error "The following services failed health checks:"
    for service in "${FAILED_SERVICES[@]}"; do
        echo "  - $service"
    done
    echo ""
    echo "Check logs with: ./scripts/logs.sh"
    echo "Or specific service: docker-compose logs <service-name>"
    exit 1
fi
