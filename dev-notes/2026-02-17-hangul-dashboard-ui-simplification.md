---
date: 2026-02-17
category: Mobile
title: 레벨 0 한글 학습 UI 단순화
author: Claude Sonnet 4.5
tags: [flutter, ui, hangul, level-0, dashboard]
priority: high
---

# 레벨 0 한글 학습 UI 단순화

## 개요
레벨 0 한글 학습 대시보드 UI를 단순화하여 4가지 학습 방식(학습, 음절조합, 받침연습, 소리구분훈련)을 명확히 구분하고, 사용자 경험을 개선했습니다.

## 배경
기존 UI는 여러 진입점(파란 학습 버튼, 가이드 카드, 자모표 그리드)이 혼재되어 있어 복잡했습니다. 사용자 피드백에 따라 UI를 단순화하고 학습 방식을 명확히 구분하기로 결정했습니다.

## 주요 변경사항

### 1. 파일 수정: `hangul_dashboard_view.dart`

#### 제거된 UI 요소
- **파란색 "학습" 버튼** (`_buildTopLearningButton()`)
  - 상단에 있던 큰 파란색 버튼 제거
- **가이드 카드** (`_buildGuideCard()`)
  - 레몬 진행률 표시 + 단계별 CTA 버튼이 있던 카드 제거
  - 복잡한 학습 단계 판단 로직 제거
- **보조 액션** (`_buildSecondaryActions()`, `_secondaryBtn()`)
  - 가이드 카드 내의 작은 보조 버튼들 제거

#### 추가된 UI 요소
- **4개 액션 버튼 그리드** (`_buildActionButtons()`)
  - 2x2 그리드 레이아웃
  - 각 버튼: 아이콘 + 라벨 + 색상 구분
  - 위치: 자모표 그리드 바로 위

**버튼 구성:**
1. **학습** (녹색, Icons.school)
   - → `HangulLevel0LearningScreen` (9단계 로드맵)
2. **음절조합** (파란색, Icons.extension)
   - → `HangulSyllableScreen`
3. **받침연습** (보라색, Icons.abc)
   - → `HangulBatchimScreen`
4. **소리구분훈련** (주황색, Icons.hearing)
   - → `HangulDiscriminationScreen`

#### 제거된 코드
- `_HangulStage` enum (학습 단계 판단)
- `_determineStage()` 메서드
- `_progressLemonColor()` 메서드
- `_goHangul()` 메서드 (HangulMainScreen 네비게이션)

#### Import 변경
```dart
// 제거
import '../../hangul/hangul_main_screen.dart';

// 추가
import '../../hangul/hangul_syllable_screen.dart';
import '../../hangul/hangul_batchim_screen.dart';
import '../../hangul/hangul_discrimination_screen.dart';
```

### 2. 파일 삭제

#### `hangul_main_screen.dart`
- 4개 탭(자모표/학습/연습/활동)을 가진 화면
- 더 이상 필요하지 않아 완전히 제거
- 각 기능을 개별 화면으로 직접 연결

#### `hangul_path_view.dart`
- 지그재그 경로로 한글 섹션을 표시하던 뷰
- 다른 곳에서 사용되지 않음
- `HangulMainScreen`을 참조하여 더 이상 작동하지 않음
- 새로운 UI 구조에 맞지 않아 제거

### 3. 검증
- ✅ `HangulMainScreen` 참조 완전 제거 확인
- ✅ Flutter analyze 통과
- ✅ 4개 화면 파일 존재 확인 (Syllable, Batchim, Discrimination)

## 기술적 세부사항

### 레이아웃 구조 변경
```dart
// 기존
Column(
  children: [
    _buildTopLearningButton(),  // 파란 학습 버튼
    _buildGuideCard(),           // 가이드 카드
    ...자모표 그리드...
  ],
)

// 변경 후
Column(
  children: [
    _buildActionButtons(),  // 4개 버튼 그리드 (2x2)
    ...자모표 그리드...
  ],
)
```

### GridView 레이아웃
- `crossAxisCount: 2` (2열)
- `childAspectRatio: 1.8` (가로:세로 비율)
- `crossAxisSpacing: 12`, `mainAxisSpacing: 12`
- 각 버튼: 아이콘(28px) + 라벨(12px)

### 애니메이션
- `flutter_animate` 사용
- `fadeIn` + `slideY` 효과 (300ms)

## 영향 범위
- ✅ 자모표 그리드 및 캐릭터 상세 화면: 변경 없음
- ✅ 통계 정보(stats): 유지 (자모표 레몬 색상에 반영)
- ✅ 4개 활동 화면: 기존 화면 재사용
- ✅ 오프라인 학습 기능: 영향 없음

## 테스트 체크리스트
- [ ] 앱 빌드 및 실행
- [ ] 홈 화면 → 레벨 0 (한글) 선택
- [ ] 파란 "학습" 버튼 제거 확인
- [ ] 가이드 카드(레몬 진행률) 제거 확인
- [ ] 4개 버튼 그리드 표시 확인
- [ ] "학습" 버튼 → HangulLevel0LearningScreen 이동
- [ ] "음절조합" 버튼 → HangulSyllableScreen 이동
- [ ] "받침연습" 버튼 → HangulBatchimScreen 이동
- [ ] "소리구분훈련" 버튼 → HangulDiscriminationScreen 이동
- [ ] 자모표 그리드 정상 표시 및 클릭 동작
- [ ] 컴파일 에러/런타임 에러 없음

## 향후 고려사항
1. **진행률 표시**: 가이드 카드가 제거되어 전체 진행률을 한눈에 볼 수 있는 곳이 없음
   - 필요시 상단에 간단한 진행률 바 추가 고려
2. **버튼 레이블 다국어화**: 현재 한국어 하드코딩
   - l10n 파일에 추가 필요
3. **접근성**: 버튼 크기 및 터치 영역 검토
4. **반응형**: 다양한 화면 크기에서 테스트 필요

## 관련 파일
- `/mobile/lemon_korean/lib/presentation/screens/home/widgets/hangul_dashboard_view.dart` (수정)
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_main_screen.dart` (삭제)
- `/mobile/lemon_korean/lib/presentation/screens/home/widgets/hangul_path_view.dart` (삭제)
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_syllable_screen.dart` (활용)
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_batchim_screen.dart` (활용)
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_discrimination_screen.dart` (활용)
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_level0_learning_screen.dart` (활용)
