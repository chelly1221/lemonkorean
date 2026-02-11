---
date: 2026-02-11
category: Mobile|Backend|Database
title: 한글 학습 시스템 종합 버그 수정 - SRS, 오프라인 우선, 쉐도잉 UI
author: Claude Opus 4.6
tags: [srs, offline-first, hangul, bugfix, sm-2]
priority: high
---

# 한글 학습 시스템 종합 버그 수정

## 문제 요약

### 1. Backend SRS 치명적 버그 (Critical)
- **`repetition_count` 미저장**: DB에 해당 컬럼이 없어 Go 모델의 `RepetitionCount`가 항상 0 → SM-2 알고리즘이 매번 초기값에서 시작
- **타입 불일치**: `UpdateHangulProgress()`의 로컬 `SRSResult` 타입이 `utils.SRSResult`와 달라 type switch 실패 → 항상 기본값(mastery=1, ef=2.5, interval=1) 사용
- **streak_count INSERT 오류**: 신규 INSERT 시 항상 `streak_count=1` → 오답이어도 streak=1
- **배치 SRS 불일치**: `RecordHangulBatch()`가 단순 `interval*2` 사용 → 단건 SM-2와 결과 다름

### 2. Flutter 오프라인 패턴 미적용 (Critical)
- `recordPractice()`가 API 직접 호출 → 오프라인 시 데이터 유실
- Provider에서 서버 응답의 SRS 필드 미갱신 (mastery_level만 업데이트, 그마저도 타입 오류로 실패)
- `_progress` 리스트와 `_progressMap` 미동기화
- `getStats()` 서버 실패 시 null 반환 → UI 통계 미표시

### 3. 쉐도잉/녹음 UI 미완성 (High)
- "녹음 재생" 버튼 빈 콜백
- `RecordingWidget` 평가 버튼이 부모에게 결과 전달하지 않음
- 하드코딩된 영문 문자열

## 수정 내용

### Phase 1: Backend
- `database/postgres/migrations/015_add_hangul_repetition_count.sql` 생성
- `progress_repository.go`: `utils.SRSResult` 타입으로 type switch 수정, `repetition_count` SELECT/INSERT/UPDATE 추가
- `streak_count` INSERT 시 `isCorrect` 기반 분기 (correct=1, wrong=0)
- `RecordHangulBatch()`를 `utils.CalculateNextReview()` 사용하도록 통일

### Phase 2: Flutter 오프라인 우선
- `hangul_repository.dart`: 로컬 먼저 저장 → API 시도 → 실패 시 sync queue 추가
- `hangul_provider.dart`: 서버 응답의 `srs` 객체에서 전체 SRS 필드 추출, `_progress` 리스트 동기화
- `getStats()`: 서버 실패 시 로컬 progress 데이터로 stats 계산

### Phase 3: UI
- 쉐도잉 화면 "녹음 재생" 버튼 구현 (`_audioPlayer.setFilePath` + `play`)
- `RecordingWidget`에 `onEvaluate` 콜백 추가, 부모와 연결
- `'No characters available'` → `l10n.noCharactersAvailable`

## 수정 파일

| 파일 | 변경 |
|------|------|
| `database/postgres/migrations/015_add_hangul_repetition_count.sql` | 신규 |
| `services/progress/repository/progress_repository.go` | SRS 쿼리/타입/배치 수정 |
| `mobile/.../repositories/hangul_repository.dart` | 오프라인 우선 패턴 |
| `mobile/.../providers/hangul_provider.dart` | SRS 필드 전체 업데이트 |
| `mobile/.../hangul_shadowing_screen.dart` | 녹음 재생, l10n |
| `mobile/.../widgets/recording_widget.dart` | 평가 콜백 |

## 검증 방법

```bash
# DB 마이그레이션 적용
docker compose exec postgres psql -U lemon -d lemonkorean -f /path/to/015_add_hangul_repetition_count.sql

# repetition_count 컬럼 확인
docker compose exec postgres psql -U lemon -d lemonkorean -c "\d hangul_progress"

# Progress 서비스 재빌드/재시작
docker compose up -d --build progress

# Flutter 분석
cd mobile/lemon_korean && flutter analyze
```
