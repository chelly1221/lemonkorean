---
date: 2026-02-04
category: Backend
title: 레슨 콘텐츠 누락 문제 해결 - 12개 레슨 콘텐츠 자동 생성
author: Claude Sonnet 4.5
tags: [backend, mongodb, postgresql, content-generation, bug-fix]
priority: high
---

# 레슨 콘텐츠 누락 문제 해결

## 문제 상황

웹 앱에서 "레슨 콘텐츠를 불러올 수 없습니다" 오류가 발생했습니다.

**근본 원인**:
- PostgreSQL에 13개의 published 레슨 메타데이터 존재
- MongoDB에는 **1개 레슨 콘텐츠만 존재** (lesson_id: 4)
- **12개 레슨의 실제 콘텐츠 누락** (lessons 1-3, 5-13)

## 해결 방안

최소 기능 콘텐츠를 자동 생성하여 모든 레슨을 즉시 접근 가능하도록 수정했습니다.

### 1단계: 데이터베이스 시드 적용

#### 1.1 Vocabulary 번역 시드 적용
```bash
docker compose exec -T postgres psql -U 3chan -d lemon_korean -f /docker-entrypoint-initdb.d/06_vocabulary_seed.sql
```

**결과**:
- 48개 단어에 대한 6개 언어 번역 추가 (ko, en, ja, es, zh, zh_TW)
- 총 288개 번역 레코드 생성
- 일부 외래 키 오류 발생 (존재하지 않는 vocab_id=2), 대부분 성공

#### 1.2 Grammar 번역 시드 시도
```bash
docker compose exec -T postgres psql -U 3chan -d lemon_korean -f /docker-entrypoint-initdb.d/07_grammar_seed.sql
```

**결과**:
- grammar_rules 테이블이 비어있어 실패
- 향후 문법 데이터 추가 시 재실행 필요

### 2단계: 레슨-콘텐츠 연결 생성

#### 2.1 Vocabulary 연결 SQL 작성
**파일**: `/home/sanchan/lemonkorean/scripts/seed/link_lesson_vocabulary.sql`

**전략**: 48개 단어를 13개 레슨에 분배
- 기존 vocabulary ID가 불연속적 (1, 14-60)
- Lesson 1-8: 4개 단어씩
- Lesson 9-12: 3개 단어씩
- Lesson 13: 4개 단어 (재사용)

```bash
cat /home/sanchan/lemonkorean/scripts/seed/link_lesson_vocabulary.sql | docker compose exec -T postgres psql -U 3chan -d lemon_korean
```

**결과**:
- 48개 lesson_vocabulary 연결 생성
- 13개 모든 레슨에 단어 할당 완료

### 3단계: MongoDB 콘텐츠 생성

#### 3.1 콘텐츠 생성 스크립트 작성
**파일**: `/home/sanchan/lemonkorean/scripts/seed/generate_minimal_lesson_content.js`

**기능**:
1. PostgreSQL에서 lessons, lesson_vocabulary, vocabulary_translations 조회
2. Lesson 4 구조를 템플릿으로 사용 (version 2.0.0)
3. 각 레슨당 7단계 콘텐츠 생성:
   - Stage 0 (intro): 레슨 제목/설명
   - Stage 1 (vocabulary): PostgreSQL에서 가져온 단어 + 6개 언어 번역
   - Stage 2 (grammar): 빈 배열 (grammar_rules 없음)
   - Stage 3 (practice): 기본 객관식 문제 2개
   - Stage 4 (dialogue): 간단한 2인 대화
   - Stage 5 (quiz): 단어 퀴즈 3개
   - Stage 6 (summary): 학습 요약
4. MongoDB lessons_content 컬렉션에 삽입

**주요 수정 사항**:
- DB 비밀번호: `Scott122001&&` (특수문자 포함)
- 컬럼명: `vocabulary_translations.translation` (text 아님)

#### 3.2 스크립트 실행
```bash
docker cp /home/sanchan/lemonkorean/scripts/seed/generate_minimal_lesson_content.js lemon-content-service:/tmp/generate_minimal_lesson_content.js
docker exec -e NODE_PATH=/app/node_modules lemon-content-service node /tmp/generate_minimal_lesson_content.js
```

