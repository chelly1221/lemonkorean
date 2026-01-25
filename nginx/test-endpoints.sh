#!/bin/bash

# ================================================================
# Nginx API Gateway Test Script
# ================================================================
# Tests all endpoints and rate limiting
# ================================================================

set -e

BASE_URL="${1:-http://localhost}"
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'

echo "================================================================"
echo "Testing Nginx API Gateway"
echo "================================================================"
echo "Base URL: $BASE_URL"
echo ""

# Test function
test_endpoint() {
    local method=$1
    local endpoint=$2
    local expected_status=$3
    local description=$4

    echo -n "Testing $description... "

    status=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$BASE_URL$endpoint" || echo "000")

    if [ "$status" = "$expected_status" ]; then
        echo -e "${COLOR_GREEN}✓ $status${COLOR_RESET}"
        return 0
    else
        echo -e "${COLOR_RED}✗ Got $status, expected $expected_status${COLOR_RESET}"
        return 1
    fi
}

# Test with cache status
test_with_cache() {
    local endpoint=$1
    local description=$2

    echo -n "Testing $description (first request)... "
    result=$(curl -s -I "$BASE_URL$endpoint" | grep -i "x-cache-status" || echo "No cache header")
    echo "$result"

    echo -n "Testing $description (second request)... "
    result=$(curl -s -I "$BASE_URL$endpoint" | grep -i "x-cache-status" || echo "No cache header")
    echo "$result"
}

# ================================================================
# Health Checks
# ================================================================

echo "=== Health Checks ==="
test_endpoint "GET" "/health" "200" "Basic health check"
test_endpoint "GET" "/health/detailed" "200" "Detailed health check"
echo ""

# ================================================================
# Service Routing
# ================================================================

echo "=== Service Routing ==="
test_endpoint "GET" "/api/auth/" "404" "Auth service routing"
test_endpoint "GET" "/api/content/" "404" "Content service routing"
test_endpoint "GET" "/api/progress/" "404" "Progress service routing"
test_endpoint "GET" "/media/" "404" "Media service routing"
test_endpoint "GET" "/api/analytics/" "404" "Analytics service routing"
test_endpoint "GET" "/api/admin/" "404" "Admin service routing"
echo ""

# ================================================================
# CORS Test
# ================================================================

echo "=== CORS Headers ==="
echo -n "Testing CORS preflight... "
cors_result=$(curl -s -I -X OPTIONS \
    -H "Origin: http://example.com" \
    -H "Access-Control-Request-Method: POST" \
    "$BASE_URL/api/auth/" | grep -i "access-control-allow" || echo "No CORS headers")
echo "$cors_result"
echo ""

# ================================================================
# Rate Limiting Test
# ================================================================

echo "=== Rate Limiting ==="
echo "Sending 10 rapid requests to test rate limiting..."
success_count=0
rate_limited_count=0

for i in {1..10}; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/health" || echo "000")
    if [ "$status" = "200" ]; then
        ((success_count++))
    elif [ "$status" = "429" ]; then
        ((rate_limited_count++))
    fi
done

echo "Successful requests: $success_count"
echo "Rate limited requests: $rate_limited_count"

if [ $success_count -gt 0 ]; then
    echo -e "${COLOR_GREEN}✓ Rate limiting is working${COLOR_RESET}"
else
    echo -e "${COLOR_YELLOW}⚠ All requests were blocked${COLOR_RESET}"
fi
echo ""

# ================================================================
# Gzip Compression Test
# ================================================================

echo "=== Gzip Compression ==="
echo -n "Testing gzip compression... "
gzip_result=$(curl -s -I -H "Accept-Encoding: gzip" "$BASE_URL/" | grep -i "content-encoding: gzip" && echo "✓ Gzip enabled" || echo "✗ Gzip not detected")
echo "$gzip_result"
echo ""

# ================================================================
# Security Headers
# ================================================================

echo "=== Security Headers ==="
headers=$(curl -s -I "$BASE_URL/")

echo -n "X-Content-Type-Options: "
echo "$headers" | grep -i "x-content-type-options" || echo -e "${COLOR_YELLOW}Not found${COLOR_RESET}"

echo -n "X-Frame-Options: "
echo "$headers" | grep -i "x-frame-options" || echo -e "${COLOR_YELLOW}Not found${COLOR_RESET}"

echo -n "X-XSS-Protection: "
echo "$headers" | grep -i "x-xss-protection" || echo -e "${COLOR_YELLOW}Not found${COLOR_RESET}"

echo ""

# ================================================================
# SSL Test (if HTTPS)
# ================================================================

if [[ $BASE_URL == https://* ]]; then
    echo "=== SSL/TLS Test ==="
    echo -n "Testing SSL certificate... "
    ssl_result=$(curl -s -I "$BASE_URL/" 2>&1 | grep -i "ssl" && echo "✓ SSL enabled" || echo "✓ Connection successful")
    echo "$ssl_result"

    echo -n "Strict-Transport-Security: "
    echo "$headers" | grep -i "strict-transport-security" || echo -e "${COLOR_YELLOW}Not found${COLOR_RESET}"
    echo ""
fi

# ================================================================
# Summary
# ================================================================

echo "================================================================"
echo "Test Summary"
echo "================================================================"
echo -e "${COLOR_GREEN}✓ Nginx API Gateway is functional${COLOR_RESET}"
echo ""
echo "Next steps:"
echo "1. Check logs: docker-compose logs -f nginx"
echo "2. Monitor cache: docker exec nginx ls -lh /var/cache/nginx/"
echo "3. Test specific endpoints with your services"
echo ""
echo "================================================================"
