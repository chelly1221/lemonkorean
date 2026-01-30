# Analytics Service

Python FastAPI 기반 분석 서비스. 사용자 활동 추적, 학습 패턴 분석, 통계 제공.

## 기능

### 이벤트 로깅
- 사용자 이벤트 MongoDB에 저장
- 실시간 이벤트 추적
- 이벤트 타입별 분류

### 사용자 분석
- 개별 사용자 활동 통계
- 학습 패턴 분석 (시간대별, 요일별)
- 레슨 완료 추이
- 단어 학습 진도

### 전체 통계
- 일일 활성 사용자 (DAU)
- 월간 활성 사용자 (MAU)
- 레슨 완료율
- 평균 퀴즈 점수
- 사용자 유지율 (Retention)

## API 엔드포인트

### 헬스체크
```
GET /health
```

### 이벤트 로깅
```
POST /api/analytics/events
Body: {
  "user_id": 1,
  "event_type": "lesson_start",
  "event_data": {
    "lesson_id": 234,
    "timestamp": "2026-01-28T10:00:00Z"
  }
}
```

### 사용자 활동
```
GET /api/analytics/users/{user_id}/activity?days=7
```

### 학습 패턴
```
GET /api/analytics/users/{user_id}/patterns
```

### 전체 통계
```
GET /api/analytics/stats/overview
GET /api/analytics/stats/dau?days=30
GET /api/analytics/stats/lessons
GET /api/analytics/stats/vocabulary
GET /api/analytics/stats/retention
```

## 로컬 실행

```bash
# 가상환경 생성
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# 환경 변수 설정
cp .env.example .env
# .env 파일 수정

# 실행
python main.py
```

서비스는 http://localhost:3005 에서 실행됩니다.

## Docker 실행

```bash
# 이미지 빌드
docker build -t lemon-korean-analytics .

# 컨테이너 실행
docker run -p 3005:3005 --env-file .env lemon-korean-analytics
```

## 개발

### 의존성 추가
```bash
pip install package-name
pip freeze > requirements.txt
```

### 코드 포맷팅
```bash
pip install black
black main.py
```

## 이벤트 타입

- `lesson_start` - 레슨 시작
- `lesson_complete` - 레슨 완료
- `vocabulary_practice` - 단어 연습
- `quiz_attempt` - 퀴즈 시도
- `quiz_complete` - 퀴즈 완료
- `login` - 로그인
- `logout` - 로그아웃
- `download_lesson` - 레슨 다운로드

## 데이터 소스

### PostgreSQL
- `users` - 사용자 정보
- `user_progress` - 학습 진도
- `learning_sessions` - 세션 데이터
- `vocabulary_progress` - 단어 학습
- `daily_active_users` (뷰) - DAU 데이터
- `user_learning_stats` (뷰) - 사용자 통계

### MongoDB
- `events` 컬렉션 - 이벤트 로그

### Redis
- 캐싱 (선택적)

## 성능 최적화

- 데이터베이스 쿼리 인덱스 활용
- Redis 캐싱으로 반복 쿼리 최적화
- 배치 처리로 대량 데이터 효율적 처리
- 비동기 처리 (향후 추가 예정)

## 모니터링

- Prometheus 메트릭 노출 (향후 추가)
- 로그 수준 설정 가능
- 에러 추적

## 보안

- 환경 변수로 민감 정보 관리
- CORS 설정
- 입력 데이터 검증 (Pydantic)

## 향후 개선 사항

- [ ] Prometheus 메트릭 추가
- [ ] 비동기 배치 처리
- [ ] 캐싱 레이어 강화
- [ ] 머신러닝 기반 학습 추천
- [ ] 실시간 대시보드 WebSocket
