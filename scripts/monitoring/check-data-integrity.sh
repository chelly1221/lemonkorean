#!/bin/bash
# Check database data integrity

set -e

cd "$(dirname "$0")/../.."

# Check if containers are running
if ! docker compose ps postgres | grep -q "Up"; then
  echo "❌ PostgreSQL container is not running"
  exit 1
fi

# Check lesson count
LESSON_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM lessons;" 2>/dev/null | tr -d ' ')

echo "📊 Current data counts:"
echo "  - Lessons: $LESSON_COUNT"

# Check user count
USER_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | tr -d ' ')
echo "  - Users: $USER_COUNT"

# Check vocabulary count
VOCAB_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM vocabulary;" 2>/dev/null | tr -d ' ')
echo "  - Vocabulary: $VOCAB_COUNT"

# Warning if lesson count is suspiciously low
if [ "$LESSON_COUNT" -lt 10 ]; then
  echo ""
  echo "⚠️  WARNING: Only $LESSON_COUNT lessons found!"
  echo "   This may indicate data loss."
  exit 1
fi

echo ""
echo "✅ Data integrity check passed"
