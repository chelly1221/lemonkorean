#!/bin/bash

# ================================================================
# Redis Cache Optimization Script
# ================================================================
# Redis 캐시 최적화: 메모리 분석, 키 정리, 성능 튜닝
# ================================================================

set -e

# ================================================================
# CONFIGURATION
# ================================================================

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

CONTAINER_NAME="${REDIS_CONTAINER:-lemon-redis}"
REDIS_PASSWORD="${REDIS_PASSWORD}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ================================================================
# FUNCTIONS
# ================================================================

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
    exit 1
}

check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        error "Container $CONTAINER_NAME is not running"
    fi
    log "Container $CONTAINER_NAME is running"
}

redis_cli() {
    docker exec "$CONTAINER_NAME" redis-cli -a "$REDIS_PASSWORD" --no-auth-warning "$@"
}

# ================================================================
# ANALYSIS FUNCTIONS
# ================================================================

memory_stats() {
    log "Redis Memory Statistics:"
    echo ""

    redis_cli INFO memory | grep -E "used_memory_human|used_memory_peak_human|mem_fragmentation_ratio|maxmemory"

    echo ""
    log "Top 10 memory consumers by key pattern:"
    redis_cli --bigkeys -a "$REDIS_PASSWORD" --no-auth-warning 2>/dev/null | tail -n 20
}

key_statistics() {
    log "Redis Key Statistics:"
    echo ""

    local total_keys=$(redis_cli DBSIZE | awk '{print $2}')
    log "Total keys: $total_keys"

    echo ""
    log "Keys by type:"
    redis_cli --scan | head -1000 | while read key; do
        redis_cli TYPE "$key"
    done | sort | uniq -c | sort -rn

    echo ""
    log "Sample key patterns:"
    redis_cli --scan --count 100 | head -20
}

expired_keys_check() {
    log "Checking for keys with TTL..."
    echo ""

    local with_ttl=0
    local without_ttl=0

    redis_cli --scan --count 1000 | while read key; do
        ttl=$(redis_cli TTL "$key")
        if [ "$ttl" -eq -1 ]; then
            without_ttl=$((without_ttl + 1))
        else
            with_ttl=$((with_ttl + 1))
        fi
    done

    log "Keys with TTL: $with_ttl"
    log "Keys without TTL: $without_ttl"
}

slow_log_analysis() {
    log "Analyzing slow log..."
    echo ""

    redis_cli SLOWLOG GET 10
}

connection_stats() {
    log "Connection Statistics:"
    echo ""

    redis_cli INFO clients | grep -E "connected_clients|blocked_clients|client_recent_max_input_buffer|client_recent_max_output_buffer"

    echo ""
    log "Active connections:"
    redis_cli CLIENT LIST | head -10
}

# ================================================================
# OPTIMIZATION FUNCTIONS
# ================================================================

flush_expired() {
    warn "This will trigger active expiration of keys"
    read -p "Continue? (yes/no): " confirm

    if [ "$confirm" == "yes" ]; then
        log "Scanning and checking expired keys..."

        local expired_count=0
        redis_cli --scan | while read key; do
            ttl=$(redis_cli TTL "$key")
            if [ "$ttl" -eq -2 ]; then
                expired_count=$((expired_count + 1))
            fi
        done

        log "Expired keys processed: $expired_count"
    else
        log "Operation cancelled"
    fi
}

clear_namespace() {
    echo -n "Enter namespace pattern (e.g., 'session:*'): "
    read pattern

    warn "This will delete all keys matching: $pattern"

    # Count matching keys
    local count=$(redis_cli --scan --pattern "$pattern" | wc -l)
    log "Found $count keys matching pattern"

    read -p "Delete these keys? (yes/no): " confirm

    if [ "$confirm" == "yes" ]; then
        redis_cli --scan --pattern "$pattern" | xargs -L 1 redis_cli DEL
        log "✓ Keys deleted"
    else
        log "Operation cancelled"
    fi
}