**결과**:
```
✓ Lesson 1: 4 words
✓ Lesson 2: 4 words
✓ Lesson 3: 4 words
✓ Lesson 4: Already exists (skipped)
✓ Lesson 5: 4 words
✓ Lesson 6: 4 words
✓ Lesson 7: 4 words
✓ Lesson 8: 4 words
✓ Lesson 9: 3 words
✓ Lesson 10: 3 words
✓ Lesson 11: 3 words
✓ Lesson 12: 3 words
✓ Lesson 13: 4 words

Total lessons with content: 13
```

### 4단계: 캐시 초기화 및 검증

#### 4.1 Redis 캐시 클리어
```bash
docker compose exec -T redis redis-cli -a 'Scott122001' FLUSHDB
```

#### 4.2 검증

**MongoDB 확인**:
```bash
# 13개 레슨 콘텐츠 확인
Total lessons with content: 13
Lesson 1-13: 각 7 stages
```

**API 응답 확인**:
```bash
curl -s 'https://lemon.3chan.kr/api/content/lessons/1' | jq '.lesson.content.stages | length'
# 결과: 7

# Stage types 확인
curl -s 'https://lemon.3chan.kr/api/content/lessons/1' | jq '.lesson.content.stages[].type'
# 결과: intro, vocabulary, grammar, practice, dialogue, quiz, summary

# Vocabulary 단어 확인
curl -s 'https://lemon.3chan.kr/api/content/lessons/1' | jq '.lesson.content.stages[1].data.words[0]'
# 결과: 안녕하세요 (6개 언어 번역 포함)
```

**PostgreSQL 통계**:
```sql
-- Lesson-Vocabulary 연결
SELECT COUNT(*) FROM lesson_vocabulary; -- 48

-- Vocabulary 번역
SELECT language_code, COUNT(*) FROM vocabulary_translations GROUP BY language_code;
-- ko: 48, en: 48, ja: 48, es: 48, zh: 48, zh_TW: 48
```

## 결과

### 성공 기준 달성
- ✅ 13개 모든 레슨의 content 필드가 null이 아님
- ✅ MongoDB lessons_content 컬렉션에 13개 문서 존재
- ✅ API 응답에 content.stages 배열 포함 (각 7개)
- ✅ Flutter 앱에서 "레슨 콘텐츠를 불러올 수 없습니다" 에러 해결 예상
- ✅ 모든 레슨의 7단계 접근 가능
- ✅ 6개 언어 모두 지원 (ko, en, ja, es, zh, zh_TW)

### 사용자 경험 개선
- **이전**: 13개 중 1개 레슨만 접근 가능, 12개는 에러
- **이후**: 13개 모든 레슨 접근 가능, 기본 콘텐츠 제공

### MongoDB 문서 구조 (v2.0.0)
```javascript
{
  lesson_id: Number,
  version: "2.0.0",
  content: {
    stages: [
      {
        id: "stage_timestamp_0",
        type: "intro",
        order: 0,
        data: {
          title: "한글 기초",
          description: "...",
          image_url: null,
          audio_url: null
        }
      },
      {
        id: "stage_timestamp_1",
        type: "vocabulary",
        order: 1,
        data: {
          words: [
            {
              korean: "안녕하세요",
              chinese: "你好",
              english: "Hello",
              japanese: "こんにちは",
              spanish: "Hola",
              traditional_chinese: "你好",
              pinyin: null,
              hanja: null,
              image_url: null,
              audio_url: null,
              part_of_speech: "interjection"
            }
          ]
        }
      },
      // ... stages 2-6
    ]
  },
  updated_at: ISODate
}
```

## 생성된 파일

1. `/home/sanchan/lemonkorean/scripts/seed/link_lesson_vocabulary.sql` - 레슨-단어 연결 SQL
2. `/home/sanchan/lemonkorean/scripts/seed/generate_minimal_lesson_content.js` - MongoDB 콘텐츠 생성 스크립트

## 향후 개선 사항 (Phase 2)

### 1. 고품질 콘텐츠 작성
- 레슨당 8-12개 단어 (상세 설명, 예문, 문화적 맥락)
- 2-3개 문법 포인트 (상세 설명, 비교 언어 분석)
- 5-8개 다양한 연습문제 (객관식, 빈칸, 매칭, 순서 배열)
- 자연스러운 대화 (4-6 교환)
- 포괄적인 퀴즈 (6-10 문제)

### 2. 미디어 제작
- 단어 이미지 (104-156개)
- 음성 녹음 남/여 (동일 개수)
- 대화 음성 (52-78개 파일)
- 썸네일 이미지 (13개)

