#!/bin/bash
# Test JWT Validation Fix for Progress and Admin Services
# Run after restarting Progress Service: docker compose restart progress-service

set -e

echo "======================================"
echo "JWT VALIDATION FIX - TEST SCRIPT"
echo "======================================"
echo ""

# Step 1: Create a fresh test user and get token
echo "Step 1: Creating test user and getting JWT token..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jwt_fix_test@example.com",
    "password": "test123456",
    "name": "JWT测试",
    "language_preference": "zh"
  }')

echo "$REGISTER_RESPONSE" | head -c 200
echo "..."
echo ""

USER_ID=$(echo "$REGISTER_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
ACCESS_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ Failed to get access token"
  exit 1
fi

echo "✓ User created: ID=$USER_ID"
echo "✓ Token obtained: ${ACCESS_TOKEN:0:50}..."
echo ""

# Save token for manual testing
echo "ACCESS_TOKEN=$ACCESS_TOKEN" > /tmp/jwt_test_token.env
echo "USER_ID=$USER_ID" >> /tmp/jwt_test_token.env

# Step 2: Test Progress Service endpoints
echo "Step 2: Testing Progress Service with JWT token..."
echo "======================================"
echo ""

# Test 2a: Get user progress
echo "Test 2a: GET /api/progress/user/$USER_ID"
PROGRESS_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  "http://localhost:3003/api/progress/user/$USER_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

HTTP_STATUS=$(echo "$PROGRESS_RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
RESPONSE_BODY=$(echo "$PROGRESS_RESPONSE" | grep -v "HTTP_STATUS")

echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_STATUS" == "200" ] || [ "$HTTP_STATUS" == "404" ]; then
  echo "✅ PASS: Progress Service accepted JWT token (HTTP $HTTP_STATUS)"
else
  echo "❌ FAIL: Progress Service rejected JWT token (HTTP $HTTP_STATUS)"
  echo "Expected: 200 or 404 (no progress yet)"
  echo "Got: $HTTP_STATUS"
fi
echo ""

# Test 2b: Complete a lesson
echo "Test 2b: POST /api/progress/complete"
COMPLETE_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  -X POST "http://localhost:3003/api/progress/complete" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d "{
    \"lesson_id\": 1,
    \"quiz_score\": 90,
    \"time_spent\": 1500
  }")

HTTP_STATUS=$(echo "$COMPLETE_RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
RESPONSE_BODY=$(echo "$COMPLETE_RESPONSE" | grep -v "HTTP_STATUS")

echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_STATUS" == "200" ] || [ "$HTTP_STATUS" == "201" ]; then
  echo "✅ PASS: Lesson completion accepted (HTTP $HTTP_STATUS)"
else
  echo "❌ FAIL: Lesson completion rejected (HTTP $HTTP_STATUS)"
fi
echo ""

# Test 2c: Get review schedule
echo "Test 2c: GET /api/progress/review-schedule/$USER_ID"
REVIEW_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  "http://localhost:3003/api/progress/review-schedule/$USER_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

HTTP_STATUS=$(echo "$REVIEW_RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
RESPONSE_BODY=$(echo "$REVIEW_RESPONSE" | grep -v "HTTP_STATUS")

echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_STATUS" == "200" ]; then
  echo "✅ PASS: Review schedule retrieved (HTTP $HTTP_STATUS)"
else
  echo "⚠️  Review schedule endpoint returned HTTP $HTTP_STATUS"
fi
echo ""

# Step 3: Test Admin Service endpoints
echo "Step 3: Testing Admin Service with JWT token..."
echo "======================================"
echo ""

# Test 3a: Get users list (should fail - not admin)
echo "Test 3a: GET /api/admin/users (should return 403 - not admin)"
ADMIN_USERS_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  "http://localhost:3006/api/admin/users?limit=5" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

HTTP_STATUS=$(echo "$ADMIN_USERS_RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
RESPONSE_BODY=$(echo "$ADMIN_USERS_RESPONSE" | grep -v "HTTP_STATUS")

echo "$RESPONSE_BODY" | head -c 200
echo "..."
echo ""

if [ "$HTTP_STATUS" == "403" ]; then
  echo "✅ PASS: Admin endpoint correctly rejected non-admin user (HTTP $HTTP_STATUS)"
elif [ "$HTTP_STATUS" == "200" ]; then
  echo "⚠️  UNEXPECTED: Admin endpoint allowed non-admin user (HTTP $HTTP_STATUS)"
else
  echo "❌ FAIL: Admin endpoint returned unexpected status (HTTP $HTTP_STATUS)"
  echo "Expected: 403 (Forbidden)"
fi
echo ""

# Test 3b: Get analytics
echo "Test 3b: GET /api/admin/analytics/overview (should return 403 - not admin)"
ADMIN_ANALYTICS_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  "http://localhost:3006/api/admin/analytics/overview" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

HTTP_STATUS=$(echo "$ADMIN_ANALYTICS_RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
RESPONSE_BODY=$(echo "$ADMIN_ANALYTICS_RESPONSE" | grep -v "HTTP_STATUS")

echo "$RESPONSE_BODY" | head -c 200
echo ""

if [ "$HTTP_STATUS" == "403" ]; then
  echo "✅ PASS: Analytics endpoint correctly rejected non-admin user (HTTP $HTTP_STATUS)"
elif [ "$HTTP_STATUS" == "200" ]; then
  echo "⚠️  UNEXPECTED: Analytics endpoint allowed non-admin user (HTTP $HTTP_STATUS)"
else
  echo "❌ FAIL: Analytics endpoint returned unexpected status (HTTP $HTTP_STATUS)"
fi
echo ""

# Summary
echo "======================================"
echo "TEST SUMMARY"
echo "======================================"
echo ""
echo "Token saved to: /tmp/jwt_test_token.env"
echo "User ID: $USER_ID"
echo ""
echo "To manually test with this token:"
echo "  source /tmp/jwt_test_token.env"
echo "  curl http://localhost:3003/api/progress/user/\$USER_ID \\"
echo "    -H \"Authorization: Bearer \$ACCESS_TOKEN\""
echo ""
echo "If all tests passed, the JWT validation fix is working! ✅"
echo ""
