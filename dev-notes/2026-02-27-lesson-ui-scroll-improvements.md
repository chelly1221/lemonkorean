---
date: 2026-02-27
category: Mobile
title: 레슨 UI 스크롤 영역 개선 및 전체 레이아웃 최적화
author: Claude Opus 4.6
tags: [lesson, ui, scroll, layout, ux]
priority: high
---

## 문제

레슨 화면의 스크롤 영역이 세로로 너무 작았음. 분석 결과 다음 원인 발견:

1. **탑바(진행률 바)**: 불필요한 세로 패딩과 스테이지 텍스트로 ~80px 차지
2. **스테이지 외부 패딩**: 모든 스테이지가 `paddingLarge(24px)` 사용 → 상하 48px 낭비
3. **과도한 SizedBox 간격**: 스테이지별 100~140px의 SizedBox 간격
4. **Stage 1, 2 스크롤 미지원**: `Spacer()` 기반 → 작은 화면에서 오버플로우
5. **Stage 6 결과화면 스크롤 미지원**: 고정 Column으로 작은 화면에서 오버플로우
6. **Stage 2 플래시카드**: 200x200 이미지 + padding 40 = 과대한 고정 높이

## 변경 사항

### lesson_screen.dart - 탑바 최적화
- 세로 패딩: `paddingSmall(8px)` → `4px`
- 스테이지 텍스트 제거 (진행률 바만 남김)
- 프로그레스 바: `minHeight: 8` → `6`
- 닫기 버튼: 기본 48px → `40x40 SizedBox` 래핑
- **절약 공간: ~40px**

### stage1_intro.dart
- `Column + Spacer` → `Column [Expanded(SingleChildScrollView), Button]` 패턴
- 배지 크기: 100x100 → 80x80
- 간격: 40→24, 16→12
- 폰트: 32→28 (제목), 24→20 (부제목)
- 외부 패딩: 24px all → 16px horizontal + 8px vertical

### stage2_vocabulary.dart
- `Column + Spacer` → `Column [Header Row, Expanded(SingleChildScrollView), Nav Buttons]` 패턴
- 이미지: 200x200 → 140x140
- 카드 패딩: 40 → 24(paddingLarge)
- 한국어 폰트: 48→40, 중국어: 32→28, 병음: 20→18
- 제목+카운터를 한 줄 Row로 통합

### stage3_grammar.dart
- 제목+카운터를 한 줄 Row로 통합 (헤더 영역 축소)
- SizedBox 20+20 → Row + SizedBox 8
- 외부 패딩 → paddingMedium
- 버튼 패딩: paddingMedium → paddingSmall+4

### stage4_practice.dart
- 제목+카운터+점수를 한 줄 Row로 통합
- SizedBox 20+30+30 → 8+12
- 질문 카드 패딩: paddingLarge → paddingMedium
- 질문 폰트: 24 → 20
- 결과 메시지 + 버튼 영역 고정 하단 배치

### stage5_dialogue.dart
- 제목+카운터+재생버튼+대화 제목을 헤더 Row로 통합
- 재생 버튼: 전체 너비 → 컴팩트 버튼 (높이 36px)
- SizedBox 20+20+20+20 → 8
- ListView에 horizontal padding 추가

### stage6_quiz.dart
- 문제유형 배지+카운터+진행률 바를 컴팩트 헤더로 통합
- 진행률 바: minHeight 8 → 4
- SizedBox 20+20+30+16+30 → 8+10
- 질문 폰트: 22 → 20
- **결과 화면**: `Column(center) + Spacer` → `Column [Expanded(SingleChildScrollView), Button]`
- 결과 아이콘: 120x120 → 96x96
- 결과 폰트: 36→28, 48→40

### stage7_summary.dart
- 외부 패딩: 24px all → 16px horizontal + 8px vertical
- Container 래퍼 제거 (SingleChildScrollView에 직접 padding)
- 아이콘: 120x120 → 96x96
- SizedBox: 40→24→20→16→20 (전반적 축소)
- 폰트: 36→28 (제목), 24→20 (부제목)

## 공통 패턴

모든 스테이지를 `Column [Header, Expanded(ScrollableContent), FixedBottomButtons]` 구조로 통일:

```dart
Column(
  children: [
    // 헤더 (Padding, 제목+카운터 Row)
    Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 0), child: Row(...)),
    // 스크롤 콘텐츠
    Expanded(child: SingleChildScrollView/ListView(...)),
    // 하단 버튼 (고정)
    Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 16), child: Row(...)),
  ],
)
```

## 테스트
- `flutter analyze lib/presentation/screens/lesson/` → **No issues found**
