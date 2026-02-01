#!/bin/bash
# CORS Configuration Test Script
# Tests allowed origins for Progress and Media services

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "CORS Configuration Test"
echo "=========================================="
echo ""

# Test function
test_cors() {
    local service=$1
    local endpoint=$2
    local origin=$3
    local expected_origin=$4

    echo -n "Testing ${service} with origin ${origin}... "

    response=$(curl -s -X OPTIONS "http://localhost:${endpoint}" \
        -H "Origin: ${origin}" \
        -H "Access-Control-Request-Method: GET" \
        -v 2>&1)

    if echo "$response" | grep -q "HTTP/1.1 204 No Content"; then
        if echo "$response" | grep -q "Access-Control-Allow-Origin: ${expected_origin}"; then
            echo -e "${GREEN}✓ PASS${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL (wrong origin in response)${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ FAIL (wrong status code)${NC}"
        return 1
    fi
}

# Test Progress Service
echo "--- Progress Service Tests ---"
test_cors "Progress" "3003/api/progress/user/1" "http://localhost" "http://localhost"
test_cors "Progress" "3003/api/progress/user/1" "http://lemon.3chan.kr" "http://lemon.3chan.kr"
echo ""

# Test Media Service
echo "--- Media Service Tests ---"
test_cors "Media" "3004/media/images/test.jpg" "http://localhost" "http://localhost"
test_cors "Media" "3004/media/images/test.jpg" "http://lemon.3chan.kr" "http://lemon.3chan.kr"
echo ""

# Test disallowed origin (should fail)
echo "--- Negative Test (should fail) ---"
echo -n "Testing Progress with disallowed origin http://evil.com... "
response=$(curl -s -X OPTIONS "http://localhost:3003/api/progress/user/1" \
    -H "Origin: http://evil.com" \
    -H "Access-Control-Request-Method: GET" \
    -v 2>&1)

if echo "$response" | grep -q "HTTP/1.1 403 Forbidden"; then
    echo -e "${GREEN}✓ PASS (correctly rejected)${NC}"
else
    echo -e "${YELLOW}⚠ WARNING (should reject unauthorized origins)${NC}"
fi
echo ""

echo "=========================================="
echo "CORS Test Complete"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Open browser DevTools (F12)"
echo "2. Navigate to: https://lemon.3chan.kr/app/"
echo "3. Check Console for CORS errors (should be none)"
echo "4. Check Network tab for API calls"
echo "5. Verify 'Access-Control-Allow-Origin' headers"
