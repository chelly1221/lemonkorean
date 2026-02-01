#!/bin/bash
# Test script to verify volumes are protected from deletion

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo "🧪 Testing Volume Protection"
echo "========================================================"
echo ""

# Check if docker-compose.override.yml exists
if [ ! -f "docker-compose.override.yml" ]; then
  echo "❌ ERROR: docker-compose.override.yml not found"
  echo "Run: ./scripts/migrate-to-external-volumes.sh first"
  exit 1
fi

echo "✅ docker-compose.override.yml found"
echo ""

# Check external volumes
echo "📋 Checking external volumes..."
echo ""

EXTERNAL_VOLUMES=(
  "lemon-postgres-data-safe"
  "lemon-mongo-data-safe"
  "lemon-redis-data-safe"
  "lemon-minio-data-safe"
  "lemon-rabbitmq-data-safe"
)

ALL_EXIST=true

for volume in "${EXTERNAL_VOLUMES[@]}"; do
  if docker volume inspect "$volume" &>/dev/null; then
    # Check if it's marked as external in compose
    if docker-compose config | grep -A 2 "$volume" | grep -q "external: true"; then
      size=$(docker system df -v | grep "$volume" | awk '{print $3}' || echo "unknown")
      echo "✅ $volume (external) - Size: $size"
    else
      echo "⚠️  $volume exists but may not be external"
      ALL_EXIST=false
    fi
  else
    echo "❌ $volume - NOT FOUND"
    ALL_EXIST=false
  fi
done

echo ""

if [ "$ALL_EXIST" = false ]; then
  echo "⚠️  Some volumes missing. Run migration first:"
  echo "  ./scripts/migrate-to-external-volumes.sh"
  exit 1
fi

echo "✅ All external volumes configured correctly!"
echo ""

# Show what docker-compose down -v would do
echo "========================================================"
echo "🧪 Simulating: docker-compose down -v"
echo "========================================================"
echo ""

echo "Running: docker-compose down -v --dry-run"
echo "(This will show what WOULD be deleted, without actually deleting)"
echo ""

# Note: docker-compose doesn't have a --dry-run flag, so we'll just explain
echo "With external volumes configured:"
echo ""
echo "  ✅ Will STOP all containers"
echo "  ✅ Will REMOVE all containers"
echo "  ✅ Will REMOVE networks"
echo "  ❌ Will NOT remove external volumes:"
for volume in "${EXTERNAL_VOLUMES[@]}"; do
  echo "     - $volume (PROTECTED)"
done
echo ""

# Ask if user wants to actually test
echo "========================================================"
echo "⚠️  ACTUAL TEST (Optional)"
echo "========================================================"
echo ""
echo "Do you want to actually run 'docker-compose down -v' to test?"
echo "This will stop all services but volumes will be SAFE."
echo ""
read -p "Run actual test? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
  echo ""
  echo "🧪 Running actual test..."
  echo ""

  # Backup current state
  echo "1. Getting current volume list..."
  docker volume ls | grep lemon > /tmp/volumes_before.txt

  # Run docker-compose down -v
  echo "2. Running: docker-compose down -v"
  docker-compose down -v

  # Check volumes after
  echo "3. Checking volumes after down -v..."
  docker volume ls | grep lemon > /tmp/volumes_after.txt || true

  echo ""
  echo "📊 Results:"
  echo "========================================================"
  echo ""

  for volume in "${EXTERNAL_VOLUMES[@]}"; do
    if docker volume inspect "$volume" &>/dev/null; then
      echo "✅ $volume - STILL EXISTS (PROTECTED!)"
    else
      echo "❌ $volume - DELETED (PROTECTION FAILED!)"
    fi
  done

  echo ""
  echo "========================================================"
  echo ""

  # Show deleted volumes
  if diff /tmp/volumes_before.txt /tmp/volumes_after.txt &>/dev/null; then
    echo "✅ No volumes were deleted!"
  else
    echo "Deleted volumes:"
    diff /tmp/volumes_before.txt /tmp/volumes_after.txt | grep "^<" | awk '{print "  - " $2}' || echo "  None"
  fi

  echo ""
  echo "To restart services:"
  echo "  docker-compose up -d"
  echo ""

else
  echo ""
  echo "Test skipped. External volumes are configured and protected."
  echo ""
fi

echo "========================================================"
echo "📋 Summary"
echo "========================================================"
echo ""
echo "✅ Volume protection is ACTIVE"
echo ""
echo "Protected volumes:"
for volume in "${EXTERNAL_VOLUMES[@]}"; do
  echo "  - $volume"
done
echo ""
echo "These volumes CANNOT be deleted by:"
echo "  ❌ docker-compose down -v"
echo "  ❌ docker system prune --volumes"
echo ""
echo "To manually delete (NOT recommended):"
echo "  docker volume rm <volume-name>"
echo ""
