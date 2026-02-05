#!/bin/bash
# Flutter Web Build & Deploy Script
# Builds web app and syncs to NAS for nginx deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAS_WEB_DIR="/mnt/nas/lemon/flutter-build/build/web"

cd "$SCRIPT_DIR"

echo "Building Flutter web app..."
flutter build web --release --no-wasm-dry-run

echo "Syncing to NAS deployment directory..."
rsync -av --delete build/web/ "$NAS_WEB_DIR/"

echo "Restarting nginx..."
cd /home/sanchan/lemonkorean
docker compose restart nginx

echo "Done! Web app deployed to https://lemon.3chan.kr/app/"
