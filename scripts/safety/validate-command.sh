#!/bin/bash
# Command Safety Validator
# Checks if a command is safe to execute according to .claude-safety.yml

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SAFETY_CONFIG="$PROJECT_ROOT/.claude-safety.yml"
LOG_FILE="$PROJECT_ROOT/.claude-safety.log"

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to log attempts
log_attempt() {
    local status="$1"
    local command="$2"
    local reason="$3"

    echo "$(date '+%Y-%m-%d %H:%M:%S') | $status | $command | $reason" >> "$LOG_FILE"
}

# Function to check if command is blocked
is_blocked() {
    local cmd="$1"

    # List of blocked patterns
    local blocked_patterns=(
        "docker.*down.*-v"
        "docker.*down.*--volumes"
        "docker.*system.*prune.*--volumes"
        "docker.*volume.*rm.*lemon.*-safe"
        "docker.*volume.*prune"
        "rm.*-rf.*/var/lib/docker/volumes"
        "rm.*-rf.*backups"
        "DROP DATABASE"
        "TRUNCATE TABLE"
    )

    for pattern in "${blocked_patterns[@]}"; do
        if echo "$cmd" | grep -qE "$pattern"; then
            return 0  # Blocked
        fi
    done

    return 1  # Not blocked
}

# Function to check if command requires confirmation
requires_confirmation() {
    local cmd="$1"

    # List of patterns requiring confirmation
    local confirm_patterns=(
        "docker.*volume.*rm"
        "docker.*compose.*down"
        "docker.*system.*prune"
        "rm.*-rf"
        "DROP"
        "TRUNCATE"
        "DELETE FROM"
    )

    for pattern in "${confirm_patterns[@]}"; do
        if echo "$cmd" | grep -qE "$pattern"; then
            return 0  # Requires confirmation
        fi
    done

    return 1  # No confirmation needed
}

# Function to get safe alternative
get_safe_alternative() {
    local cmd="$1"

    case "$cmd" in
        *"docker compose down -v"*|*"docker-compose down -v"*)
            echo "docker compose down"
            ;;
        *"docker system prune -a --volumes"*)
            echo "docker system prune -a"
            ;;
        *"docker volume rm"*)
            echo "먼저 데이터 백업 후 사용자 확인 필요"
            ;;
        *)
            echo "안전한 대안 없음 - 사용자 확인 필요"
            ;;
    esac
}

# Main validation function
validate_command() {
    local cmd="$1"
    local caller="${2:-user}"  # user or claude

    echo ""
    echo "🔍 Command Safety Check"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Command: $cmd"
    echo "Caller: $caller"
    echo ""

    # Check if blocked
    if is_blocked "$cmd"; then
        echo -e "${RED}❌ BLOCKED${NC}"
        echo ""
        echo "이 명령어는 차단되었습니다!"
        echo "이유: 데이터 손실 위험"
        echo ""

        alternative=$(get_safe_alternative "$cmd")
        echo -e "${GREEN}안전한 대안:${NC}"
        echo "  $alternative"
        echo ""

        log_attempt "BLOCKED" "$cmd" "Dangerous command - $caller"

        return 1
    fi

    # Check if requires confirmation
    if requires_confirmation "$cmd"; then
        echo -e "${YELLOW}⚠️  REQUIRES CONFIRMATION${NC}"
        echo ""
        echo "이 명령어는 위험할 수 있습니다."
        echo ""

        if [ "$caller" = "claude" ]; then
            echo -e "${RED}Claude Code는 이 명령어를 실행할 수 없습니다.${NC}"
            echo "사용자가 직접 실행해야 합니다."
            echo ""

            log_attempt "REQUIRES_USER" "$cmd" "Requires user confirmation - blocked for Claude"

            return 1
        else
            # User is executing
            echo "계속하시겠습니까?"
            echo ""
            read -p "YES를 입력하여 확인: " confirm

            if [ "$confirm" = "YES" ]; then
                echo -e "${GREEN}✅ APPROVED${NC}"
                log_attempt "APPROVED" "$cmd" "User confirmed"
                return 0
            else
                echo -e "${RED}❌ CANCELLED${NC}"
                log_attempt "CANCELLED" "$cmd" "User cancelled"
                return 1
            fi
        fi
    fi

    # Safe command
    echo -e "${GREEN}✅ SAFE${NC}"
    echo "이 명령어는 안전합니다."
    echo ""

    log_attempt "SAFE" "$cmd" "Safe command"

    return 0
}

# Check if command provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <command> [caller]"
    echo ""
    echo "Example:"
    echo "  $0 'docker compose down -v' claude"
    echo "  $0 'docker compose down' user"
    exit 1
fi

# Validate command
validate_command "$1" "${2:-user}"
exit_code=$?

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $exit_code
