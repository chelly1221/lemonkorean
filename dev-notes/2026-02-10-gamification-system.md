---
date: 2026-02-10
category: Mobile|Backend|Database
title: Gamification 시스템 구현 - 레몬 수집, 챕터/보스, 레몬 나무
author: Claude Opus 4.6
tags: [gamification, lemons, boss-quiz, admob, adsense, lemon-tree]
priority: high
---

# Gamification 시스템: 레몬 수집 + 챕터/보스 + 프로필 레몬 나무

## 개요
학습 동기 부여와 수익화를 위한 3가지 gamification 시스템을 추가:
1. **레슨 레몬 수집** - 퀴즈 점수 기반 레몬 1~3개 자동 적립
2. **챕터 + 보스 퀴즈** - week 기준 레슨 그룹화, 챕터별 종합 퀴즈
3. **프로필 레몬 나무 + 광고** - 레슨 완료 시 나무에 레몬 생성, 광고 시청으로 수확

## Phase 1: 레몬 수집 시스템

### 핵심 로직
- 레몬 1개: 레슨 완료 (무조건)
- 레몬 2개: 퀴즈 80% 이상
- 레몬 3개: 퀴즈 95% 이상
- 재도전 시 더 높은 점수만 업데이트 (최고 기록 유지)

### 새 파일
- `lib/data/models/lemon_reward_model.dart` - 레슨별 레몬 보상 모델 (Hive 미사용, LocalStorage.saveToBox)
- `lib/presentation/providers/gamification_provider.dart` - 중앙 gamification 상태 관리

### 수정 파일
- `lesson_model.dart` - `week` (HiveField 17), `orderNum` (HiveField 18) 추가
- `lesson_model.g.dart` - Hive 어댑터 업데이트
- `stage7_summary.dart` - XP 카드 → 레몬 3개 아이콘 + 애니메이션으로 교체
- `lesson_path_node.dart` - 완료 노드 하단에 레몬 아이콘 표시
- `lesson_screen.dart` - 레슨 완료 시 레몬 보상 기록
- `main.dart` - GamificationProvider 등록

## Phase 2: 챕터 + 보스 퀴즈

### 챕터 시스템
- DB의 `lessons.week` 필드 활용하여 레슨을 챕터로 그룹화
- `lesson_path_view.dart`에 챕터 헤더와 보스 노드 삽입
- week 데이터 없으면 단일 챕터로 폴백

### 보스 퀴즈
- 챕터 내 모든 레슨 완료 시 잠금 해제
- 기존 레슨 퀴즈 문제를 랜덤 조합 (최대 15문항)
- 70% 이상 통과 시 보너스 레몬 5개

### 새 파일
- `boss_quiz_node.dart` - 보스 퀴즈 노드 (잠금/해제/완료 3상태)
- `boss_quiz_screen.dart` - 보스 퀴즈 화면 (v1/v2 콘텐츠 구조 모두 지원)

## Phase 3: 레몬 나무 + 광고

### 레몬 나무
- 프로필 탭에 `CustomPaint` 기반 나무 위젯
- 10개 레몬 위치 (Offset 배열), 아래→위 순서로 생성
- 탭하여 수확 (광고 시청 후)

### 광고 통합
- **모바일**: `google_mobile_ads` - RewardedAd (테스트 광고 ID 사용 중)
- **웹**: AdSense 스텁 (현재 dev 모드 - 항상 보상 지급)
- 추상 `AdService` 인터페이스로 플랫폼 분기

### 새 파일
- `ad_service.dart` - 광고 통합 인터페이스
- `admob_service.dart` - 모바일 AdMob 서비스
- `adsense_service.dart` - 웹 AdSense 스텁
- `lemon_tree_widget.dart` - 레몬 나무 위젯

### 수정 파일
- `pubspec.yaml` - google_mobile_ads: ^5.2.0
- `AndroidManifest.xml` - AdMob 테스트 앱 ID

## Phase 4: DB 마이그레이션 + 백엔드 API

### 새 테이블
- `lesson_rewards` - 레슨별 레몬 보상 (user_id, lesson_id 유니크)
- `lemon_currency` - 유저별 레몬 잔액
- `lemon_transactions` - 레몬 거래 내역
- `boss_quiz_completions` - 보스 퀴즈 완료 기록

### 새 API (Progress 서비스 3003)
- `POST /api/progress/lesson-reward` - 레슨 레몬 저장 (UPSERT with GREATEST)
- `GET /api/progress/lemon-currency/:userId` - 잔액 조회
- `GET /api/progress/lesson-rewards/:userId` - 보상 목록 조회
- `POST /api/progress/lemon-harvest` - 나무 레몬 수확
- `POST /api/progress/boss-quiz/complete` - 보스 퀴즈 완료

### 새 파일
- `database/postgres/migrations/008_add_gamification_tables.sql`
- `services/progress/handlers/gamification_handler.go`

## Phase 5: 로컬라이제이션

### 추가 l10n 키 (6개 언어)
`chapter`, `bossQuiz`, `bossQuizCleared`, `bossQuizBonus`, `lemonsScoreHint95`, `lemonsScoreHint80`, `myLemonTree`, `harvestLemon`, `watchAdToHarvest`, `lemonHarvested`, `lemonsAvailable`, `completeMoreLessons`, `totalLemons`

## 주의사항
- AdMob App ID는 현재 **테스트 ID** 사용 중 → 프로덕션 전 실제 ID로 교체 필요
- AdSense 웹 통합은 스텁 상태 → JS interop 구현 필요
- DB 마이그레이션(`008_add_gamification_tables.sql`)은 수동 실행 필요
- `week` 필드는 DB에 이미 존재하나 콘텐츠 서비스에서 실제 값 설정 필요
