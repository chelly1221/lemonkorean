---
date: 2026-02-17
category: Mobile
title: 레몬 단면 회전 UI 구현 (레벨 0 학습 화면)
author: Claude Sonnet 4.5
tags: [flutter, ui, hangul, learning, animation]
priority: high
---

## 개요

한글 학습 레벨 0의 9개 단계를 레몬 단면(cross-section) 형태의 회전 가능한 UI로 시각화했습니다. 기존의 단순한 ListView를 대체하여 더욱 게임화되고 직관적인 학습 경험을 제공합니다.

## 주요 변경사항

### 1. 새로 생성된 파일

#### `lib/presentation/screens/hangul/widgets/lemon_slice_painter.dart`
- **CustomPainter** 구현으로 레몬 단면 렌더링
- 9개의 radial slice로 분할된 원형 레몬 단면
- 각 slice는 40도 각도 (360° / 9)
- 진행도에 따른 색상 매핑 (mastery 0-5)
- 선택된 slice에 하이라이트 효과 (glow, border)
- 단계 번호 레이블 자동 배치

**시각적 구조:**
```
[Outer Rind] - 황금색 그라디언트
  ↓
[Pith Layer] - 얇은 크림색 경계
  ↓
[9 Radial Slices] - 진행도별 색상 (grey → green → yellow → gold)
  ↓
[Center Core] - 중앙 씨앗 영역 (노란색)
  ↓
[Top Indicator] - 선택 위치 표시 화살표
```

**색상 팔레트 (mastery level 0-5):**
- 0: `#BDBDBD` (grey - 시작 전)
- 1: `#C5E1A5` (light green)
- 2: `#81C784` (green)
- 3: `#CDDC39` (yellow-green)
- 4: `#FFEE58` (yellow)
- 5: `#FFD54F` (gold - 완성)

#### `lib/presentation/screens/hangul/widgets/lemon_slice_wheel.dart`
- **상태 관리형 회전 휠 위젯**
- `GestureDetector`로 드래그 제스처 처리
- `AnimationController`로 부드러운 회전 애니메이션
- 드래그 종료 시 자동 snap to nearest slice
- 선택된 단계 변경 시 콜백 호출

**주요 메서드:**
- `_calculateTargetRotation()`: 특정 단계로 회전 각도 계산
- `_calculateTopStageIndex()`: 현재 상단에 있는 단계 계산
- `_rotateToStage()`: 특정 단계로 애니메이션 회전
- `_snapToNearestStage()`: 가장 가까운 단계로 snap

### 2. 수정된 파일

#### `lib/presentation/screens/hangul/hangul_level0_learning_screen.dart`
- **StatelessWidget → StatefulWidget** 변경 (상태 관리 필요)
- 기존 `ListView` 제거
- `LemonSliceWheel` 위젯으로 교체
- **상단 40%만 표시** (`ClipRect` + `heightFactor: 0.4`)로 레몬을 "들어올린" 듯한 효과
- 선택된 단계 정보 표시 섹션 추가:
  - 단계 번호
  - 단계 제목
  - 단계 부제목
  - 진행률 바
  - 진행률 텍스트
- "학습 시작" 버튼 추가 (기존 네비게이션 로직 유지)
- 입장 애니메이션 추가:
  - Wheel: Fade in (500ms) + Scale (0.9 → 1.0, 600ms)
  - 버튼: Fade in (400ms, delay 200ms)

## 기술적 세부사항

### 회전 계산 로직

```dart
// 단계 index → 회전 각도
double _calculateTargetRotation(int stageIndex) {
  const sliceAngle = 2 * pi / 9;
  return -stageIndex * sliceAngle;
}

// 회전 각도 → 상단에 있는 단계 index
int _calculateTopStageIndex(double rotation) {
  const sliceAngle = 2 * pi / 9;
  final normalized = rotation % (2 * pi);
  final positiveAngle = normalized < 0 ? normalized + 2 * pi : normalized;
  final index = ((-positiveAngle / sliceAngle).round()) % 9;
  return index < 0 ? index + 9 : index;
}
```

### 성능 최적화

1. **Paint 객체 재사용**: `static final` 선언으로 재생성 방지
2. **shouldRepaint 최적화**: rotation, selectedIndex, stageProgress 변경 시에만 repaint
3. **제스처 처리**: 드래그 중에는 애니메이션 없이 즉시 반응하여 60fps 유지

### 반응형 디자인

