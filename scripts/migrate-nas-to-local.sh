#!/bin/bash
set -e

PROJECT_DIR="/home/sanchan/lemonkorean"
NAS_BASE="/mnt/nas/lemon"
LOCAL_BASE="$PROJECT_DIR/data"

echo "=== NAS to Local Storage Migration ==="
echo "This will copy data from NAS to local disk"
echo ""

# Create local directories
echo "[1/5] Creating local directories..."
mkdir -p "$LOCAL_BASE/minio-data"
mkdir -p "$LOCAL_BASE/nginx-cache"
mkdir -p "$LOCAL_BASE/nginx-logs"
mkdir -p "$LOCAL_BASE/flutter-build/web"
mkdir -p "$LOCAL_BASE/apk-builds"

# Copy MinIO data
echo "[2/5] Copying MinIO data (~489KB)..."
if [ -d "$NAS_BASE/minio-data" ]; then
  rsync -av --info=progress2 "$NAS_BASE/minio-data/" "$LOCAL_BASE/minio-data/"
  echo "  MinIO data copied"
else
  echo "  Warning: NAS MinIO directory not found, skipping"
fi

# Copy Nginx cache
echo "[3/5] Copying Nginx cache..."
if [ -d "$NAS_BASE/nginx-cache" ]; then
  rsync -av --info=progress2 "$NAS_BASE/nginx-cache/" "$LOCAL_BASE/nginx-cache/"
  echo "  Nginx cache copied"
else
  echo "  Nginx cache directory not found, will be created fresh"
fi

# Copy Nginx logs
echo "[4/5] Copying Nginx logs..."
if [ -d "$NAS_BASE/nginx-logs" ]; then
  rsync -av --info=progress2 "$NAS_BASE/nginx-logs/" "$LOCAL_BASE/nginx-logs/"
  echo "  Nginx logs copied"
else
  echo "  Nginx logs directory not found, will be created fresh"
fi

# Copy APK builds
echo "[5/5] Copying APK builds..."
if [ -d "$NAS_BASE/apk-builds" ]; then
  rsync -av --info=progress2 "$NAS_BASE/apk-builds/" "$LOCAL_BASE/apk-builds/"
  echo "  APK builds copied"
else
  echo "  APK builds directory not found, will be created fresh"
fi

# Set permissions (uid 1000 = sanchan)
echo ""
echo "Setting permissions..."
chown -R 1000:1000 "$LOCAL_BASE"
chmod -R 755 "$LOCAL_BASE"

echo ""
echo "=== Migration Complete ==="
echo "Data copied to: $LOCAL_BASE"
echo ""
echo "Next steps:"
echo "1. Update docker-compose.yml volume mounts"
echo "2. Restart services: docker compose down && docker compose up -d"
