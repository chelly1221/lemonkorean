#!/bin/bash

################################################################################
# Lemon Korean - Logs Viewer Script
# 柠檬韩语 - 로그 확인 스크립트
#
# This script provides easy access to service logs:
# - View all service logs
# - View specific service logs
# - Follow logs in real-time
# - Filter by time
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Available services
SERVICES=(
    "postgres"
    "mongo"
    "redis"
    "minio"
    "nginx"
    "auth"
    "content"
    "progress"
    "media"
    "analytics"
    "admin"
    "rabbitmq"
)

################################################################################
# Help Function
################################################################################

show_help() {
    echo "Usage: $0 [OPTIONS] [SERVICE]"
    echo ""
    echo "View logs for Lemon Korean services"
    echo ""
    echo "OPTIONS:"
    echo "  -f, --follow         Follow log output (like tail -f)"
    echo "  -n, --lines NUM      Number of lines to show (default: 100)"
    echo "  -t, --tail           Show only last lines (default behavior)"
    echo "  -s, --since TIME     Show logs since timestamp (e.g., 2h, 30m, 2024-01-01)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "SERVICES:"
    echo "  all                  All services (default)"
    echo "  postgres             PostgreSQL database"
    echo "  mongo                MongoDB database"
    echo "  redis                Redis cache"
    echo "  minio                MinIO object storage"
    echo "  nginx                Nginx API gateway"
    echo "  auth                 Auth service"
    echo "  content              Content service"
    echo "  progress             Progress service"
    echo "  media                Media service"
    echo "  analytics            Analytics service"
    echo "  admin                Admin service"
    echo "  rabbitmq             RabbitMQ message queue"
    echo ""
    echo "EXAMPLES:"
    echo "  $0                         # Show last 100 lines of all services"
    echo "  $0 -f                      # Follow all service logs"
    echo "  $0 auth                    # Show auth service logs"
    echo "  $0 -f auth                 # Follow auth service logs"
    echo "  $0 -n 500 postgres         # Show last 500 lines of postgres"
    echo "  $0 --since 1h auth         # Show auth logs from last hour"
    echo "  $0 --since 2024-01-15 all  # Show all logs since Jan 15"
}

################################################################################
# Parse Arguments
################################################################################

FOLLOW=""
LINES="100"
SINCE=""
SERVICE="all"

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--follow)
            FOLLOW="--follow"
            shift
            ;;
        -n|--lines)
            LINES="$2"
            shift 2
            ;;
        -t|--tail)
            # Default behavior, just ignore
            shift
            ;;
        -s|--since)
            SINCE="--since $2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            SERVICE="$1"
            shift
            ;;
    esac
done

################################################################################
# Validate Service
################################################################################

if [ "$SERVICE" != "all" ]; then
    VALID=false
    for svc in "${SERVICES[@]}"; do
        if [ "$svc" = "$SERVICE" ]; then
            VALID=true
            break
        fi
    done

    if [ "$VALID" = false ]; then
        echo -e "${RED}Error:${NC} Invalid service '$SERVICE'"
        echo ""
        echo "Available services: ${SERVICES[*]} all"
        echo ""
        echo "Use '$0 --help' for more information"
        exit 1
    fi
fi

################################################################################
# Build Docker Compose Command
################################################################################

CMD="docker-compose logs"

# Add options
if [ -n "$FOLLOW" ]; then
    CMD="$CMD $FOLLOW"
fi

if [ -n "$SINCE" ]; then
    CMD="$CMD $SINCE"
else
    CMD="$CMD --tail=$LINES"
fi

# Add service
if [ "$SERVICE" != "all" ]; then
    CMD="$CMD $SERVICE"
fi

################################################################################
# Display Header
################################################################################

echo -e "${BLUE}========================================${NC}"
if [ "$SERVICE" = "all" ]; then
    echo -e "${BLUE}Lemon Korean - All Service Logs${NC}"
else
    echo -e "${BLUE}Lemon Korean - $SERVICE Logs${NC}"
fi
echo -e "${BLUE}========================================${NC}"

if [ -n "$SINCE" ]; then
    echo -e "Since: $SINCE"
elif [ -n "$FOLLOW" ]; then
    echo -e "Following logs (Ctrl+C to stop)..."
else
    echo -e "Last $LINES lines"
fi

echo -e "${BLUE}========================================${NC}"
echo ""

################################################################################
# Execute Command
################################################################################

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error:${NC} docker-compose is not installed or not in PATH"
    exit 1
fi

# Check if any containers are running
if [ -z "$(docker-compose ps -q)" ]; then
    echo -e "${YELLOW}Warning:${NC} No containers are running"
    echo ""
    echo "Start services with: docker-compose up -d"
    exit 1
fi

# Execute the command
eval $CMD

################################################################################
# Footer (only shown if not following)
################################################################################

if [ -z "$FOLLOW" ]; then
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "Tip: Use '$0 -f' to follow logs in real-time"
    echo -e "     Use '$0 --help' for more options"
    echo -e "${BLUE}========================================${NC}"
fi