### 3. Grammar Rules 추가
- grammar_rules 테이블 채우기
- 07_grammar_seed.sql 재실행
- lesson_grammar 연결 생성
- MongoDB 콘텐츠 업데이트

### 4. Admin 대시보드 개선
- 레슨 콘텐츠 편집 UI
- 리치 텍스트 에디터
- 미디어 업로드 통합
- 미리보기 기능

## 기술 상세

### 데이터 흐름
```
PostgreSQL (lessons 테이블)
    ↓ [13개 레슨 메타데이터]

PostgreSQL (vocabulary 48개)
    ↓ [06_vocabulary_seed.sql 적용]
    ↓ [6개 언어 번역 추가]

PostgreSQL (lesson_vocabulary)
    ↓ [link_lesson_vocabulary.sql 적용]
    ↓ [레슨-단어 연결]

MongoDB (lessons_content 컬렉션)
    ↓ [generate_minimal_lesson_content.js 실행]
    ↓ [13개 레슨 콘텐츠 생성]

API (content-service)
    ↓ [GET /api/content/lessons/{id}]
    ↓ [content 필드 반환]

Flutter App
    ↓ [LessonModel.fromJson]
    ✓ 정상 표시
```

### 예외 처리

1. **빈 단어 리스트**: vocabulary stage에 빈 배열 반환, Flutter는 이미 처리 가능
2. **번역 누락**: Fallback chain 사용 (language.middleware.js)
   - 요청 언어 → zh → ko
3. **중복 콘텐츠**: 기존 콘텐츠 존재 시 스킵 (Lesson 4)

### 핵심 파일

**참조 파일**:
- `/home/sanchan/lemonkorean/database/postgres/init/06_vocabulary_seed.sql` - 단어 번역 시드
- `/home/sanchan/lemonkorean/database/postgres/init/07_grammar_seed.sql` - 문법 번역 시드
- `/home/sanchan/lemonkorean/services/content/src/models/lesson.model.js:138-147` - findContentById
- `/home/sanchan/lemonkorean/services/content/src/config/mongodb.js` - MongoDB 연결
- `/home/sanchan/lemonkorean/mobile/lemon_korean/lib/presentation/screens/lesson/lesson_screen.dart:76-88` - 에러 발생 지점

**생성 파일**:
- `/home/sanchan/lemonkorean/scripts/seed/link_lesson_vocabulary.sql` - 레슨-단어 연결
- `/home/sanchan/lemonkorean/scripts/seed/generate_minimal_lesson_content.js` - 콘텐츠 생성

## 테스트 결과

### API 테스트
```bash
# 모든 레슨 stages 확인
Lesson 1: 7 stages, 4 vocabulary words
Lesson 2: 7 stages, 4 vocabulary words
Lesson 3: 7 stages, 4 vocabulary words
Lesson 4: 7 stages, 3 vocabulary words (기존)
Lesson 5: 7 stages, 4 vocabulary words
...
Lesson 13: 7 stages, 4 vocabulary words
```

### 다국어 확인
```json
{
  "korean": "안녕하세요",
  "chinese": "你好",
  "english": "Hello",
  "japanese": "こんにちは",
  "spanish": "Hola",
  "traditional_chinese": "你好",
  "part_of_speech": "interjection"
}
```

## 주의 사항

1. **특수문자 비밀번호**: PostgreSQL 비밀번호에 `&&` 포함
2. **불연속 ID**: Vocabulary ID가 1, 14-60으로 불연속
3. **Grammar 부재**: grammar_rules 테이블 비어있음 (향후 추가 필요)
4. **Placeholder 미디어**: image_url, audio_url은 모두 null (Phase 2에서 추가)

## 영향 범위

- ✅ Backend: MongoDB lessons_content 컬렉션 (13개 문서 추가)
- ✅ Backend: PostgreSQL lesson_vocabulary 테이블 (48개 레코드 추가)
- ✅ Backend: PostgreSQL vocabulary_translations 테이블 (288개 레코드 추가)
- ✅ API: GET /api/content/lessons/{id} 응답 정상화
- ✅ Cache: Redis 캐시 초기화
- ✅ Frontend: Flutter 앱 에러 해결 예상

## 배포 상태

- ✅ 프로덕션 환경에 적용 완료 (https://lemon.3chan.kr)
- ✅ 모든 레슨 접근 가능
- ✅ 다국어 지원 정상 작동

## 마지막 업데이트

2026-02-04
