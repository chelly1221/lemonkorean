#!/bin/bash
# Web build script with correct base-href

set -e

echo "🍋 Building Lemon Korean Web App..."

# Navigate to Flutter app directory
cd "$(dirname "$0")"

# Clean previous build
echo "🧹 Cleaning previous build..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for web with correct base-href
echo "🔨 Building web app..."
flutter build web \
  --release \
  --base-href=/ \
  --dart-define=API_URL=https://3chan.kr \
  --dart-define=ENVIRONMENT=production

# Check build output
if [ -d "build/web" ]; then
  BUILD_SIZE=$(du -sh build/web | cut -f1)
  echo "✅ Build complete: $BUILD_SIZE"
  echo "📂 Output: build/web/"
  echo ""
  echo "Next steps:"
  echo "1. Validate: ../../scripts/validate_web_build.sh"
  echo "2. Deploy: cd ../.. && docker compose restart nginx"
else
  echo "❌ Build failed!"
  exit 1
fi
