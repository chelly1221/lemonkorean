#!/bin/bash
# Validate Flutter web build before deployment

set -e

BUILD_DIR="mobile/lemon_korean/build/web"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Validating Flutter web build..."

# Check if build exists
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}✗ Build directory not found${NC}"
    echo "Run: cd mobile/lemon_korean && ./build_web.sh"
    exit 1
fi

# Check base href
if grep -q '<base href="/app/">' "$BUILD_DIR/index.html"; then
    echo -e "${GREEN}✓ Base href correctly set to /app/${NC}"
else
    echo -e "${RED}✗ Base href not set correctly${NC}"
    grep '<base href=' "$BUILD_DIR/index.html"
    exit 1
fi

# Check manifest
if grep -q '"start_url": "/app/"' "$BUILD_DIR/manifest.json"; then
    echo -e "${GREEN}✓ Manifest start_url correct${NC}"
else
    echo -e "${YELLOW}⚠ Manifest start_url may be incorrect${NC}"
fi

# Check main.dart.js exists
if [ -f "$BUILD_DIR/main.dart.js" ]; then
    MAIN_SIZE=$(du -h "$BUILD_DIR/main.dart.js" | cut -f1)
    echo -e "${GREEN}✓ main.dart.js exists ($MAIN_SIZE)${NC}"
else
    echo -e "${RED}✗ main.dart.js not found${NC}"
    exit 1
fi

# Check build size
BUILD_SIZE=$(du -sm "$BUILD_DIR" | cut -f1)
if [ "$BUILD_SIZE" -gt 20 ]; then
    echo -e "${YELLOW}⚠ Build size is large: ${BUILD_SIZE}MB${NC}"
else
    echo -e "${GREEN}✓ Build size acceptable: ${BUILD_SIZE}MB${NC}"
fi

echo ""
echo -e "${GREEN}✅ All validations passed!${NC}"
echo "Deploy with: docker compose restart nginx"
