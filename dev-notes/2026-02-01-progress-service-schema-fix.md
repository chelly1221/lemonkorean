---
date: 2026-02-01
category: Database
title: Progress Service 데이터베이스 스키마 불일치 수정
author: Claude Opus 4.5
tags: [bugfix, database, progress-service, schema]
priority: high
---

# Progress Service 데이터베이스 스키마 불일치 수정

## 개요
Progress Service에서 500 Internal Server Error가 발생하는 문제를 수정했습니다. 원인은 데이터베이스 컬럼명과 Go 코드에서 사용하는 컬럼명의 불일치였습니다.

## 문제/배경
Progress Service의 모든 API 엔드포인트에서 500 에러가 발생했습니다:

**에러 메시지**:
```
pq: column "time_spent_minutes" does not exist
pq: column "last_accessed_at" does not exist
```

**불일치 원인**:
| 데이터베이스 컬럼명 | Go 코드에서 사용하는 컬럼명 |
|------------------|--------------------------|
| `time_spent_seconds` | `time_spent_minutes` |
| `last_accessed` | `last_accessed_at` |

## 해결/구현
데이터베이스 컬럼명을 Go 코드와 일치하도록 변경했습니다. Go 코드를 수정하는 대신 데이터베이스를 수정한 이유:
- Go 코드와 API 계약이 이미 `time_spent_minutes`와 `last_accessed_at` 사용
- Flutter 클라이언트도 JSON에서 동일한 필드명 기대
- 코드 변경량 최소화
- 현재 저장된 값이 작거나 0이므로 데이터 마이그레이션 불필요

**실행한 SQL 명령**:
```sql
-- 컬럼 이름 변경
ALTER TABLE user_progress RENAME COLUMN time_spent_seconds TO time_spent_minutes;
ALTER TABLE user_progress RENAME COLUMN last_accessed TO last_accessed_at;

-- 인덱스 이름도 함께 변경
ALTER INDEX idx_user_progress_last_accessed RENAME TO idx_user_progress_last_accessed_at;

-- 뷰 재생성
DROP VIEW IF EXISTS user_learning_stats;
CREATE VIEW user_learning_stats AS
SELECT
    u.id AS user_id,
    u.email,
    COUNT(DISTINCT up.lesson_id) FILTER (WHERE up.status = 'completed') AS lessons_completed,
    COUNT(DISTINCT vp.vocab_id) FILTER (WHERE vp.mastery_level >= 3) AS words_mastered,
    ROUND(AVG(up.quiz_score), 2) AS avg_quiz_score,
    SUM(up.time_spent_minutes) AS total_study_time_minutes,
    MAX(up.last_accessed_at) AS last_study_date,
    COUNT(DISTINCT DATE(ls.started_at)) AS study_days_count
FROM users u
LEFT JOIN user_progress up ON u.id = up.user_id
LEFT JOIN vocabulary_progress vp ON u.id = vp.user_id
LEFT JOIN learning_sessions ls ON u.id = ls.user_id
GROUP BY u.id, u.email;
```

## 변경된 파일

### 데이터베이스 (런타임)
- `user_progress` 테이블 컬럼명 변경
- `idx_user_progress_last_accessed_at` 인덱스명 변경
- `user_learning_stats` 뷰 재생성

### 스키마 파일 (향후 배포용)
- `/database/postgres/init/01_schema.sql` - 컬럼명 및 인덱스명 수정
- `/database/postgres/init/02_seed.sql` - 샘플 데이터 INSERT 문 수정

## 코드 예시

### Before (01_schema.sql)
```sql
CREATE TABLE user_progress (
    ...
    time_spent_seconds INTEGER DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ...
);
CREATE INDEX idx_user_progress_last_accessed ON user_progress(last_accessed DESC);
```

### After (01_schema.sql)
```sql
CREATE TABLE user_progress (
    ...
    time_spent_minutes INTEGER DEFAULT 0,
    last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ...
);
CREATE INDEX idx_user_progress_last_accessed_at ON user_progress(last_accessed_at DESC);
```

## 테스트

### API 테스트
```bash
# 토큰 획득
TOKEN=$(curl -s -X POST https://lemon.3chan.kr/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123","name":"Test"}' | jq -r '.accessToken')

# Progress API 테스트 - 200 OK 확인
curl -H "Authorization: Bearer $TOKEN" https://lemon.3chan.kr/api/progress/user/1

# Stats API 테스트 - 200 OK 확인
curl -H "Authorization: Bearer $TOKEN" https://lemon.3chan.kr/api/progress/stats/1
```

### 결과
- `/api/progress/user/{id}`: 200 OK (이전: 500 Error)
- `/api/progress/stats/{id}`: 200 OK (이전: 500 Error)
- 웹 앱 홈 화면: 정상 로드

## 관련 이슈/참고사항
- 이 문제로 인해 웹 앱 홈 화면에서 학습 통계가 로드되지 않았습니다
- 스키마 파일도 함께 수정하여 향후 새 배포 시 동일한 문제가 발생하지 않도록 했습니다
- 시드 데이터의 `time_spent` 값도 초(seconds)에서 분(minutes)으로 변환했습니다 (예: 1500초 → 25분)
