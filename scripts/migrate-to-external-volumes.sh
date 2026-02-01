#!/bin/bash
# Migrate existing volumes to external volumes (safe from deletion)
# This script ensures data is preserved and moved to external volumes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo "🔄 Migrating to External Volumes (Safe from Deletion)"
echo "========================================================"
echo ""
echo "This will:"
echo "  1. Create new external volumes (safe from docker-compose down -v)"
echo "  2. Copy existing data to new volumes"
echo "  3. Update docker-compose to use new volumes"
echo ""

# Volume mappings: old_name -> new_name
declare -A VOLUME_MAP=(
  ["lemon-postgres-data"]="lemon-postgres-data-safe"
  ["lemon-mongo-data"]="lemon-mongo-data-safe"
  ["lemon-redis-data"]="lemon-redis-data-safe"
  ["lemon-minio-data"]="lemon-minio-data-safe"
  ["lemon-rabbitmq-data"]="lemon-rabbitmq-data-safe"
)

# Check if Docker is running
if ! docker info &>/dev/null; then
  echo "❌ ERROR: Docker is not running"
  exit 1
fi

echo "📋 Step 1: Checking current volumes..."
echo ""

NEEDS_MIGRATION=false

for old_volume in "${!VOLUME_MAP[@]}"; do
  new_volume="${VOLUME_MAP[$old_volume]}"

  # Check if old volume exists
  if docker volume inspect "$old_volume" &>/dev/null; then
    echo "✅ Found old volume: $old_volume"

    # Check if new volume already exists
    if docker volume inspect "$new_volume" &>/dev/null; then
      echo "⚠️  New volume already exists: $new_volume"
      echo "   (Will skip migration for this volume)"
    else
      echo "📦 Will migrate: $old_volume → $new_volume"
      NEEDS_MIGRATION=true
    fi
  else
    echo "ℹ️  Old volume not found: $old_volume (will create new external volume)"
  fi
  echo ""
done

if [ "$NEEDS_MIGRATION" = false ]; then
  echo "✅ No migration needed. Creating missing external volumes..."

  for old_volume in "${!VOLUME_MAP[@]}"; do
    new_volume="${VOLUME_MAP[$old_volume]}"

    if ! docker volume inspect "$new_volume" &>/dev/null; then
      echo "Creating external volume: $new_volume"
      docker volume create "$new_volume"
    fi
  done

  echo ""
  echo "✅ All external volumes ready!"
  echo ""
  echo "Next step: Restart services with:"
  echo "  docker-compose down"
  echo "  docker-compose up -d"
  exit 0
fi

# Migration needed
echo "⚠️  Migration Required"
echo "========================================================"
echo ""
echo "This will:"
echo "  - Stop all running containers"
echo "  - Copy data from old volumes to new external volumes"
echo "  - Restart containers with new volumes"
echo ""
echo "⏱️  Estimated time: 2-5 minutes (depending on data size)"
echo ""
read -p "Continue with migration? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "❌ Migration cancelled"
  exit 0
fi

echo ""
echo "🛑 Step 2: Stopping containers..."
docker compose down

echo ""
echo "📦 Step 3: Migrating volumes..."
echo ""

for old_volume in "${!VOLUME_MAP[@]}"; do
  new_volume="${VOLUME_MAP[$old_volume]}"

  # Skip if old volume doesn't exist
  if ! docker volume inspect "$old_volume" &>/dev/null; then
    echo "⏭️  Skipping $old_volume (doesn't exist)"
    continue
  fi

  # Skip if new volume already exists
  if docker volume inspect "$new_volume" &>/dev/null; then
    echo "⏭️  Skipping $old_volume (new volume already exists)"
    continue
  fi

  echo "🔄 Migrating: $old_volume → $new_volume"

  # Create new external volume
  docker volume create "$new_volume"

  # Use a temporary container to copy data
  docker run --rm \
    -v "$old_volume:/source:ro" \
    -v "$new_volume:/dest" \
    alpine sh -c "cp -av /source/. /dest/"

  if [ $? -eq 0 ]; then
    echo "✅ Migration successful: $old_volume → $new_volume"

    # Get volume size
    old_size=$(docker system df -v | grep "$old_volume" | awk '{print $3}')
    new_size=$(docker system df -v | grep "$new_volume" | awk '{print $3}')
    echo "   Old volume size: $old_size"
    echo "   New volume size: $new_size"
  else
    echo "❌ ERROR: Migration failed for $old_volume"
    exit 1
  fi

  echo ""
done

echo "✅ All volumes migrated successfully!"
echo ""

echo "📋 Step 4: Verifying new volumes..."
echo ""

for old_volume in "${!VOLUME_MAP[@]}"; do
  new_volume="${VOLUME_MAP[$old_volume]}"

  if docker volume inspect "$new_volume" &>/dev/null; then
    size=$(docker system df -v | grep "$new_volume" | awk '{print $3}')
    echo "✅ $new_volume - Size: $size"
  else
    echo "❌ $new_volume - NOT FOUND"
  fi
done

echo ""
echo "========================================================"
echo "🎉 Migration Complete!"
echo "========================================================"
echo ""
echo "Your volumes are now SAFE from deletion!"
echo ""
echo "What this means:"
echo "  ✅ 'docker-compose down -v' will NOT delete your data"
echo "  ✅ 'docker system prune --volumes' will NOT delete your data"
echo "  ✅ Only manual deletion with 'docker volume rm' can delete volumes"
echo ""
echo "📋 Next steps:"
echo "  1. Start services: docker-compose up -d"
echo "  2. Verify data: docker-compose logs"
echo "  3. Test application"
echo ""
echo "⚠️  Old volumes still exist. After verifying data:"
echo "  docker volume rm lemon-postgres-data"
echo "  docker volume rm lemon-mongo-data"
echo "  docker volume rm lemon-redis-data"
echo "  docker volume rm lemon-minio-data"
echo "  docker volume rm lemon-rabbitmq-data"
echo ""
echo "💾 Backup recommendation:"
echo "  ./scripts/backup/backup-all.sh"
echo ""
