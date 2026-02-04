# Lemon Korean - Content Service

Lemon Korean 플랫폼의 콘텐츠 관리 서비스 - 레슨, 단어, 문법을 처리합니다.

## 기능

- **레슨 관리**: 메타데이터 및 전체 콘텐츠를 포함한 레슨 CRUD 작업
- **단어 관리**: 한자 지원을 포함한 한국어-중국어 단어 매핑
- **문법 규칙**: 중국어 비교를 포함한 문법 패턴
- **레슨 패키저**: 다운로드 가능한 레슨 패키지 생성 (ZIP)
- **멀티 데이터베이스**: 메타데이터는 PostgreSQL, 콘텐츠는 MongoDB, 캐싱은 Redis
- **오프라인 지원**: 업데이트 확인, 레슨 패키지 다운로드

## 기술 스택

- **런타임**: Node.js 20
- **프레임워크**: Express.js
- **데이터베이스**:
  - PostgreSQL: 레슨 메타데이터, 단어, 문법
  - MongoDB: 레슨 콘텐츠 (대용량 JSON)
  - Redis: 캐싱
- **추가**: archiver (ZIP 생성)

## 환경 변수

```env
NODE_ENV=production
PORT=3002

# PostgreSQL
DATABASE_URL=postgres://user:password@postgres:5432/lemon_korean

# MongoDB
MONGO_URL=mongodb://admin:password@mongo:27017/lemon_korean?authSource=admin

# Redis (Optional)
REDIS_URL=redis://:password@redis:6379
```

## 설치

```bash
# 의존성 설치
npm install

# 개발 모드
npm run dev

# 프로덕션 모드
npm start
```

## API 엔드포인트

### 헬스 체크

- `GET /health` - 서비스 상태 확인

### 레슨

- `GET /api/content/lessons` - 모든 레슨 조회
- `GET /api/content/lessons/level/:level` - 레벨별 레슨 조회
- `GET /api/content/lessons/:id` - 레슨 상세 조회 (메타데이터 + 콘텐츠)
- `GET /api/content/lessons/:id/version` - 레슨 버전 확인
- `GET /api/content/lessons/:id/package` - 레슨 패키지 메타데이터
- `GET /api/content/lessons/:id/download` - 레슨 패키지 다운로드 (ZIP)
- `POST /api/content/lessons/check-updates` - 레슨 업데이트 확인

### 단어

- `GET /api/content/vocabulary` - 모든 단어 조회
- `GET /api/content/vocabulary/search?q=term` - 단어 검색
- `GET /api/content/vocabulary/stats` - 단어 통계 조회
- `GET /api/content/vocabulary/high-similarity` - 고유사도 단어 조회
- `GET /api/content/vocabulary/level/:level` - 레벨별 단어 조회
- `GET /api/content/vocabulary/:id` - ID로 단어 조회

### 문법

- `GET /api/content/grammar` - 모든 문법 규칙 조회
- `GET /api/content/grammar/categories` - 문법 카테고리 조회
- `GET /api/content/grammar/level/:level` - 레벨별 문법 조회
- `GET /api/content/grammar/:id` - ID로 문법 규칙 조회

### Hangul 자모 (2026-02-03)

- `GET /api/content/hangul/characters` - 모든 자모 조회 (타입별 필터링 가능)
- `GET /api/content/hangul/characters/:id` - 발음 가이드를 포함한 자모 상세 조회
- `GET /api/content/hangul/characters/type/:type` - 타입별 자모 조회
- `GET /api/content/hangul/table` - 정리된 한글 자모표
- `GET /api/content/hangul/stats` - 자모 통계
- `GET /api/content/hangul/pronunciation-guides` - 모든 발음 가이드
- `GET /api/content/hangul/pronunciation-guides/:characterId` - 특정 자모 발음 가이드
- `GET /api/content/hangul/syllables` - 음절 조합 (초성/중성/종성 필터 가능)
- `GET /api/content/hangul/similar-sounds` - 유사음 그룹 (소리 구분 훈련용)

## Docker

### 빌드

```bash
docker build -t lemon-content-service:latest .
```

### 실행

```bash
docker run -d \
  --name lemon-content \
  -p 3002:3002 \
  --env-file .env \
  lemon-content-service:latest
```

### Docker Compose 사용

```bash
docker-compose up content-service
```

## 프로젝트 구조

```
content/
├── src/
│   ├── config/
│   │   ├── database.js       # PostgreSQL
│   │   ├── mongodb.js        # MongoDB
│   │   └── redis.js          # Redis
│   ├── controllers/
│   │   ├── lessons.controller.js
│   │   ├── vocabulary.controller.js
│   │   └── grammar.controller.js
│   ├── models/
│   │   ├── lesson.model.js
│   │   └── vocabulary.model.js
│   ├── routes/
│   │   ├── lessons.routes.js
│   │   ├── vocabulary.routes.js
│   │   └── grammar.routes.js
│   ├── services/
│   │   └── lesson-packager.service.js
│   └── index.js
├── Dockerfile
├── package.json
└── README.md
```

## 라이선스

MIT
