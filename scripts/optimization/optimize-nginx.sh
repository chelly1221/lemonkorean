#!/bin/bash

# ================================================================
# Nginx Cache Optimization Script
# ================================================================
# Nginx 캐시 최적화: 캐시 정리, 통계 분석, 설정 검증
# ================================================================

set -e

# ================================================================
# CONFIGURATION
# ================================================================

CONTAINER_NAME="${NGINX_CONTAINER:-lemon-nginx}"
CACHE_DIR="${NGINX_CACHE_DIR:-./nginx/cache}"
LOG_DIR="${NGINX_LOG_DIR:-./nginx/logs}"

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

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        warn "Container $CONTAINER_NAME is not running"
        return 1
    fi
    log "Container $CONTAINER_NAME is running"
    return 0
}

# ================================================================
# CACHE ANALYSIS
# ================================================================

cache_statistics() {
    log "Nginx Cache Statistics:"
    echo ""

    if [ ! -d "$CACHE_DIR" ]; then
        warn "Cache directory not found: $CACHE_DIR"
        return
    fi

    local total_size=$(du -sh "$CACHE_DIR" 2>/dev/null | awk '{print $1}')
    local file_count=$(find "$CACHE_DIR" -type f 2>/dev/null | wc -l)

    log "Cache directory: $CACHE_DIR"
    log "Total size: $total_size"
    log "Total files: $file_count"

    echo ""
    log "Cache by subdirectory:"
    du -h --max-depth=1 "$CACHE_DIR" 2>/dev/null | sort -hr | head -10
}

cache_hit_ratio() {
    log "Analyzing cache hit ratio from access logs..."
    echo ""

    if [ ! -f "$LOG_DIR/access.log" ]; then
        warn "Access log not found: $LOG_DIR/access.log"
        return
    fi

    local total=$(wc -l < "$LOG_DIR/access.log")
    local hits=$(grep -c "HIT" "$LOG_DIR/access.log" 2>/dev/null || echo 0)
    local misses=$(grep -c "MISS" "$LOG_DIR/access.log" 2>/dev/null || echo 0)

    if [ $total -gt 0 ]; then
        local hit_ratio=$((hits * 100 / total))
        log "Total requests: $total"
        log "Cache hits: $hits"
        log "Cache misses: $misses"
        log "Hit ratio: ${hit_ratio}%"
    else
        log "No requests in log file"
    fi
}

top_cached_urls() {
    log "Top 20 cached URLs:"
    echo ""

    if [ ! -f "$LOG_DIR/access.log" ]; then
        warn "Access log not found"
        return
    fi

    grep "HIT" "$LOG_DIR/access.log" 2>/dev/null | \
        awk '{print $7}' | \
        sort | uniq -c | sort -rn | head -20
}

response_time_stats() {
    log "Response time statistics:"
    echo ""

    if [ ! -f "$LOG_DIR/access.log" ]; then
        warn "Access log not found"
        return
    fi

    log "Average response times by endpoint (top 10):"
    awk '{print $7, $NF}' "$LOG_DIR/access.log" | \
        awk '{sum[$1]+=$2; count[$1]++} END {for(i in sum) print i, sum[i]/count[i]}' | \
        sort -k2 -rn | head -10
}

# ================================================================
# CACHE CLEANUP
# ================================================================

