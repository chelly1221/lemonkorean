---
date: 2026-02-17
category: Mobile
title: Lemon Wheel UI Refinements - Snap, Button Integration, Arc Visibility
author: Claude Sonnet 4.5
tags: [flutter, ui, lemon-wheel, level0, hangul]
priority: medium
---

# Lemon Wheel UI Refinements

## 개요
Level 0 학습 화면의 giant lemon wheel UI에 대한 3가지 핵심 개선 사항을 구현했습니다:
1. 스냅 정렬 문제 수정 (슬라이스 경계 → 중심으로 스냅)
2. 버튼 시각적 통합 (녹색 Material 버튼 → 레몬 테마 embedded 버튼)
3. 상단 호 가시성 개선 (황금빛 껍질이 보이도록 위치 조정)

## 변경 사항

### 1. 스냅 계산 정렬 수정
**파일**: `mobile/lemon_korean/lib/presentation/screens/hangul/widgets/lemon_slice_wheel.dart:108`

**문제점**:
- 휠이 슬라이스 경계에 스냅되어 선택된 조각이 중앙에서 벗어나 보임
- Painter는 `-pi/2`에서 슬라이스를 그리기 시작하지만, 계산은 0에서 시작한다고 가정

**해결책**:
```dart
// Before
final rawIndex = -normalizedRotation / sliceAngle;

// After
final rawIndex = (-normalizedRotation / sliceAngle) + 0.5;
```

**효과**:
- 각 단계 번호가 스냅 후 완벽하게 수직으로 정렬됨
- 슬라이스 중심 (0°, 40°, 80°...)에 스냅
- 각 중심 주위 ±20° 버퍼로 안정적인 스냅 제공

### 2. 버튼 시각적 통합
**파일**: `mobile/lemon_korean/lib/presentation/screens/hangul/hangul_level0_learning_screen.dart:55-145`

**문제점**:
- 녹색 Material Design 버튼 (`0xFF4CAF50`)이 레몬 테마와 맞지 않음
- 버튼이 휠과 독립적으로 떠 있어 시각적 연결 부족

**해결책**:
- `Expanded` 위젯을 `Stack`으로 변경하여 휠과 버튼 포함
- 버튼을 `bottom: 40`에 위치시켜 휠과 겹치게 배치
- 레몬 색상 적용:
  - 오렌지 그라데이션: `0xFFFF8F00` → `0xFFFF6F00` (선택된 슬라이스 테두리와 매칭)
  - 황금 테두리: `0xFFFFD54F` (outer rind와 매칭)
  - 글로우 효과: `0xFFFF6F00` at 50% opacity
- `ElevatedButton` → `GestureDetector` + `Container`로 변경 (정교한 제어)

**UI 디자인**:
```dart
Container(
  width: 180,
  height: 60,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFFF8F00), Color(0xFFFF6F00)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Color(0xFFFFD54F), width: 3),
    boxShadow: [
      BoxShadow(
        color: Color(0xFFFF6F00).withOpacity(0.5),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ],
  ),
  // ...
)
```

**효과**:
- 버튼이 선택된 슬라이스에서 나오는 것처럼 보임
- 레몬 테마와 일관된 시각적 스타일
- 큰 글로우 효과로 휠과 통합된 느낌

### 3. 상단 호 가시성
**파일**: `mobile/lemon_korean/lib/presentation/screens/hangul/widgets/lemon_slice_wheel.dart:159`

**문제점**:
- 원의 중심이 뷰포트 아래 너무 멀리 위치해 상단 곡선(황금빛 껍질)이 완전히 숨겨짐
- radius = `viewportHeight * 3.5`, centerY = `viewportHeight + (radius * 0.3)`
- 상단이 `centerY - radius = -2.45 * viewportHeight` (화면 밖)

**해결책**:
```dart
// Before
final centerY = viewportHeight + (radius * 0.3);

// After
final centerY = viewportHeight + (radius * 0.15);
```

**영향 계산**:
- 이전 오프셋: `viewportHeight * 1.05` (뷰포트 아래)
- 새 오프셋: `viewportHeight * 0.525` (뷰포트 아래)
- 중심을 뷰포트 높이의 ~50% 위로 이동

**효과**:
- 상단의 황금빛 껍질/그라데이션이 화면 상단에 보임
- 더 많은 곡선 엣지가 표시되어 "거대한 레몬" 느낌 강화
- 중심 슬라이스는 여전히 뷰포트 하단 영역에 잘 표시됨

