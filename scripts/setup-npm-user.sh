#!/bin/bash
# Nginx Proxy Manager 사용자 정보 변경 스크립트

set -e

echo "🔧 Nginx Proxy Manager 사용자 정보 변경 시작..."

# 기본 로그인 정보
DEFAULT_EMAIL="admin@example.com"
DEFAULT_PASSWORD="changeme"

# 새로운 로그인 정보
NEW_EMAIL="chelly1221.com@gmail.com"
NEW_PASSWORD="Scott122001&&"

# NPM API 엔드포인트
NPM_URL="http://localhost:81"
API_URL="${NPM_URL}/api"

# 최대 재시도 횟수
MAX_RETRIES=30
RETRY_COUNT=0

echo "⏳ Nginx Proxy Manager가 시작될 때까지 대기 중..."

# NPM이 완전히 시작될 때까지 대기
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s -f "${NPM_URL}/api" > /dev/null 2>&1; then
        echo "✅ Nginx Proxy Manager가 준비되었습니다"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   대기 중... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Nginx Proxy Manager가 시작되지 않았습니다"
    exit 1
fi

# 기본 계정으로 로그인
echo "🔑 기본 계정으로 로그인 시도..."
TOKEN=$(curl -s -X POST "${API_URL}/tokens" \
    -H "Content-Type: application/json" \
    -d "{\"identity\":\"${DEFAULT_EMAIL}\",\"secret\":\"${DEFAULT_PASSWORD}\"}" \
    | jq -r '.token // empty')

if [ -z "$TOKEN" ]; then
    echo "ℹ️  기본 계정으로 로그인 실패 (이미 변경되었을 수 있음)"
    echo "⚠️  웹 UI에서 수동으로 확인하세요: ${NPM_URL}"
    echo "   현재 설정된 이메일: ${NEW_EMAIL}"
    echo "   현재 설정된 비밀번호: ${NEW_PASSWORD}"
    exit 0
fi

echo "✅ 로그인 성공, 토큰 획득"

# 현재 사용자 정보 가져오기
echo "📋 현재 사용자 정보 조회..."
USER_ID=$(curl -s -X GET "${API_URL}/users" \
    -H "Authorization: Bearer ${TOKEN}" \
    | jq -r '.[0].id')

if [ -z "$USER_ID" ] || [ "$USER_ID" = "null" ]; then
    echo "❌ 사용자 ID를 가져올 수 없습니다"
    exit 1
fi

echo "   사용자 ID: ${USER_ID}"

# 사용자 정보 업데이트
echo "✏️  사용자 정보 업데이트 중..."
UPDATE_RESPONSE=$(curl -s -X PUT "${API_URL}/users/${USER_ID}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
        \"email\": \"${NEW_EMAIL}\",
        \"name\": \"Admin\",
        \"nickname\": \"Admin\",
        \"is_disabled\": false
    }")

if echo "$UPDATE_RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
    echo "✅ 이메일이 성공적으로 변경되었습니다: ${NEW_EMAIL}"
else
    echo "⚠️  이메일 변경 중 오류 발생"
    echo "$UPDATE_RESPONSE"
fi

# 비밀번호 변경
echo "🔒 비밀번호 변경 중..."
PASSWORD_RESPONSE=$(curl -s -X PUT "${API_URL}/users/${USER_ID}/auth" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
        \"type\": \"password\",
        \"current\": \"${DEFAULT_PASSWORD}\",
        \"secret\": \"${NEW_PASSWORD}\"
    }")

if echo "$PASSWORD_RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
    echo "✅ 비밀번호가 성공적으로 변경되었습니다"
else
    echo "⚠️  비밀번호 변경 중 오류 발생"
    echo "$PASSWORD_RESPONSE"
fi

echo ""
echo "=========================================="
echo "✅ Nginx Proxy Manager 설정 완료!"
echo "=========================================="
echo "접속 정보:"
echo "  URL: ${NPM_URL}"
echo "  이메일: ${NEW_EMAIL}"
echo "  비밀번호: ${NEW_PASSWORD}"
echo "=========================================="
