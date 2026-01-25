# 柠檬韩语 (Lemon Korean) - 프로젝트 가이드

## 프로젝트 개요
중국어 화자를 위한 한국어 학습 앱. 오프라인 학습 지원, 마이크로서비스 아키텍처, 자체 호스팅.

**핵심 특징:**
- 레슨별 다운로드 & 오프라인 학습
- 오프라인 진도 자동 동기화
- 몰입형 풀스크린 학습 경험
- 중국어 화자 맞춤 설계 (한자 연결, 발음 유사도)

---

## 아키텍처
```
Flutter App (오프라인 우선)
    ↕ (필요시에만 동기화)
Nginx (API Gateway)
    ↓
6개 마이크로서비스 (Docker)
    ↓
PostgreSQL + MongoDB + Redis + MinIO
```

### 마이크로서비스
1. **Auth Service** (Node.js:3001) - JWT 인증
2. **Content Service** (Node.js:3002) - 레슨/단어/문법 데이터
3. **Progress Service** (Go:3003) - 학습 진도, SRS 알고리즘
4. **Media Service** (Go:3004) - 이미지/오디오 서빙, MinIO
5. **Analytics Service** (Python:3005) - 로그 분석
6. **Admin Service** (Node.js:3006) - 관리자 대시보드

---

## 기술 스택

### Backend
- **Node.js**: Auth, Content, Admin (Express)
- **Go**: Progress, Media (Gin)
- **Python**: Analytics (FastAPI)

### Database
- **PostgreSQL**: 구조 데이터 (users, lessons, progress)
- **MongoDB**: 콘텐츠 데이터 (JSON), 로그
- **Redis**: 캐시, 실시간 데이터
- **MinIO**: 미디어 파일 (S3 호환)

### Mobile
- **Flutter**: iOS/Android
- **Hive**: 로컬 DB (레슨, 진도)
- **SQLite**: 미디어 파일 매핑
- **Dio**: HTTP 클라이언트

### Infrastructure
- **Docker Compose**: 컨테이너 오케스트레이션
- **Nginx**: API Gateway, Load Balancer, 캐싱
- **RabbitMQ**: 메시지 큐 (비동기 작업)

---

## 핵심 설계 원칙

### 1. 오프라인 우선 (Offline-First)
```
사용자 동작 → 로컬 저장 → 백그라운드 동기화
```
- 모든 레슨 데이터는 다운로드 가능
- 진도는 로컬 우선 저장 → sync_queue에 추가
- 네트워크 복구 시 자동 동기화

### 2. 레슨 패키지 구조
```json
{
  "lesson_id": 234,
  "version": "1.0.0",
  "content": {
    "stage1_intro": {...},
    "stage2_vocabulary": {
      "words": [...],
      "matching_game": {...}
    },
    "stage3_grammar": {...},
    "stage4_practice": {...},
    "stage5_dialogue": {...},
    "stage6_quiz": {...},
    "stage7_summary": {...}
  },
  "media_urls": {
    "images/thumb.jpg": "http://cdn/...",
    "audio/intro.mp3": "http://cdn/..."
  }
}
```

### 3. 동기화 큐
```dart
// 오프라인 동작 → 큐에 추가
LocalStorage.addToSyncQueue(
  SyncItem(
    type: SyncType.lessonComplete,
    data: progress.toJson(),
    createdAt: DateTime.now()
  )
);

// 네트워크 복구 → 자동 동기화
SyncManager.autoSync();
```

---

## 데이터베이스 스키마 (핵심)

### PostgreSQL
```sql
-- 사용자
users (id, email, password_hash, subscription_type, created_at)

-- 레슨 메타데이터
lessons (id, level, title_ko, title_zh, version, status)

-- 단어
vocabulary (id, korean, hanja, chinese, pinyin, similarity_score)

-- 진도
user_progress (user_id, lesson_id, status, quiz_score, completed_at)

-- 동기화 큐 (서버)
sync_queue (user_id, data_type, payload, status)
```

### MongoDB
```javascript
// 레슨 콘텐츠 (크고 복잡한 JSON)
lessons_content {
  lesson_id, version, content: {...}, media_manifest: [...]
}

// 이벤트 로그
events {
  user_id, event_type, event_data, timestamp
}
```

---

## API 엔드포인트 (주요)