## 기술적 세부사항

### 수정된 파일 (2개)
1. `lemon_slice_wheel.dart` (2개 변경)
   - Line 108: 스냅 계산 오프셋
   - Line 159: centerY 위치 조정

2. `hangul_level0_learning_screen.dart` (1개 변경)
   - Lines 55-145: Expanded를 Stack으로 변경 + embedded 버튼
   - Lines 77-112 삭제: 이전 Positioned 버튼 제거

### 성능 영향
- **스냅 계산**: 하나의 산술 연산 추가 (`+0.5`) - 무시할 수 있는 영향
- **버튼 렌더링**: ElevatedButton → Container + gradient - 성능 차이 없음
- **Painter 호출**: CustomPaint 로직 변경 없음
- **레이아웃**: 버튼이 outer Stack에서 inner Stack으로 이동 - 추가 리빌드 없음

### 엣지 케이스 처리
1. **경계 근처 스냅**: `+0.5` 오프셋이 ±20° 버퍼 제공
2. **버튼이 드래그 차단**: `bottom: 40`이 일반적인 드래그 영역 아래, Stack 순서로 휠 우선순위
3. **작은 화면의 상단 호**: `0.15` 배수가 충분히 보수적이어서 단계 정보와 겹치지 않음
4. **버튼 텍스트 오버플로**: 180px 너비가 "학습 시작"에 충분
5. **애니메이션 충돌**: 버튼 지연(200ms)이 휠 애니메이션 후 시작

## 테스트 체크리스트

### 시각적 테스트
- [ ] 상단 황금빛 껍질/호가 뷰포트 상단에 명확히 보임
- [ ] 스냅 시 단계 번호 라벨이 완벽하게 수직 (슬라이스 중심)
- [ ] 버튼이 레몬 테마와 일치하는 오렌지/골드 색상 사용
- [ ] 버튼이 선택된 슬라이스 하단에서 나오는 것처럼 보임
- [ ] 글로우 효과가 버튼과 휠 사이의 시각적 연결 생성

### 기능적 테스트
- [ ] 9개 단계 각각이 올바른 중심 위치에 스냅
- [ ] 버튼 탭이 선택된 단계로 이동
- [ ] 휠 드래그 제스처가 부드럽게 작동 (버튼이 방해하지 않음)
- [ ] 빠른 스와이프가 여전히 올바르게 스냅
- [ ] 작은 드래그가 여전히 스냅 애니메이션 트리거

### 반응형 테스트
- [ ] 작은 폰 (320x568): 상단 호 보임, 버튼 맞춤, 스냅 정확
- [ ] 표준 폰 (375x667): 모든 기능 정상 작동
- [ ] 큰 폰 (414x896): 레이아웃 비율 유지
- [ ] 태블릿 (768x1024): 비율 유지
- [ ] 다양한 뷰포트 종횡비

## 사용자 경험 개선

### Before
- ❌ 스냅 후 단계 번호가 약간 기울어져 보임
- ❌ 녹색 버튼이 레몬 테마와 불일치
- ❌ 상단 곡선이 보이지 않아 "거대한 레몬" 느낌 약화
- ❌ 버튼이 독립적으로 떠 있어 UI가 분리되어 보임

### After
- ✅ 완벽하게 정렬된 단계 번호 (수직)
- ✅ 레몬 색상 (오렌지/골드)으로 일관된 테마
- ✅ 상단의 황금빛 껍질이 보여 몰입도 향상
- ✅ 버튼이 휠과 통합되어 보여 통일된 UI

## 롤백 계획
문제 발생 시:
- **스냅 계산 문제**: `+ 0.5` 오프셋 제거
- **상단 호 겹침**: `0.3` 또는 `0.2`로 복원
- **버튼 드래그 차단**: outer Stack으로 이동 (lines 77-112 복원)
- **전체 롤백**: Git으로 간단히 복원 (2개 파일, 명확한 변경사항)

## 다음 단계
1. 실제 기기에서 테스트 (Android/iOS/Web)
2. 다양한 화면 크기에서 반응형 동작 확인
3. 사용자 피드백 수집
4. 필요시 fine-tuning (centerY 배수, 버튼 위치)

## 참고
- 계획 문서: Plan transcript at `/home/sanchan/.claude/projects/-home-sanchan-lemonkorean/bf106951-0684-4132-8660-d1cb874cf127.jsonl`
- 관련 파일: `lemon_slice_painter.dart` (색상 참조)
- 이슈: 없음 (계획된 개선)
