#!/bin/bash
# ================================================================
# Docker Volume Mount Verification Script
# ================================================================
# This script verifies that all data and configuration volumes
# are properly mounted and working.
# ================================================================

# Continue on errors to show full report
# set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}  Docker Volume Mount Verification${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Function to check if a volume exists
check_volume() {
    local volume_name=$1
    if docker volume ls --format '{{.Name}}' | grep -q "^${volume_name}$"; then
        echo -e "${GREEN}✓${NC} Volume exists: ${volume_name}"
        return 0
    else
        echo -e "${YELLOW}○${NC} Volume not created yet: ${volume_name}"
        return 1
    fi
}

# Function to check if a container is running
check_container() {
    local container_name=$1
    if docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
        echo -e "${GREEN}✓${NC} Container running: ${container_name}"
        return 0
    else
        echo -e "${YELLOW}○${NC} Container not running: ${container_name}"
        return 1
    fi
}

# Function to check config file exists
check_config() {
    local config_path=$1
    local config_name=$2
    if [ -f "$config_path" ]; then
        echo -e "${GREEN}✓${NC} Config exists: ${config_name}"
        return 0
    else
        echo -e "${RED}✗${NC} Config missing: ${config_name} (${config_path})"
        return 1
    fi
}

echo -e "${BLUE}--- Checking Configuration Files ---${NC}"
check_config "./config/postgres/postgresql.conf" "PostgreSQL config"
check_config "./config/redis/redis.conf" "Redis config"
check_config "./config/mongo/mongod.conf" "MongoDB config"
check_config "./config/rabbitmq/rabbitmq.conf" "RabbitMQ config"
check_config "./config/rabbitmq/definitions.json" "RabbitMQ definitions"
check_config "./monitoring/prometheus/rules/alerts.yml" "Prometheus alerts"
echo ""

echo -e "${BLUE}--- Checking Data Volumes ---${NC}"
check_volume "lemon-postgres-data"
check_volume "lemon-mongo-data"
check_volume "lemon-mongo-log"
check_volume "lemon-redis-data"
check_volume "lemon-minio-data"
check_volume "lemon-rabbitmq-data"
check_volume "lemon-pgadmin-data"
check_volume "lemon-nginx-proxy-manager-data"
check_volume "lemon-nginx-proxy-manager-letsencrypt"
echo ""

echo -e "${BLUE}--- Checking Containers ---${NC}"
check_container "lemon-postgres"
check_container "lemon-mongo"
check_container "lemon-redis"
check_container "lemon-minio"
check_container "lemon-rabbitmq"
check_container "lemon-nginx"
echo ""

echo -e "${BLUE}--- Verifying Database Configurations ---${NC}"

# PostgreSQL config verification
if docker ps --format '{{.Names}}' | grep -q "lemon-postgres"; then
    echo -e "${YELLOW}Testing PostgreSQL config...${NC}"
    config_file=$(docker exec lemon-postgres psql -U 3chan -t -c "SHOW config_file;" 2>/dev/null || echo "error")
    if [[ "$config_file" == *"/etc/postgresql/postgresql.conf"* ]]; then
        echo -e "${GREEN}✓${NC} PostgreSQL using custom config: ${config_file}"
    else
        echo -e "${YELLOW}○${NC} PostgreSQL config path: ${config_file}"
    fi
fi

# Redis config verification
if docker ps --format '{{.Names}}' | grep -q "lemon-redis"; then
    echo -e "${YELLOW}Testing Redis config...${NC}"
    maxmem=$(docker exec lemon-redis redis-cli CONFIG GET maxmemory 2>/dev/null | tail -1 || echo "error")
    if [ "$maxmem" != "error" ]; then
        echo -e "${GREEN}✓${NC} Redis maxmemory: ${maxmem}"
    fi
fi

# MongoDB config verification (basic check)
if docker ps --format '{{.Names}}' | grep -q "lemon-mongo"; then
    echo -e "${YELLOW}Testing MongoDB config...${NC}"
    mongo_status=$(docker exec lemon-mongo mongosh --eval "db.adminCommand('serverStatus')" 2>/dev/null | head -5 || echo "MongoDB check skipped")
    if [[ "$mongo_status" != *"error"* ]]; then
        echo -e "${GREEN}✓${NC} MongoDB is accessible"
    fi
fi

echo ""
echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}  Verification Complete${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""
echo "To apply configuration changes, restart containers:"
echo "  docker compose down"
echo "  docker compose up -d"
echo ""
