---
date: 2026-02-08
category: Mobile
title: 학습 탭 레벨 선택기 구현
author: Claude Opus 4.6
tags: [flutter, ui, level-selector, learning-tab]
priority: high
---

# 학습 탭 레벨 선택기 구현

## 변경 사항

학습(Home) 탭 상단에 10단계 레벨 아이콘을 수평 스크롤 형태로 배치하여, 학습 콘텐츠를 난이도별로 필터링할 수 있는 레벨 선택기를 추가함.

### 레벨 구성 (성장 여정 테마)
| 레벨 | 아이콘 | 설명 |
|------|--------|------|
| 0 | 한글 (ㅎ) | 한글 학습 화면으로 이동 |
| 1 | 씨앗 | 입문 단계 |
| 2 | 새싹 | 기초 단계 |
| 3 | 작은 나무 | 초급 단계 |
| 4 | 큰 나무 | 중급 진입 |
| 5 | 레몬 1개 | 중급 |
| 6 | 레몬 가득 | 중상급 |
| 7 | 황금 나무 | 상급 |
| 8 | 황금 농장 | 고급 |
| 9 | 세종대왕 | 마스터 |

## 생성된 파일

### SVG 아이콘 (10개)
- `assets/levels/level_0_hangul.svg` ~ `level_9_sejong.svg`
- 100x100 viewBox, 플랫 디자인, 원형 배경

### Dart 파일 (2개)
- `lib/core/constants/level_constants.dart`: 레벨별 SVG 경로 및 색상 상수
- `lib/presentation/screens/home/widgets/level_selector.dart`: `LevelSelector` 위젯

## 수정된 파일

### `pubspec.yaml`
- `flutter_svg: ^2.0.10` 의존성 추가
- `assets/levels/` 에셋 경로 등록

### `lib/presentation/screens/home/home_screen.dart`
- `_selectedLevel`, `_levelsWithProgress` 상태 변수 추가
- `_filteredLessons` getter로 레슨 필터링
- `_onLevelSelected()`: 레벨 0은 한글 화면 이동, 나머지는 필터링
- `_HangulLearningCard` 클래스 제거 (레벨 0 아이콘으로 대체)
- "Lessons" 헤더 및 필터 버튼 제거
- 레슨이 없는 레벨에 "Coming soon" 빈 상태 표시
- `_updateProgressStats()`에서 진도 있는 레벨 자동 계산

## UI 동작
- 선택된 레벨: 노란색 테두리 + 그림자
- 진도 없는 레벨: opacity 0.4로 흐리게 표시 (탭 가능)
- 아이콘 크기: 56px 원형, 전체 높이 ~90px
- 선택 표시: 하단 노란색 점

## 기술 사항
- `flutter_svg` 패키지로 SVG 렌더링
- `AnimatedContainer`로 선택 상태 전환 애니메이션
- 기존 `flutter analyze` 오류에 영향 없음
