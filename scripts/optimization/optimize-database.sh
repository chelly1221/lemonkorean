#!/bin/bash

# ================================================================
# Database Optimization Script
# ================================================================
# PostgreSQL 데이터베이스 최적화: VACUUM, ANALYZE, 인덱스 관리
# ================================================================

set -e

# ================================================================
# CONFIGURATION
# ================================================================

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

CONTAINER_NAME="${POSTGRES_CONTAINER:-lemon-postgres}"
DB_NAME="${POSTGRES_DB:-lemon_korean}"
DB_USER="${POSTGRES_USER:-3chan}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

run_sql() {
    local sql="$1"
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "$sql"
}

# ================================================================
# OPTIMIZATION TASKS
# ================================================================

analyze_database() {
    log "Running ANALYZE on all tables..."
    run_sql "ANALYZE;"
    log "✓ ANALYZE completed"
}

vacuum_database() {
    log "Running VACUUM on database..."
    run_sql "VACUUM (VERBOSE, ANALYZE);"
    log "✓ VACUUM completed"
}

vacuum_full() {
    warn "Running VACUUM FULL (this may take a while and locks tables)..."
    read -p "Are you sure? This will lock all tables. (yes/no): " confirm
    if [ "$confirm" == "yes" ]; then
        run_sql "VACUUM FULL VERBOSE;"
        log "✓ VACUUM FULL completed"
    else
        log "VACUUM FULL cancelled"
    fi
}

reindex_database() {
    log "Reindexing database..."
    run_sql "REINDEX DATABASE $DB_NAME;"
    log "✓ REINDEX completed"
}

check_bloat() {
    log "Checking table and index bloat..."

    cat <<SQL | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) AS external_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;
SQL

    log "✓ Bloat check completed"
}

check_missing_indexes() {
    log "Checking for missing indexes..."

    cat <<SQL | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
SELECT
    schemaname,
    tablename,
    attname,
    n_distinct,
    most_common_vals
FROM pg_stats
WHERE schemaname = 'public'
    AND n_distinct > 100
    AND tablename NOT IN (
        SELECT tablename
        FROM pg_indexes
        WHERE schemaname = 'public'
    )
ORDER BY n_distinct DESC
LIMIT 10;
SQL

    log "✓ Missing indexes check completed"
}

analyze_slow_queries() {
    log "Analyzing slow queries (if pg_stat_statements is enabled)..."

    cat <<SQL | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
SELECT
    calls,
    total_exec_time,
    mean_exec_time,
    max_exec_time,
    query
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
SQL

    log "✓ Slow query analysis completed"
}

update_statistics() {
    log "Updating table statistics..."

    run_sql "SELECT schemaname, tablename FROM pg_tables WHERE schemaname = 'public';" | \
    grep -v "^-" | grep -v "schemaname" | grep -v "^(" | \
    while read -r schema table; do
        [ -z "$table" ] && continue
        log "Analyzing table: $table"
        run_sql "ANALYZE VERBOSE $table;" > /dev/null 2>&1
    done

    log "✓ Statistics updated"
}

database_size() {
    log "Database size information:"

    cat <<SQL | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
SELECT
    pg_database.datname,
    pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM pg_database
ORDER BY pg_database_size(pg_database.datname) DESC;
SQL
}

check_index_usage() {
    log "Checking index usage..."

    cat <<SQL | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan AS index_scans,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan ASC
LIMIT 10;
SQL

    log "✓ Index usage check completed"
}

# ================================================================
# MAIN MENU
# ================================================================

show_menu() {
    echo ""
    echo "=================================="
    echo "  Database Optimization Tool"
    echo "=================================="
    echo "1. Analyze database (ANALYZE)"
    echo "2. Vacuum database (VACUUM)"
    echo "3. Vacuum Full (VACUUM FULL - locks tables)"
    echo "4. Reindex database (REINDEX)"
    echo "5. Check table bloat"
    echo "6. Check missing indexes"
    echo "7. Analyze slow queries"
    echo "8. Update statistics"
    echo "9. Show database size"
    echo "10. Check index usage"
    echo "11. Run all optimizations (1,2,4,8)"
    echo "0. Exit"
    echo "=================================="
    echo -n "Select option: "
}

run_all() {
    log "Running all optimizations..."
    analyze_database
    vacuum_database
    reindex_database
    update_statistics
    log "✓ All optimizations completed"
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    log "=== Database Optimization Tool ==="
    check_container

    if [ "$1" == "--auto" ]; then
        run_all
        exit 0
    fi

    while true; do
        show_menu
        read -r option

        case $option in
            1) analyze_database ;;
            2) vacuum_database ;;
            3) vacuum_full ;;
            4) reindex_database ;;
            5) check_bloat ;;
            6) check_missing_indexes ;;
            7) analyze_slow_queries ;;
            8) update_statistics ;;
            9) database_size ;;
            10) check_index_usage ;;
            11) run_all ;;
            0) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
    done
}

main "$@"
