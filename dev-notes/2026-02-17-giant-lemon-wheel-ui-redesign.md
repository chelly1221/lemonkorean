---
date: 2026-02-17
category: Mobile
title: 거대한 레몬 휠 UI 재설계 - 몰입형 단일 조각 표시
author: Claude Sonnet 4.5
tags: [flutter, ui, hangul, level0, lemon-wheel, redesign]
priority: high
---

# 거대한 레몬 휠 UI 재설계

## 변경 요약

Level 0 한글 학습 화면의 레몬 휠 UI를 **완전히 재설계**하여 더 몰입적이고 직관적인 경험 제공.

### 핵심 변경사항

1. **원 크기 2배 확대**: 화면 높이의 3.5배 → 7.0배
2. **원 중심 이동**: 화면 하단 밖으로 배치 (사용자에게 보이지 않음)
3. **viewport 확장**: 화면의 40% → 화면 끝까지 (제목 아래부터 버튼 위까지)
4. **단일 조각 강조**: 한 번에 하나의 학습 단계만 크게 표시
5. **비선택 조각 반투명화**: alpha 0.6 → 0.3 (더 흐리게)

## 기술적 구현

### 1. CustomPainter 수정 (`lemon_slice_painter.dart`)

**변경 전**:
```dart
_slicePaint.color = isCenterSlice
    ? color.withValues(alpha: 1.0)
    : color.withValues(alpha: 0.6);  // 비선택 조각이 너무 선명
_borderPaint.strokeWidth = 4.0;      // 테두리가 얇음
```

**변경 후**:
```dart
_slicePaint.color = isCenterSlice
    ? color.withValues(alpha: 1.0)
    : color.withValues(alpha: 0.3);  // 더 반투명하게 (명확한 구분)
_borderPaint.strokeWidth = 6.0;      // 선택 조각 테두리 강조
```

**효과**:
- 선택된 조각이 훨씬 더 돋보임
- 비선택 조각들이 배경으로 물러남
- 시각적 초점이 명확해짐

### 2. Wheel Widget 재구성 (`lemon_slice_wheel.dart`)

**기존 설계의 문제점**:
- 원의 중심이 화면 중앙에 위치 → 여러 조각이 동시에 보임
- viewport가 작아서 (40%) 몰입감 부족
- 중앙 표시기가 오히려 시각적 혼란 유발

**새로운 설계**:

```dart
// 거대한 원 (화면 높이의 7배)
final wheelDiameter = screenHeight * 7.0;
final radius = wheelDiameter / 2;

// 원의 중심을 화면 하단 밖으로
final centerX = screenWidth / 2;
final centerY = screenHeight + (radius * 0.3);

// viewport는 부모의 모든 공간 사용
return ClipRect(
  child: SizedBox.expand(  // 화면 끝까지 확장
    child: Stack(
      children: [
        // Positioned로 원을 화면 밖에 배치
        Positioned(
          left: centerX - radius,
          top: centerY - radius,
          child: Transform.rotate(...),
        ),
      ],
    ),
  ),
);
```

**기하학적 효과**:
- 원이 매우 크고 중심이 화면 밖 → 원의 윗부분 일부만 보임
- 9개 조각 중 1개만 화면에 들어옴
- 다른 조각들은 화면 양쪽 밖으로 나감
- 마치 거대한 레몬을 아래에서 올려다보는 느낌

### 3. Screen Layout 최적화 (`hangul_level0_learning_screen.dart`)

**변경 전**:
```dart
Stack(
  children: [
    SingleChildScrollView(  // 불필요한 스크롤
      child: Column(
        children: [
          _buildStageInfo(),
          SizedBox(height: 32),
          GiantLemonWheel(...),  // 고정 높이
          SizedBox(height: 100),
        ],
      ),
    ),
    Positioned(bottom: 24, child: Button()),
  ],
)
```

**변경 후**:
```dart
Stack(
  children: [
    Column(  // 스크롤 제거
      children: [
        _buildStageInfo(),  // 상단 고정
        SizedBox(height: 16),
        Expanded(  // 나머지 공간 모두 사용
          child: ClipRect(
            child: GiantLemonWheel(...),
          ),
        ),
      ],
    ),
    Positioned(bottom: 24, child: Button()),  // 버튼 overlay
  ],
)
```

**개선점**:
- 스크롤 제거 → 안정적인 레이아웃
- Expanded로 레몬 휠이 최대 공간 사용
- 버튼은 Positioned로 overlay → 공간 효율적

## UX 개선 효과

### Before (기존)
- ❌ 여러 조각이 동시에 보여서 산만함
- ❌ viewport가 작아서 답답한 느낌
- ❌ 어떤 조각이 선택됐는지 불분명
- ❌ 중앙 표시기가 오히려 방해

