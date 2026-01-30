#!/bin/bash

# ================================================================
# System Resource Monitoring Script
# ================================================================
# 시스템 리소스 모니터링: CPU, 메모리, 디스크, 네트워크
# ================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# ================================================================
# FUNCTIONS
# ================================================================

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

# ================================================================
# DOCKER MONITORING
# ================================================================

docker_stats() {
    section "Docker Container Resources"

    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" | \
        grep -E "lemon-|CONTAINER"
}

docker_processes() {
    section "Docker Container Processes"

    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | \
        grep -E "lemon-|NAMES"
}

container_health() {
    section "Container Health Status"

    for container in $(docker ps --format '{{.Names}}' | grep "^lemon-"); do
        health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-healthcheck")

        if [ "$health" == "healthy" ]; then
            echo -e "${GREEN}✓${NC} $container: $health"
        elif [ "$health" == "unhealthy" ]; then
            echo -e "${RED}✗${NC} $container: $health"
        else
            echo -e "${YELLOW}•${NC} $container: $health"
        fi
    done
}

# ================================================================
# SYSTEM MONITORING
# ================================================================

system_overview() {
    section "System Overview"

    # CPU
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    log "CPU Usage: ${cpu_usage}%"

    # Memory
    free -h | grep -E "^Mem:|^Swap:"

    # Disk
    echo ""
    log "Disk Usage:"
    df -h | grep -E "^/dev/|Filesystem"

    # Load Average
    echo ""
    log "Load Average:"
    uptime
}

disk_usage() {
    section "Disk Usage by Directory"

    log "Project directory:"
    du -sh . 2>/dev/null || echo "Unable to calculate"

    echo ""
    log "Docker volumes:"
    docker volume ls --format "{{.Name}}" | grep "^lemon-" | while read vol; do
        size=$(docker system df -v | grep "$vol" | awk '{print $3}')
        echo "  $vol: ${size:-unknown}"
    done

    echo ""
    log "Top 10 largest directories:"
    du -h --max-depth=2 . 2>/dev/null | sort -hr | head -10
}

network_stats() {
    section "Network Statistics"

    log "Active connections:"
    netstat -an | grep ESTABLISHED | wc -l

    echo ""
    log "Listening ports (Lemon Korean services):"
    netstat -tuln | grep -E ":3001|:3002|:3003|:3004|:3005|:3006|:5432|27017|6379|9000" || echo "No services found"

    echo ""
    log "Network I/O by interface:"
    ip -s link show | grep -A 1 "^[0-9]"
}

# ================================================================
# DATABASE MONITORING
# ================================================================

postgres_stats() {
    section "PostgreSQL Statistics"

    local container="lemon-postgres"

    if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        warn "PostgreSQL container not running"
        return
    fi

    log "Database size:"
    docker exec "$container" psql -U "${POSTGRES_USER:-3chan}" -d "${POSTGRES_DB:-lemon_korean}" -c \
        "SELECT pg_size_pretty(pg_database_size('${POSTGRES_DB:-lemon_korean}'));" 2>/dev/null || warn "Unable to query"

    echo ""
    log "Active connections:"
    docker exec "$container" psql -U "${POSTGRES_USER:-3chan}" -d "${POSTGRES_DB:-lemon_korean}" -c \
        "SELECT count(*) FROM pg_stat_activity;" 2>/dev/null || warn "Unable to query"
}

mongo_stats() {
    section "MongoDB Statistics"

    local container="lemon-mongo"

    if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        warn "MongoDB container not running"
        return
    fi

    log "Database stats:"
    docker exec "$container" mongo --quiet --eval "db.stats()" 2>/dev/null || warn "Unable to query"
}

redis_stats() {
    section "Redis Statistics"

    local container="lemon-redis"

    if ! docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        warn "Redis container not running"
        return
    fi

    docker exec "$container" redis-cli -a "${REDIS_PASSWORD}" --no-auth-warning INFO memory 2>/dev/null | \
        grep -E "used_memory_human|maxmemory" || warn "Unable to query"
}

# ================================================================
# LOG MONITORING
# ================================================================

