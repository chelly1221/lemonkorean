# Testing Guide

테스트 전략 및 실행 가이드.

## 개요

Lemon Korean 프로젝트는 다음 테스트 프레임워크를 사용합니다:

- **Node.js 서비스**: Jest + Supertest
- **Go 서비스**: Go testing package + testify
- **Python 서비스**: pytest + httpx
- **Flutter 앱**: Flutter test framework

## Node.js 서비스 테스트

### Auth Service

```bash
cd services/auth

# 의존성 설치
npm install

# 테스트 실행
npm test

# Watch 모드
npm run test:watch

# 커버리지 리포트
npm run test:coverage
```

### Content Service

```bash
cd services/content
npm install
npm test
```

### Admin Service

```bash
cd services/admin
npm install
npm test
```

## Python 서비스 테스트

### Analytics Service

```bash
cd services/analytics

# 가상환경 생성 (옵션)
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 테스트 실행
pytest

# Verbose 출력
pytest -v

# 커버리지
pytest --cov=. --cov-report=html
```

## Go 서비스 테스트

### Progress Service

```bash
cd services/progress

# 의존성 설치 (필요시)
go mod download

# 테스트 실행
go test ./...

# Verbose 출력
go test -v ./...

# 커버리지
go test -cover ./...

# 커버리지 리포트 생성
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html
```

### Media Service

```bash
cd services/media
go test -v ./...
```

## Flutter 앱 테스트

```bash
cd mobile/lemon_korean

# 유닛 테스트
flutter test

# 통합 테스트
flutter test integration_test/

# 커버리지
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 통합 테스트 (E2E)

```bash
# 모든 서비스 시작
docker-compose up -d

# E2E 테스트 실행
cd tests/e2e
npm install
npm test

# 특정 시나리오만 실행
npm test -- --spec="auth-flow"
```

## CI/CD 자동 테스트

GitHub Actions를 통해 자동으로 실행됩니다:

- PR 생성 시: 전체 테스트 스위트
- main 브랜치 push: 전체 테스트 + 배포

## 테스트 작성 가이드

### Node.js (Jest)

```javascript
describe('Feature Name', () => {
  it('should do something', async () => {
    const result = await someFunction();
    expect(result).toBe(expectedValue);
  });
});
```

### Python (pytest)

```python
class TestFeature:
    """Feature tests"""

    def test_something(self):
        """Test description"""
        result = some_function()
        assert result == expected_value
```

### Go (testing)

```go
func TestFeature(t *testing.T) {
    result := SomeFunction()
    assert.Equal(t, expectedValue, result)
}
```

## 테스트 데이터베이스 설정

### PostgreSQL 테스트 DB

```bash
# 테스트 데이터베이스 생성
docker exec lemon-postgres createdb -U 3chan lemon_korean_test

# 스키마 적용
docker exec lemon-postgres psql -U 3chan -d lemon_korean_test \
  -f /docker-entrypoint-initdb.d/01_schema.sql
```

### 환경 변수 (.env.test)

```bash
# 테스트용 환경 변수
DB_NAME=lemon_korean_test
REDIS_HOST=localhost
REDIS_PORT=6380  # 별도 Redis 인스턴스
```

## 모의 객체 (Mocking)

### Node.js

```javascript
// Redis mock
jest.mock('redis', () => ({
  createClient: jest.fn().mockReturnValue({
    connect: jest.fn(),
    get: jest.fn(),
    set: jest.fn()
  })
}));
```

### Python

```python
from unittest.mock import Mock, patch

@patch('pymongo.MongoClient')
def test_with_mock_mongo(mock_mongo):
    # Test code
    pass
```

### Go

```go
// Interface-based mocking
type MockDB struct{}

func (m *MockDB) Query(query string) (*sql.Rows, error) {
    // Mock implementation
    return nil, nil
}
```

## 테스트 커버리지 목표

| 서비스 | 현재 커버리지 | 목표 |
|--------|-------------|------|
| Auth | 0% | 80% |
| Content | 0% | 80% |
| Progress | 0% | 75% |
| Media | 0% | 75% |
| Analytics | 0% | 70% |
| Admin | 0% | 70% |
| Flutter App | 0% | 60% |

## 문제 해결

### Jest "Cannot find module" 오류

```bash
npm install --save-dev @types/jest
```

### Go test timeout

```bash
go test -timeout 30s ./...
```

### Python import 오류

```bash
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
pytest
```

### Docker 컨테이너 테스트 충돌

```bash
# 테스트 전 기존 컨테이너 정리
docker-compose down
docker-compose up -d postgres redis mongo
```

## 베스트 프랙티스

### 1. 테스트 격리
- 각 테스트는 독립적으로 실행 가능해야 함
- 테스트 간 데이터 공유 금지
- Setup/Teardown 활용

### 2. 명확한 테스트 이름
```javascript
// Good
it('should return 401 when user is not authenticated')

// Bad
it('test1')
```

### 3. AAA 패턴
```javascript
it('should calculate total price', () => {
  // Arrange
  const items = [{ price: 10 }, { price: 20 }];

  // Act
  const total = calculateTotal(items);

  // Assert
  expect(total).toBe(30);
});
```

### 4. 엣지 케이스 테스트
- 빈 입력
- null/undefined
- 경계값
- 예외 상황

### 5. 테스트 속도 최적화
- 유닛 테스트는 빠르게 (< 100ms)
- 통합 테스트는 필요한 것만
- E2E 테스트는 최소화

## 지속적 개선

- [ ] 모든 서비스에 기본 테스트 추가
- [ ] 커버리지 80% 달성
- [ ] E2E 테스트 시나리오 확장
- [ ] 성능 테스트 추가
- [ ] 보안 테스트 자동화

## 참고 자료

- [Jest Documentation](https://jestjs.io/)
- [pytest Documentation](https://docs.pytest.org/)
- [Go Testing](https://golang.org/pkg/testing/)
- [Flutter Testing](https://flutter.dev/docs/testing)

## 문의

테스트 관련 문의:
- GitHub Issues
- 기술 문서: `/docs/testing.md`
