---
date: 2026-02-08
category: Mobile
title: 캐러셀 스타일 레벨 셀렉터 + 레몬 숲 아이콘
author: Claude Opus 4.6
tags: [flutter, ui, carousel, level-selector]
priority: medium
---

## 변경 사항

### 1. 레벨 셀렉터 캐러셀 리디자인
- `LevelSelector`를 `StatelessWidget`에서 `StatefulWidget`으로 전환
- `SingleChildScrollView` + `Row` → `PageView.builder` (viewportFraction: 0.17)
- 중앙 아이콘이 가장 크고(70px), 거리에 따라 점진적으로 축소(→46px)
- 스와이프 시 자동 스냅, 탭 시 애니메이션으로 중앙 이동
- 중앙이 아닌 아이콘 탭 시 스크롤만 수행, 중앙 아이콘 탭 시 레벨 선택 콜백 실행
- 위젯 높이 90px → 100px

### 2. 레벨 9 아이콘 변경
- "King Sejong" → "Lemon Forest"
- SVG: `level_9_sejong.svg` 삭제 → `level_9_lemon_forest.svg` 생성
- 색상: 로열 블루(`0xFF1976D2`) → 포레스트 그린(`0xFF2E7D32`)
- 디자인: 레몬 나무 5그루가 있는 울창한 숲

## 수정 파일
| 파일 | 변경 |
|------|------|
| `lib/presentation/screens/home/widgets/level_selector.dart` | 전면 재작성 (캐러셀) |
| `lib/core/constants/level_constants.dart` | SVG 경로 + 색상 변경 |
| `assets/levels/level_9_lemon_forest.svg` | 새 파일 생성 |
| `assets/levels/level_9_sejong.svg` | 삭제 |

## 사이즈 보간 시스템
| 중앙으로부터 거리 | 아이콘 크기 | 테두리 두께 |
|------------------|-----------|------------|
| 0 (중앙) | 70px | 3.0px |
| 1 | ~62px | ~2.5px |
| 2 | ~54px | ~2.0px |
| 3+ | 46px | 1.5px |

## 핵심 구현 포인트
- `PageController.page` 리스너로 실시간 스크롤 위치 추적
- `_currentPage.round()`로 현재 중앙 아이콘 결정 (스크롤 중에도 부드러운 전환)
- `didUpdateWidget`에서 외부 `selectedLevel` 변경 시 자동 스크롤
- `isCenter`는 스크롤 위치 기반 (위젯의 selectedLevel이 아님) — Level 0 한글 화면 네비게이션과의 디싱크 방지
