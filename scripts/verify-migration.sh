#!/bin/bash
set -e

echo "=== Post-Migration Verification ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

test_check() {
  local name="$1"
  local command="$2"

  echo -n "Testing: $name ... "
  if eval "$command" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((PASSED++))
  else
    echo -e "${RED}✗ FAIL${NC}"
    ((FAILED++))
  fi
}

echo "[1/8] Checking Docker Services"
test_check "All services running" "docker compose ps --format '{{.Status}}' | grep -q 'Up'"
test_check "MinIO healthy" "docker compose ps minio --format '{{.Status}}' | grep -q 'healthy'"
test_check "Nginx healthy" "docker compose ps nginx --format '{{.Status}}' | grep -q 'healthy'"
test_check "Media service healthy" "docker compose ps media-service --format '{{.Status}}' | grep -q 'healthy'"
test_check "Admin service healthy" "docker compose ps admin-service --format '{{.Status}}' | grep -q 'healthy'"

echo ""
echo "[2/8] Checking Local Storage Structure"
test_check "MinIO data directory" "test -d data/minio-data"
test_check "Nginx cache directory" "test -d data/nginx-cache"
test_check "Nginx logs directory" "test -d data/nginx-logs"
test_check "APK builds directory" "test -d data/apk-builds"
test_check "Flutter build directory" "test -d data/flutter-build"

echo ""
echo "[3/8] Checking MinIO Data"
test_check "MinIO bucket exists" "test -d data/minio-data/lemon-korean-media"
test_check "MinIO images directory" "test -d data/minio-data/lemon-korean-media/images"
test_check "Test image exists" "test -d data/minio-data/lemon-korean-media/images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png"

echo ""
echo "[4/8] Checking MinIO Container Access"
test_check "MinIO can read data" "docker exec lemon-minio ls /data/lemon-korean-media > /dev/null 2>&1"
test_check "MinIO health endpoint" "curl -sf http://localhost:9000/minio/health/live > /dev/null"

echo ""
echo "[5/8] Checking Media Service"
test_check "Media service running" "curl -sf http://localhost:3004/health > /dev/null"
test_check "Image accessible (direct)" "docker exec lemon-media-service wget -q -O /dev/null http://localhost:3004/media/images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png"

echo ""
echo "[6/8] Checking Nginx Proxy"
test_check "Nginx health" "curl -sf http://localhost/health > /dev/null"
test_check "Image via Nginx" "curl -sf -I http://localhost/media/images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png | grep -q '200 OK'"
test_check "Nginx cache working" "test -d data/nginx-cache/media"
test_check "Nginx logs writing" "test -s data/nginx-logs/access.log"

echo ""
echo "[7/8] Checking Admin Service"
test_check "Admin service health" "docker exec lemon-admin-service wget -q -O /dev/null http://localhost:3006/health"
test_check "APK accessible in container" "docker exec lemon-admin-service ls /apk-builds/*.apk > /dev/null 2>&1"

echo ""
echo "[8/8] Checking File Permissions"
test_check "MinIO data owned by user" "test $(stat -c '%u' data/minio-data) -eq 1000"
test_check "Nginx cache writable" "test -w data/nginx-cache"
test_check "Nginx logs writable" "test -w data/nginx-logs"

echo ""
echo "=== Summary ==="
echo -e "${GREEN}Passed: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
  echo -e "${RED}Failed: $FAILED${NC}"
  echo ""
  echo -e "${YELLOW}Some checks failed. Review output above.${NC}"
  exit 1
else
  echo -e "${GREEN}All checks passed! Migration successful.${NC}"
fi

echo ""
echo "=== Storage Usage ==="
du -sh data/minio-data data/nginx-cache data/nginx-logs data/apk-builds 2>/dev/null || true

echo ""
echo "=== Migration Complete ==="
echo "✓ MinIO data: $(du -sh data/minio-data 2>/dev/null | cut -f1)"
echo "✓ Nginx cache: $(du -sh data/nginx-cache 2>/dev/null | cut -f1)"
echo "✓ Nginx logs: $(du -sh data/nginx-logs 2>/dev/null | cut -f1)"
echo "✓ APK builds: $(du -sh data/apk-builds 2>/dev/null | cut -f1)"
echo ""
echo "NAS dependency removed successfully!"