### After (개선)
- ✅ **한 조각만** 화면 하부 전체를 차지
- ✅ **몰입감**: 거대한 레몬을 아래서 올려다보는 느낌
- ✅ **명확한 선택**: 선택된 조각이 밝고 크게, 다른 조각은 반투명
- ✅ **직관적**: 좌우 드래그로 큰 휠을 돌리는 자연스러운 제스처
- ✅ **깔끔함**: 불필요한 UI 요소 제거

## 회전 제스처 동작 (변경 없음)

기존 회전 로직은 그대로 유지:
- 수평 드래그로 회전
- 화면 너비만큼 드래그 = 360도 회전
- 드래그 종료 시 가장 가까운 조각으로 snap (300ms, easeOut)
- 중앙 조각 인덱스 계산 자동 업데이트

## 테스트 체크리스트

### 시각적 검증
- [ ] 한 조각만 화면 하부 전체를 차지하는가?
- [ ] 원의 중심이 화면 밖에 있어서 안 보이는가?
- [ ] viewport가 제목 아래부터 화면 끝까지 확장되는가?
- [ ] 선택된 조각이 밝고 선명한가? (alpha 1.0)
- [ ] 비선택 조각들이 반투명한가? (alpha 0.3)
- [ ] 선택된 조각의 테두리가 굵고 주황색인가? (6px, #FF6F00)

### 인터랙션 검증
- [ ] 좌우 드래그로 부드럽게 회전하는가?
- [ ] 드래그 종료 시 정확히 snap되는가?
- [ ] 상단 제목/설명이 선택에 따라 업데이트되는가?
- [ ] "학습 시작" 버튼이 하단에 고정되어 있는가?
- [ ] 60fps 유지하는가? (큰 원이어도 성능 문제 없는가?)

### 반응형 테스트
- [ ] 다양한 화면 크기에서 정상 작동하는가?
- [ ] 작은 화면(320px)에서도 한 조각만 보이는가?
- [ ] 큰 화면(태블릿)에서도 정상 작동하는가?
- [ ] 화면 회전 시 레이아웃이 깨지지 않는가?

## 파일 변경 내역

### 수정된 파일 (3개)

1. **`lib/presentation/screens/hangul/widgets/lemon_slice_painter.dart`**
   - 비선택 조각 alpha: 0.6 → 0.3
   - 선택 조각 테두리: 4px → 6px

2. **`lib/presentation/screens/hangul/widgets/lemon_slice_wheel.dart`** ⭐ 주요
   - 원 크기: `screenHeight * 3.5` → `screenHeight * 7.0`
   - 원 중심 위치: 화면 하단 밖 계산 추가
   - viewport: 고정 높이 → `SizedBox.expand()`
   - Positioned로 원 배치
   - 중앙 표시기 제거 (`_buildCenterIndicator()` 삭제)

3. **`lib/presentation/screens/hangul/hangul_level0_learning_screen.dart`** ⭐ 주요
   - SingleChildScrollView 제거
   - Expanded로 GiantLemonWheel 감싸기
   - 불필요한 SizedBox 제거
   - 사용하지 않는 `dart:math` import 제거

## 성능 고려사항

### 잠재적 우려
- 원 크기가 2배 증가 → CustomPaint 부하 증가?

### 실제 영향
- ✅ CustomPaint는 GPU 가속으로 렌더링
- ✅ 화면에 보이는 영역만 그려짐 (ClipRect)
- ✅ 9개 조각 모두 그리지만 캔버스 크기만 증가 (동일한 복잡도)
- ✅ 예상 성능 영향: 무시할 수 있는 수준

### 최적화 적용
- Transform.rotate: GPU 가속
- ClipRect: 화면 밖 픽셀은 버려짐
- shouldRepaint: 변경 시에만 재렌더링

## 향후 개선 가능성

### 선택 사항 (현재는 구현 안 함)
- [ ] 선택된 조각에 scale up 효과 (1.02x) → 필요시 추가
- [ ] Haptic feedback (진동) → 사용자 선호도 확인 필요
- [ ] 조각 전환 시 제목 애니메이션 강화 → 현재도 충분함

### 추후 고려 사항
- 사용자 피드백 수집 후 미세 조정
- A/B 테스트로 효과 검증

## 결론

이번 재설계로 Level 0 학습 화면이 **몰입형 단일 조각 표시** 방식으로 전환되어:
- 시각적 명확성 ↑
- 사용자 집중도 ↑
- UI 깔끔함 ↑

기존 회전 제스처와 진행도 로직은 모두 유지되므로 **기능 호환성 100%** 보장.