optimize_memory() {
    log "Running memory optimization..."

    # Trigger background save
    log "Triggering BGSAVE..."
    redis_cli BGSAVE

    # Wait for save to complete
    sleep 2

    # Check last save time
    local last_save=$(redis_cli LASTSAVE)
    log "Last save timestamp: $last_save"

    log "✓ Memory optimization completed"
}

reset_slow_log() {
    log "Resetting slow log..."
    redis_cli SLOWLOG RESET
    log "✓ Slow log reset"
}

rewrite_aof() {
    log "Rewriting AOF (Append-Only File)..."
    redis_cli BGREWRITEAOF
    log "✓ AOF rewrite initiated"

    # Check status
    sleep 1
    redis_cli INFO persistence | grep aof
}

# ================================================================
# CONFIGURATION TUNING
# ================================================================

show_config() {
    log "Current Redis Configuration (key settings):"
    echo ""

    redis_cli CONFIG GET maxmemory
    redis_cli CONFIG GET maxmemory-policy
    redis_cli CONFIG GET timeout
    redis_cli CONFIG GET tcp-keepalive
    redis_cli CONFIG GET slowlog-log-slower-than
}

tune_config() {
    log "Configuration Tuning Options:"
    echo ""
    echo "1. Set maxmemory limit"
    echo "2. Change eviction policy"
    echo "3. Adjust timeout"
    echo "0. Back"
    echo ""
    echo -n "Select option: "
    read option

    case $option in
        1)
            echo -n "Enter max memory (e.g., 512mb, 1gb): "
            read maxmem
            redis_cli CONFIG SET maxmemory "$maxmem"
            log "✓ Maxmemory set to $maxmem"
            ;;
        2)
            echo "Available policies:"
            echo "  - noeviction (default)"
            echo "  - allkeys-lru"
            echo "  - volatile-lru"
            echo "  - allkeys-random"
            echo "  - volatile-random"
            echo -n "Select policy: "
            read policy
            redis_cli CONFIG SET maxmemory-policy "$policy"
            log "✓ Eviction policy set to $policy"
            ;;
        3)
            echo -n "Enter client timeout in seconds (0 to disable): "
            read timeout
            redis_cli CONFIG SET timeout "$timeout"
            log "✓ Timeout set to $timeout seconds"
            ;;
        0)
            return
            ;;
    esac
}

# ================================================================
# MAIN MENU
# ================================================================

show_menu() {
    echo ""
    echo "==================================="
    echo "  Redis Optimization Tool"
    echo "==================================="
    echo "Analysis:"
    echo "  1. Memory statistics"
    echo "  2. Key statistics"
    echo "  3. Expired keys check"
    echo "  4. Slow log analysis"
    echo "  5. Connection statistics"
    echo ""
    echo "Optimization:"
    echo "  6. Flush expired keys"
    echo "  7. Clear namespace"
    echo "  8. Optimize memory (BGSAVE)"
    echo "  9. Reset slow log"
    echo "  10. Rewrite AOF"
    echo ""
    echo "Configuration:"
    echo "  11. Show configuration"
    echo "  12. Tune configuration"
    echo ""
    echo "  0. Exit"
    echo "==================================="
    echo -n "Select option: "
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== Redis Optimization Tool ==="
    check_container
    echo ""

    if [ "$1" == "--info" ]; then
        memory_stats
        key_statistics
        connection_stats
        exit 0
    fi

    while true; do
        show_menu
        read -r option

        case $option in
            1) memory_stats ;;
            2) key_statistics ;;
            3) expired_keys_check ;;
            4) slow_log_analysis ;;
            5) connection_stats ;;
            6) flush_expired ;;
            7) clear_namespace ;;
            8) optimize_memory ;;
            9) reset_slow_log ;;
            10) rewrite_aof ;;
            11) show_config ;;
            12) tune_config ;;
            0) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
    done
}

main "$@"
