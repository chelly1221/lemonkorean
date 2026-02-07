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
flutter build web --release --no-wasm-dry-run

echo "Syncing to local deployment directory..."
mkdir -p "$LOCAL_WEB_DIR"
rsync -av --delete build/web/ "$LOCAL_WEB_DIR/"

echo "Restarting nginx..."
cd /home/sanchan/lemonkorean
docker compose restart nginx

echo "Done! Web app deployed to https://lemon.3chan.kr/app/"
