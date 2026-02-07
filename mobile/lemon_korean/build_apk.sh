#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="/home/sanchan/lemonkorean"
APK_OUTPUT_DIR="$PROJECT_ROOT/data/apk-builds"

cd "$SCRIPT_DIR"

echo "=========================================="
echo "  Lemon Korean APK Build"
echo "=========================================="
echo ""

# Check Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter is not installed or not in PATH"
    exit 1
fi

echo "📦 Building Flutter APK (release mode)..."
echo ""

# Clean previous builds
flutter clean

# Get dependencies
echo "📥 Fetching dependencies..."
flutter pub get

# Build APK
echo "🔨 Building APK..."
flutter build apk --release

# Check if build succeeded
if [ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "❌ Error: APK file not found after build"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$APK_OUTPUT_DIR"

# Generate filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
APK_FILE="lemon_korean_${TIMESTAMP}.apk"
APK_FULL_PATH="$APK_OUTPUT_DIR/$APK_FILE"

# Copy APK to local storage
echo ""
echo "📤 Copying APK to local storage..."
cp build/app/outputs/flutter-apk/app-release.apk "$APK_FULL_PATH"

# Get APK size
APK_SIZE=$(stat -f%z "$APK_FULL_PATH" 2>/dev/null || stat -c%s "$APK_FULL_PATH" 2>/dev/null)
APK_SIZE_MB=$(echo "scale=2; $APK_SIZE / 1024 / 1024" | bc)

echo ""
echo "=========================================="
echo "  ✅ Build Completed Successfully!"
echo "=========================================="
echo "APK Path: $APK_FULL_PATH"
echo "APK Size: ${APK_SIZE_MB} MB"
echo "Filename: $APK_FILE"
echo ""
