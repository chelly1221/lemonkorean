#!/bin/bash
# Safe Docker Compose Wrapper
# Validates commands before executing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="$SCRIPT_DIR/validate-command.sh"

# Build full command
FULL_CMD="docker compose $*"

# Validate command
if ! "$VALIDATOR" "$FULL_CMD" "user"; then
    echo ""
    echo "❌ 명령어가 차단되었습니다."
    exit 1
fi

# Execute if validated
echo "🚀 실행 중: $FULL_CMD"
echo ""

docker compose "$@"
