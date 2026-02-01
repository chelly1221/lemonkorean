#!/bin/bash
# Check critical Docker volumes exist

set -e

REQUIRED_VOLUMES=(
  "lemon-postgres-data"
  "lemon-mongo-data"
  "lemon-redis-data"
  "lemon-minio-data"
)

MISSING_VOLUMES=0

for volume in "${REQUIRED_VOLUMES[@]}"; do
  if ! docker volume inspect "$volume" &>/dev/null; then
    echo "❌ CRITICAL: Volume $volume does not exist!"
    MISSING_VOLUMES=$((MISSING_VOLUMES + 1))
  else
    echo "✅ Volume $volume exists"
  fi
done

if [ $MISSING_VOLUMES -gt 0 ]; then
  echo ""
  echo "❌ ERROR: $MISSING_VOLUMES critical volume(s) missing!"
  exit 1
fi

echo ""
echo "✅ All critical volumes exist"
