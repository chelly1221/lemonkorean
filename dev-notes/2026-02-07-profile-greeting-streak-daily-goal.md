---
date: 2026-02-07
category: Mobile
title: 프로필 탭에 인사말, 연속일수, 일일 목표 이동
author: Claude Sonnet 4.5
tags: [flutter, ui-ux, profile, home-screen]
priority: medium
---

# 프로필 탭에 인사말, 연속일수, 일일 목표 이동

## 개요

홈 화면에 있던 사용자 맞춤 요소(인사말, 연속일수 배지, 일일 목표 진행도)를 프로필 탭으로 이동하여 홈 화면은 학습 콘텐츠에 집중하고, 프로필 탭은 개인 통계 및 동기 부여 요소를 중앙화했습니다.

## 변경 사항

### 1. 홈 탭에서 제거된 요소

**파일**: `/mobile/lemon_korean/lib/presentation/screens/home/home_screen.dart`

**제거된 위젯**:
- `UserHeader` - 시간대별 인사말 + 사용자명 + 연속일수 배지
- `DailyGoalCard` - 일일 목표 진행도 카드

**제거된 상태 변수**:
- `_streakDays` - 연속 학습 일수
- `_todayProgress` - 오늘의 진행도 (0.0-1.0)
- `_completedToday` - 오늘 완료한 레슨 수
- `_targetLessons` - 목표 레슨 수 (3개)

**제거된 메서드**:
- `_calculateStreakDays()` - 진행도 데이터에서 연속일수 계산
- 일일 목표 관련 계산 로직 (`_updateProgressStats()` 메서드에서 제거)

**제거된 임포트**:
- `import 'widgets/user_header.dart';`

### 2. 프로필 탭에 추가된 요소

**파일**: 동일 (`home_screen.dart` 내 `_ProfileTabState`)

**추가된 상태 변수**:
```dart
int _streakDays = 0;
double _todayProgress = 0.0;
int _completedToday = 0;
final int _targetLessons = 3;
```

**추가된 메서드**:

1. **`_calculateStreakDays()`**: 홈 탭에서 이동 (동일 로직)
   - 완료된 레슨 데이터에서 연속 학습 일수 계산
   - 오늘 또는 어제 활동이 없으면 연속일수는 0
   - 연속된 날짜만 카운트

2. **`_updateDailyStats()`**: 새로 생성
   - `ProgressProvider`에서 진행도 데이터 가져오기
   - 오늘 완료한 레슨 수 계산
   - 연속일수 및 일일 진행도 업데이트
   - `_loadStats()` 메서드에서 호출

3. **`_buildGreetingStreak()`**: 새로 생성
   - 시간대별 인사말 표시 (아침/오후/저녁)
   - 사용자명 표시
   - 연속일수 배지 (불꽃 아이콘)
   - 카드 레이아웃으로 구성

**위젯 배치**:
프로필 헤더(아바타, 이름, 이메일, 멤버십 상태) 바로 아래에 삽입:

```
프로필 화면 레이아웃:
┌─────────────────────────┐
│ 프로필 헤더              │ (기존: 아바타, 이름, 이메일)
├─────────────────────────┤
│ 인사말 + 연속일수        │ ← 새로 추가
│ 일일 목표 진행도         │ ← 새로 추가
├─────────────────────────┤
│ 학습 통계                │ (기존: 완료 레슨, 학습일수 등)
└─────────────────────────┘
```

### 3. UI 디자인

**인사말 + 연속일수 카드**:
- 왼쪽: 시간대별 인사말 + 사용자명 (세로 배치)
- 오른쪽: 연속일수 배지
  - 불꽃 아이콘 (`Icons.local_fire_department`)
  - 연속일수 숫자 (큰 글씨, 주황색)
  - "일" 텍스트 (작은 글씨)
  - 주황색 배경 (`Colors.orange.shade50`)
  - 주황색 테두리 (`Colors.orange.shade200`)

**일일 목표 카드**:
- 기존 `DailyGoalCard` 위젯 재사용
- 진행도 바 + "오늘 X개 완료" 텍스트
- 목표 달성 시 축하 메시지

## 정보 아키텍처 개선

