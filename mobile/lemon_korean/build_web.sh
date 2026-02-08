#!/bin/bash
# Flutter Web Build & Deploy Script
# Builds web app and syncs to local data directory for nginx deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="/home/sanchan/lemonkorean"
LOCAL_WEB_DIR="$PROJECT_ROOT/data/flutter-build/web"

cd "$SCRIPT_DIR"

echo "Cleaning previous build..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Building Flutter web app..."
flutter build web --release --base-href /app/ --no-wasm-dry-run

echo "Updating version.json with build timestamp..."
BUILD_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILD_NUMBER=$(($(date +%s) % 100000))
cat > build/web/version.json << EOF
{"app_name":"lemon_korean","version":"1.0.0","build_number":"$BUILD_NUMBER","package_name":"lemon_korean","build_date":"$BUILD_TIMESTAMP"}
EOF

echo "Syncing to local deployment directory..."
mkdir -p "$LOCAL_WEB_DIR"
rsync -av --delete build/web/ "$LOCAL_WEB_DIR/"

echo "Clearing nginx cache..."
cd /home/sanchan/lemonkorean
docker compose exec -T nginx sh -c "rm -rf /var/cache/nginx/* 2>/dev/null || true" || echo "  (Cache already clear or container not running)"

echo "Restarting nginx..."
docker compose restart nginx

echo ""
echo "✅ Done! Web app deployed to https://lemon.3chan.kr/app/"
echo ""
echo "⚠️  IMPORTANT: Users need to hard refresh their browser to see changes:"
echo "   - Chrome/Edge/Firefox: Ctrl+Shift+R (or Cmd+Shift+R on Mac)"
echo "   - Safari: Cmd+Option+R"
echo "   - Or open in Incognito/Private mode"
echo ""
