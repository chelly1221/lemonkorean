---
date: 2026-02-26
category: Mobile
title: 프로필 탭 UX/UI 대규모 개선
author: Claude Opus 4.6
tags: [profile, ux, ui, redesign, gamification, stats, l10n, animation]
priority: high
---

# 프로필 탭 UX/UI 대규모 개선

## 배경

6인 UX 전문가 팀(Mobile UI Designer, Usability Analyst, Interaction Designer, Service Designer, UX Strategist, Leader)의 분석 결과를 바탕으로 프로필 탭을 개선함. 종합 평가 2.5/5에서 개선 목표.

## 주요 문제점 (분석 결과)

1. **학습 통계 미표시**: ProgressProvider에 데이터가 있지만 "학습일수" 1개만 표시
2. **스트릭 배지 거짓 어포던스**: 버튼처럼 보이지만 탭 불가
3. **프로필 편집 경로 부재**: 아바타/닉네임 수정 불가
4. **레몬 트리 과도한 화면 점유**: ~40% 차지 vs 통계 카드 1개
5. **소셜 기능 주변화**: 친구 섹션이 스크롤 최하단, 하드코딩된 한국어

## 변경 사항

### 새로 생성된 파일
- `lib/presentation/screens/profile/widgets/profile_stats_grid.dart` — 2x2 학습 통계 그리드
- `lib/presentation/screens/profile/widgets/streak_detail_sheet.dart` — 스트릭 상세 BottomSheet

### 수정된 파일
- `lib/presentation/screens/home/home_screen.dart` — _ProfileTab 전면 재구성
- `lib/presentation/screens/home/widgets/daily_goal_card.dart` — 애니메이션 + 햅틱 추가
- `lib/presentation/screens/profile/widgets/lemon_tree_widget.dart` — 컴팩트 버전
- `lib/l10n/app_*.arb` (6개 파일) — 17개 새 l10n 키 추가

### 상세 변경

#### 1. 학습 통계 2x2 그리드 (`ProfileStatsGrid`)
- 학습일, 완료 레슨, 습득 단어, 학습 시간 4개 지표 표시
- 각 카드에 색상 아이콘, 대형 숫자, 라벨
- staggered fade+slide 입장 애니메이션

#### 2. 스트릭 배지 → 탭 가능
- GestureDetector + chevron_right 아이콘으로 인터랙티브 표시
- 탭 시 `showStreakDetailSheet()` BottomSheet 표시
- 30일 달력 히트맵, 동기부여 메시지, 총 학습일 표시
- l10n으로 `streakDaysCount` 사용 (기존 하드코딩 "X일" 대체)

#### 3. 프로필 헤더 개선
- 아바타 radius 34→38, 폰트 크기 증가
- username 폰트 fontSizeLarge→fontSizeXLarge
- 헤더 전체 fadeIn 입장 애니메이션

#### 4. Pull-to-refresh 추가
- `RefreshIndicator` 래핑, `_loadStats` 호출
- accentColor (오렌지) 사용

#### 5. AppBar 개선
- 투명→scaffoldBackgroundColor로 가시성 확보
- `scrolledUnderElevation: 0.5` 추가
- My Room: `home_outlined` 아이콘 → `bedroom_child_outlined` + 라벨 텍스트

#### 6. Daily Goal Card 개선
- `StatelessWidget` → `StatefulWidget` 전환
- `TweenAnimationBuilder<double>` 1200ms 애니메이션
- 목표 달성 시 `HapticFeedback.mediumImpact()`
- 완료 시 pulsing glow 효과
- 미완료 시 "X개 더 하면 목표 달성!" 표시

#### 7. 레몬 트리 컴팩트
- 높이 240→160 (33% 축소)
- 모든 비례 요소 동시 스케일링 (레몬 28→24, 트렁크, 캐노피)

#### 8. 친구 섹션 개선
- 하드코딩 한국어 → l10n 적용
- TextButton → IconButton으로 헤더 정리
- 빈 상태: 일러스트 + CTA 버튼 디자인
- 아바타 radius 22→24

#### 9. l10n 추가 (6개 언어)
- 17개 새 키: 통계 라벨, 스트릭 관련, 빈 상태, 시간 단위 등
- en, ko, es, ja, zh, zh_TW 모두 번역 완료

### 섹션 순서 변경
```
기존: 헤더 → 데일리골 → 레몬트리 → 통계(1개) → 친구
변경: 헤더 → 데일리골 → 통계(4개 그리드) → 레몬트리(컴팩트) → 친구
```

## 미구현 (Phase 2-3 예정)
- 마이룸 캐릭터를 프로필 아바타로 연동
- 프로필 사진 업로드
- 배지/업적 시스템
- 주간 학습 그래프 (히트맵)
- 친구 활동 표시 (초록 점)
- 학습 공유 카드 (SNS)