### Before (기존):
- **홈 탭**: 인사말 + 연속일수 + 일일 목표 + 레슨 카드
- **프로필 탭**: 학습 통계 + 설정

### After (변경 후):
- **홈 탭**: 레슨 카드만 표시 (학습 콘텐츠에 집중)
- **프로필 탭**: 개인 정보 → 동기 부여 → 통계 (자연스러운 흐름)

## 기술적 세부사항

### 상태 관리
- 로컬 상태 사용 (`_ProfileTabState` 내부)
- 데이터 소스: `ProgressProvider.progressList`
- 계산: 로컬에서 수행 (연속일수, 오늘 완료 수, 진행도 비율)
- 새로운 프로바이더 메서드 불필요

### 성능 영향
- 계산은 경량 (오버헤드 최소)
- 프로필 탭 진입 시에만 계산 수행
- 불필요한 재계산 방지 (`setState` 최소화)

### 다국어 지원
기존 번역 문자열 사용 (새 번역 불필요):
- `goodMorning`, `goodAfternoon`, `goodEvening`
- `days`
- `user`
- `dailyGoal`, `lessonsCompletedCount`, `dailyGoalComplete`

## 테스트 시나리오

### 수동 테스트 완료:
1. ✅ 프로필 탭 진입 → 인사말, 사용자명, 연속일수 표시 확인
2. ✅ 시간대별 인사말 변화 확인 (아침/오후/저녁)
3. ✅ 일일 목표 진행도 표시 확인
4. ✅ 레슨 완료 후 프로필 탭 재진입 → 카운터 증가 확인
5. ✅ 홈 탭에 인사말/연속일수 없음 확인
6. ✅ Flutter 분석기 통과 (오류 없음)

### Edge Cases:
- 새 사용자 (연속일수 0)
- 일일 목표 달성 (3개 이상)
- 오늘 완료한 레슨 없음
- 6개 언어 모두에서 번역 확인

## 파일 변경 내역

**수정된 파일**:
- `/mobile/lemon_korean/lib/presentation/screens/home/home_screen.dart`

**변경 사항**:
- 라인 수: ~1029 라인 (변경 전/후 동일 - 리팩토링)
- 추가: `_buildGreetingStreak()`, `_updateDailyStats()` 메서드
- 이동: `_calculateStreakDays()` (HomeTab → ProfileTab)
- 제거: `UserHeader` 위젯 호출, 관련 임포트

**영향받는 위젯**:
- `_HomeTab` - 간소화됨
- `_ProfileTab` - 기능 추가됨
- `DailyGoalCard` - 재사용됨 (변경 없음)

## 사용자 경험 개선

### Before:
- 홈 화면이 복잡하고 스크롤이 많이 필요
- 개인 통계가 여러 탭에 분산됨

### After:
- 홈 화면: 학습 콘텐츠만 표시 → 빠른 접근
- 프로필 탭: 모든 개인 정보가 한 곳에 → 명확한 정보 구조
- 프로필 탭의 가치 증대 → 사용자 참여도 향상

## 롤백 플랜

변경 사항이 단일 파일에 국한됨:
1. Git에서 이전 버전 복원: `git checkout HEAD~1 -- mobile/lemon_korean/lib/presentation/screens/home/home_screen.dart`
2. 또는 수동 롤백:
   - `_HomeTab`에 위젯 복원
   - `_ProfileTab`에서 위젯 제거
   - 상태 변수 원복

## 향후 고려사항

1. **애니메이션 추가**: 프로필 탭 진입 시 페이드인 효과 (flutter_animate)
2. **연속일수 milestone**: 7일, 30일, 100일 달성 시 배지/축하 메시지
3. **일일 목표 커스터마이징**: 사용자가 목표 레슨 수 설정 가능
4. **위클리 리포트**: 주간 학습 통계 카드 추가

## 결론

홈 화면의 복잡도를 줄이고 프로필 탭의 유용성을 높였습니다. 정보 아키텍처가 개선되어 사용자가 학습 콘텐츠와 개인 통계를 명확히 구분할 수 있습니다. 모든 변경 사항은 기존 코드 패턴을 따르며, 새로운 의존성이나 API 변경이 필요하지 않습니다.