### Auth Service
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/refresh
```

### Content Service
```
GET  /api/content/lessons              # 목록
GET  /api/content/lessons/:id          # 상세
GET  /api/content/lessons/:id/download # 다운로드 패키지
POST /api/content/check-updates        # 업데이트 확인
```

### Progress Service
```
GET  /api/progress/user/:userId
POST /api/progress/complete
POST /api/progress/sync                # 오프라인 동기화
GET  /api/progress/review-schedule     # SRS
```

### Media Service
```
GET /media/images/:key
GET /media/audio/:key
```

---

## Flutter 앱 구조
```
lib/
├── core/
│   ├── storage/
│   │   ├── local_storage.dart      # Hive
│   │   └── database_helper.dart    # SQLite
│   ├── network/
│   │   └── api_client.dart         # Dio + 인터셉터
│   └── utils/
│       ├── download_manager.dart   # 레슨 다운로드
│       └── sync_manager.dart       # 자동 동기화
├── data/
│   ├── models/                     # Hive 모델
│   └── repositories/               # API + Local
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── lesson/
│   │   │   ├── lesson_screen.dart  # 풀스크린 컨테이너
│   │   │   └── stages/             # 7개 스테이지
│   │   └── download/
│   └── providers/                  # ChangeNotifier
```

---

## 중요 코드 패턴

### 1. 미디어 로딩 (로컬 우선)
```dart
Future<String> getMediaPath(String remoteKey) async {
  // 1. 로컬에서 찾기
  final localPath = await DatabaseHelper.getLocalPath(remoteKey);
  if (localPath != null) return localPath;

  // 2. 없으면 원격 URL 반환
  return '${ApiConstants.baseUrl}/media/$remoteKey';
}
```

### 2. API 호출 (오프라인 대응)
```dart
Future<LessonModel?> getLesson(int id) async {
  try {
    // 네트워크 시도
    final response = await _dio.get('/api/content/lessons/$id');
    final lesson = LessonModel.fromJson(response.data);

    // 캐시 저장
    await LocalStorage.saveLesson(lesson);
    return lesson;
  } catch (e) {
    // 실패 시 로컬에서
    return LocalStorage.getLesson(id);
  }
}
```

### 3. 진도 저장 (동기화 큐)
```dart
Future<void> completeLesson(int lessonId) async {
  final progress = ProgressModel(
    lessonId: lessonId,
    status: 'completed',
    completedAt: DateTime.now()
  );

  // 로컬 저장
  await LocalStorage.saveProgress(progress);

  // 동기화 큐 추가
  await LocalStorage.addToSyncQueue(
    SyncItem(type: SyncType.lessonComplete, data: progress.toJson())
  );

  // 동기화 시도 (네트워크 있으면)
  await SyncManager.autoSync();
}
```

---

## 환경 변수
```env
# Database
DB_PASSWORD=secure_password
POSTGRES_DB=lemon_korean
POSTGRES_USER=lemon_user

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=secure_key

# API
API_BASE_URL=http://localhost
NODE_ENV=production
```

---

## 실행 방법
```bash
# 1. 서버 시작
cp .env.example .env
# .env 수정
docker-compose up -d

# 2. Flutter 앱
cd mobile/lemon_korean
flutter pub get
flutter run
```

---

## 파일 명명 규칙

### Backend
- `*.controller.js` - 요청 처리
- `*.service.js` - 비즈니스 로직
- `*.model.js` - 데이터 모델
- `*.routes.js` - 라우팅

### Flutter
- `*_screen.dart` - 화면
- `*_provider.dart` - 상태 관리
- `*_model.dart` - 데이터 모델
- `*_repository.dart` - 데이터 계층
- `*_widget.dart` - 재사용 위젯

---

## 주의사항

### 보안
- 모든 비밀번호는 bcrypt 해싱
- JWT 토큰은 secure_storage에만 저장
- API는 rate limiting 적용
- 관리자 API는 IP 화이트리스트 (선택)

### 성능
- 이미지는 WebP 변환 + 캐싱
- 레슨 목록은 Redis 캐싱 (1시간)
- 미디어는 Nginx에서 7일 캐싱
- Flutter는 image cache 50MB

### 오프라인
- 모든 사용자 동작은 로컬 우선 저장
- sync_queue가 100개 넘으면 경고
- 30일 이상 동기화 안 된 항목은 삭제

---

## 트러블슈팅

### Docker 문제
```bash
# 포트 충돌
docker-compose down
sudo lsof -i :5432  # 점유 프로세스 확인

# 볼륨 초기화
docker-compose down -v
docker-compose up -d
```

### Flutter 빌드 오류
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### 데이터베이스 리셋
```bash
docker-compose down -v
docker-compose up -d postgres
docker-compose exec postgres psql -U lemon_user -d lemon_korean -f /init/01_schema.sql
```

---

## 다음 단계

1. **Phase 1**: Auth + Content Service 구현
2. **Phase 2**: Progress Service + 동기화
3. **Phase 3**: Flutter 기본 화면
4. **Phase 4**: 레슨 스테이지 구현
5. **Phase 5**: 관리자 대시보드
6. **Phase 6**: 프로덕션 배포

---

**참고**: 이 문서는 개발 가이드입니다. 각 단계별 상세 구현은 INSTRUCTIONS.md 참고.