```dart
final screenWidth = MediaQuery.of(context).size.width;
final wheelDiameter = min(screenWidth * 0.85, 340.0);
final titleFontSize = screenWidth < 360 ? 20 : 24;
```

## 사용자 경험 개선

### 입장 애니메이션
- Wheel이 부드럽게 나타남 (fade + scale)
- 단계 정보와 버튼이 순차적으로 나타남 (stagger animation)

### 인터랙션
- 드래그로 자유롭게 회전 가능
- 드래그 종료 시 자동으로 가장 가까운 단계로 snap
- 선택된 단계는 오렌지색 하이라이트
- 상단 화살표로 현재 선택 위치 명확히 표시

### 시각적 피드백
- 진행도에 따른 slice 색상 변화 (grey → green → yellow → gold)
- 선택된 slice는 glow 효과
- 레이블 크기와 색상 변화 (선택된 단계는 더 크고 오렌지색)

## 향후 개선 사항

### 백엔드 연동 (TODO)
현재 진행도 데이터는 placeholder(0%)로 설정되어 있습니다.

```dart
List<double> _getStageProgress() {
  // TODO: Connect to HangulProvider
  return List.generate(9, (i) => 0.0);
}
```

**필요한 작업:**
1. `HangulProvider`에서 단계별 진행도 가져오기
2. API 엔드포인트 추가: `GET /api/progress/hangul/stages/:userId`
3. 응답 형식: `{ stage: 0, completedLessons: 5, totalLessons: 10, masteryLevel: 2.5 }`

### 추가 기능 아이디어
- [ ] Haptic feedback (진동) 추가
- [ ] 잠긴 단계 표시 (자물쇠 아이콘)
- [ ] Slice 길게 누르면 상세 통계 팝업
- [ ] 단계 완료 시 confetti 효과
- [ ] Auto-rotate demo 모드 (idle 시 천천히 회전)

## 테스트 체크리스트

### 기본 동작
- [x] Wheel이 상단 40%만 보이며 표시됨
- [x] 좌우로 드래그하면 부드럽게 회전
- [x] 드래그를 놓으면 가장 가까운 slice로 snap
- [x] Snap 시 선택된 단계 정보 업데이트
- [x] 상단 slice에 오렌지 하이라이트 적용
- [x] 각 slice에 0~8 숫자 표시
- [x] "학습 시작" 버튼 클릭 시 해당 단계 화면으로 이동

### 반응형 테스트
- [ ] 작은 화면(320px)에서 정상 표시 확인 필요
- [ ] 큰 화면(600px)에서 정상 표시 확인 필요
- [ ] 화면 회전(portrait ↔ landscape) 테스트 필요

### 성능 테스트
- [ ] 60fps로 부드럽게 회전하는지 확인 (DevTools Performance)
- [ ] 빠르게 드래그해도 정상 동작하는지 확인
- [ ] Wheel이 2바퀴 이상 회전해도 정상 동작하는지 확인

## 영향을 받는 파일

- `lib/presentation/screens/hangul/hangul_level0_learning_screen.dart` (수정)
- `lib/presentation/screens/hangul/widgets/lemon_slice_painter.dart` (신규)
- `lib/presentation/screens/hangul/widgets/lemon_slice_wheel.dart` (신규)

## 호환성

- **Flutter 버전**: 3.x 이상 (현재 프로젝트 버전과 호환)
- **종속성**:
  - `flutter_animate`: 기존 종속성 사용 (애니메이션)
  - Dart 내장 `dart:math`, `dart:ui` 사용

## 참고

- 색상 팔레트는 `lib/presentation/screens/home/widgets/lemon_clipper.dart`의 기존 mastery level 색상을 재사용
- 레몬 테마와 일관성 유지를 위해 기존 lemon shape 패턴 참조
- 9개 단계 데이터는 기존 `_stages` 상수 그대로 사용

## 커밋 메시지

```
feat: add interactive lemon slice wheel UI for Level 0 learning stages

Replace simple ListView with rotatable lemon cross-section wheel showing 9 learning stages.

- Add LemonSlicePainter (CustomPainter) for rendering 9-slice lemon cross-section
- Add LemonSliceWheel widget with drag-to-rotate gesture handling
- Show top 40% of wheel for "lifted lemon" effect
- Display selected stage info (title, subtitle, progress bar)
- Add smooth snap-to-slice animation with orange highlight
- Progress-based coloring (grey → green → yellow → gold)
- Top indicator arrow shows current selection
- Responsive design (adapts to screen width)
- Entry animations (fade + scale)

TODO: Connect to HangulProvider for real progress data

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```
