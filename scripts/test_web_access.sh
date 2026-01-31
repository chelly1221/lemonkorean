#!/bin/bash
# Test script for verifying Flutter web app access
# Tests both development (port 3007) and production (/app/) environments

set -e

echo "🧪 Testing Flutter Web App Access"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test URLs
DEV_URL="http://3chan.kr:3007"
PROD_URL="https://3chan.kr/app/"

# Function to test URL
test_url() {
    local url=$1
    local description=$2

    echo -e "${YELLOW}Testing: ${description}${NC}"
    echo "URL: $url"

    # Test main page
    response=$(curl -s -k -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ Main page: 200 OK${NC}"
    else
        echo -e "${RED}✗ Main page: $response (Expected 200)${NC}"
    fi

    # Determine protocol based on URL
    local protocol="http"
    if echo "$url" | grep -q "https://"; then
        protocol="https"
    fi

    # Test flutter_bootstrap.js
    response=$(curl -s -k -o /dev/null -w "%{http_code}" "${protocol}://3chan.kr/flutter_bootstrap.js")
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ flutter_bootstrap.js: 200 OK${NC}"
    else
        echo -e "${RED}✗ flutter_bootstrap.js: $response (Expected 200)${NC}"
    fi

    # Test main.dart.js
    response=$(curl -s -k -o /dev/null -w "%{http_code}" "${protocol}://3chan.kr/main.dart.js")
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ main.dart.js: 200 OK${NC}"
    else
        echo -e "${RED}✗ main.dart.js: $response (Expected 200)${NC}"
    fi

    # Test flutter.js
    response=$(curl -s -k -o /dev/null -w "%{http_code}" "${protocol}://3chan.kr/flutter.js")
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓ flutter.js: 200 OK${NC}"
    else
        echo -e "${RED}✗ flutter.js: $response (Expected 200)${NC}"
    fi

    echo ""
}

# Test development environment
echo "Test 1: Development Environment (Port 3007)"
echo "--------------------------------------------"
test_url "$DEV_URL" "Development Server"

# Test production environment
echo "Test 2: Production Environment (/app/)"
echo "---------------------------------------"
test_url "$PROD_URL" "Production Location"

# Verify base href in built index.html
echo "Test 3: Build Configuration"
echo "----------------------------"
BASE_HREF=$(grep '<base href' /home/sanchan/lemonkorean/mobile/lemon_korean/build/web/index.html)
echo "Base href in index.html: $BASE_HREF"
if echo "$BASE_HREF" | grep -q 'href="/"'; then
    echo -e "${GREEN}✓ Base href is correctly set to root (/)${NC}"
else
    echo -e "${RED}✗ Base href is not set to root${NC}"
fi
echo ""

# Summary
echo "=================================="
echo "🎯 Manual Verification Steps:"
echo ""
echo "1. Open browser and visit:"
echo "   - Dev: http://3chan.kr:3007"
echo "   - Prod: https://3chan.kr/app/"
echo ""
echo "2. Open DevTools Console (F12) and verify:"
echo "   - No 404 errors for static resources"
echo "   - Resources load from: /flutter_bootstrap.js (root path)"
echo ""
echo "3. Check Network tab:"
echo "   - All JS/CSS files return 200 OK"
echo "   - Resources load from root (/) not (/app/)"
echo ""
echo "4. Test SPA routing:"
echo "   - Navigate to different app routes"
echo "   - Refresh browser on non-root routes"
echo "   - Verify no 404 errors"
echo ""
echo "=================================="