recent_logs() {
    section "Recent Container Logs (Last 10 lines each)"

    for container in $(docker ps --format '{{.Names}}' | grep "^lemon-" | head -5); do
        echo ""
        log "Container: $container"
        docker logs --tail 10 "$container" 2>&1 | tail -5
    done
}

error_logs() {
    section "Recent Errors in Container Logs"

    for container in $(docker ps --format '{{.Names}}' | grep "^lemon-"); do
        local errors=$(docker logs --since 1h "$container" 2>&1 | grep -iE "error|exception|fatal" | wc -l)

        if [ $errors -gt 0 ]; then
            echo -e "${RED}✗${NC} $container: $errors errors in last hour"
        else
            echo -e "${GREEN}✓${NC} $container: no errors"
        fi
    done
}

# ================================================================
# ALERTS
# ================================================================

check_alerts() {
    section "System Alerts"

    local alerts=0

    # High CPU
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'.' -f1)
    if [ "$cpu" -gt 80 ]; then
        warn "HIGH CPU USAGE: ${cpu}%"
        alerts=$((alerts + 1))
    fi

    # High Memory
    local mem=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
    if [ "$mem" -gt 85 ]; then
        warn "HIGH MEMORY USAGE: ${mem}%"
        alerts=$((alerts + 1))
    fi

    # Disk space
    local disk=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk" -gt 85 ]; then
        warn "HIGH DISK USAGE: ${disk}%"
        alerts=$((alerts + 1))
    fi

    # Unhealthy containers
    for container in $(docker ps --format '{{.Names}}' | grep "^lemon-"); do
        health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-healthcheck")
        if [ "$health" == "unhealthy" ]; then
            warn "UNHEALTHY CONTAINER: $container"
            alerts=$((alerts + 1))
        fi
    done

    if [ $alerts -eq 0 ]; then
        log "No alerts - system healthy"
    else
        echo ""
        echo -e "${RED}Total alerts: $alerts${NC}"
    fi
}

# ================================================================
# MAIN MENU
# ================================================================

show_menu() {
    echo ""
    echo "===================================="
    echo "  System Resource Monitor"
    echo "===================================="
    echo "Docker:"
    echo "  1. Container resources (CPU/Memory)"
    echo "  2. Container processes"
    echo "  3. Container health"
    echo ""
    echo "System:"
    echo "  4. System overview"
    echo "  5. Disk usage"
    echo "  6. Network statistics"
    echo ""
    echo "Databases:"
    echo "  7. PostgreSQL stats"
    echo "  8. MongoDB stats"
    echo "  9. Redis stats"
    echo ""
    echo "Logs:"
    echo "  10. Recent logs"
    echo "  11. Error logs"
    echo ""
    echo "  12. Check alerts"
    echo "  13. Full report"
    echo ""
    echo "  0. Exit"
    echo "===================================="
    echo -n "Select option: "
}

full_report() {
    log "Generating full system report..."

    system_overview
    docker_stats
    container_health
    disk_usage
    postgres_stats
    redis_stats
    check_alerts

    echo ""
    log "Report generated at $(date)"
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    if [ "$1" == "--watch" ]; then
        # Continuous monitoring mode
        while true; do
            clear
            log "=== Live System Monitor (Ctrl+C to exit) ==="
            docker_stats
            container_health
            check_alerts
            sleep 5
        done
    elif [ "$1" == "--report" ]; then
        full_report
        exit 0
    else
        log "=== System Resource Monitor ==="

        while true; do
            show_menu
            read -r option

            case $option in
                1) docker_stats ;;
                2) docker_processes ;;
                3) container_health ;;
                4) system_overview ;;
                5) disk_usage ;;
                6) network_stats ;;
                7) postgres_stats ;;
                8) mongo_stats ;;
                9) redis_stats ;;
                10) recent_logs ;;
                11) error_logs ;;
                12) check_alerts ;;
                13) full_report ;;
                0) log "Goodbye!"; exit 0 ;;
                *) warn "Invalid option" ;;
            esac
        done
    fi
}

main "$@"