clear_cache() {
    warn "This will delete all cached files"
    read -p "Continue? (yes/no): " confirm

    if [ "$confirm" == "yes" ]; then
        log "Clearing cache directory..."

        if [ -d "$CACHE_DIR" ]; then
            rm -rf "${CACHE_DIR:?}"/*
            log "✓ Cache cleared"
        else
            warn "Cache directory not found"
        fi

        if check_container; then
            log "Reloading Nginx..."
            docker exec "$CONTAINER_NAME" nginx -s reload
        fi
    else
        log "Operation cancelled"
    fi
}

clear_old_cache() {
    echo -n "Delete cache files older than (days): "
    read days

    if [ -z "$days" ] || ! [[ "$days" =~ ^[0-9]+$ ]]; then
        error "Invalid input"
    fi

    log "Finding files older than $days days..."

    local count=$(find "$CACHE_DIR" -type f -mtime +$days 2>/dev/null | wc -l)

    if [ $count -eq 0 ]; then
        log "No old files found"
        return
    fi

    warn "Found $count files older than $days days"
    read -p "Delete these files? (yes/no): " confirm

    if [ "$confirm" == "yes" ]; then
        find "$CACHE_DIR" -type f -mtime +$days -delete
        log "✓ Old cache files deleted"
    else
        log "Operation cancelled"
    fi
}

# ================================================================
# LOG ANALYSIS
# ================================================================

analyze_errors() {
    log "Recent error log entries:"
    echo ""

    if [ ! -f "$LOG_DIR/error.log" ]; then
        warn "Error log not found: $LOG_DIR/error.log"
        return
    fi

    tail -50 "$LOG_DIR/error.log"
}

top_error_types() {
    log "Most common errors:"
    echo ""

    if [ ! -f "$LOG_DIR/error.log" ]; then
        warn "Error log not found"
        return
    fi

    awk '{print $9, $10, $11}' "$LOG_DIR/error.log" | \
        sort | uniq -c | sort -rn | head -10
}

access_log_summary() {
    log "Access log summary (last 24 hours):"
    echo ""

    if [ ! -f "$LOG_DIR/access.log" ]; then
        warn "Access log not found"
        return
    fi

    local total=$(wc -l < "$LOG_DIR/access.log")
    local success=$(grep -c " 200 " "$LOG_DIR/access.log" 2>/dev/null || echo 0)
    local redirects=$(grep -cE " 30[0-9] " "$LOG_DIR/access.log" 2>/dev/null || echo 0)
    local client_errors=$(grep -cE " 4[0-9][0-9] " "$LOG_DIR/access.log" 2>/dev/null || echo 0)
    local server_errors=$(grep -cE " 5[0-9][0-9] " "$LOG_DIR/access.log" 2>/dev/null || echo 0)

    log "Total requests: $total"
    log "200 (Success): $success"
    log "3xx (Redirects): $redirects"
    log "4xx (Client errors): $client_errors"
    log "5xx (Server errors): $server_errors"
}

# ================================================================
# CONFIGURATION
# ================================================================

test_config() {
    log "Testing Nginx configuration..."

    if check_container; then
        docker exec "$CONTAINER_NAME" nginx -t
    else
        nginx -t 2>&1
    fi
}

reload_nginx() {
    log "Reloading Nginx..."

    if check_container; then
        docker exec "$CONTAINER_NAME" nginx -s reload
        log "✓ Nginx reloaded"
    else
        error "Container not running"
    fi
}

# ================================================================
# MAIN MENU
# ================================================================

show_menu() {
    echo ""
    echo "==================================="
    echo "  Nginx Optimization Tool"
    echo "==================================="
    echo "Cache Analysis:"
    echo "  1. Cache statistics"
    echo "  2. Cache hit ratio"
    echo "  3. Top cached URLs"
    echo "  4. Response time stats"
    echo ""
    echo "Cache Cleanup:"
    echo "  5. Clear all cache"
    echo "  6. Clear old cache files"
    echo ""
    echo "Log Analysis:"
    echo "  7. Recent errors"
    echo "  8. Top error types"
    echo "  9. Access log summary"
    echo ""
    echo "Configuration:"
    echo "  10. Test configuration"
    echo "  11. Reload Nginx"
    echo ""
    echo "  0. Exit"
    echo "==================================="
    echo -n "Select option: "
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== Nginx Optimization Tool ==="
    echo ""

    if [ "$1" == "--stats" ]; then
        cache_statistics
        cache_hit_ratio
        access_log_summary
        exit 0
    fi

    while true; do
        show_menu
        read -r option

        case $option in
            1) cache_statistics ;;
            2) cache_hit_ratio ;;
            3) top_cached_urls ;;
            4) response_time_stats ;;
            5) clear_cache ;;
            6) clear_old_cache ;;
            7) analyze_errors ;;
            8) top_error_types ;;
            9) access_log_summary ;;
            10) test_config ;;
            11) reload_nginx ;;
            0) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
    done
}

main "$@"
