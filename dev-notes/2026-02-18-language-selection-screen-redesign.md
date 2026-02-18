---
date: 2026-02-18
category: Mobile
title: 언어 선택 화면 (온보딩 1단계) UI 재디자인
author: Claude Sonnet 4.5
tags: [onboarding, ui, redesign, flutter]
priority: medium
---

## 변경 내용

SVG 목업에 맞춰 언어 선택 화면(온보딩 첫 번째 화면)을 시각적으로 재디자인.

### 수정 파일

**`language_selection_card.dart`**
- 카드 높이: 72 → 50
- 모서리 반경: 14 → 4 (더 각진 스타일)
- 그림자(boxShadow) 제거
- 선택/미선택 배경 및 테두리 색상 변경:
  - 선택: `#FFF9D3` 배경, `#FFDB59` 테두리 (2px)
  - 미선택: `#FBF6EF` 배경, `#9B8A74` 테두리 (1px)
- 체크마크 원형 위젯 완전 제거
- 국기 이모지를 `SizedBox(30×20)` + `ClipRRect` + `FittedBox`로 감싸 크기 통일

**`onboarding_button.dart`**
- 선택적 `backgroundColor` 파라미터 추가 (기본값: `OnboardingColors.primaryYellow`)
- 기존 호출부에 영향 없음 (비파괴적 변경)

**`language_selection_screen.dart`**
- 배경색: `OnboardingColors.backgroundYellow` → `#FEFFF4` (크림 화이트)
- 스킵 버튼 및 `_onSkip()` 메서드 제거
- `LemonCharacter` 위젯 → `CachedNetworkImage`로 교체 (미디어 서버에서 실제 레몬 이미지 로드)
  - 로딩 중: 빈 SizedBox 표시
  - 에러 시: `LemonCharacter(expression: welcome, size: 160)` 폴백
- 레몬 이미지 하단에 SVG 명세대로 파란색(`#B1E7FF`) 타원 그림자 2개 추가
- 언어 순서 변경: `AppLanguage.values` → 영어 우선 고정 목록
  - en, zhCN, zhTW, ko, ja, es
- 다음 버튼 색상: `backgroundColor: Color(0xFFFFEC6D)` 전달

### 제거된 import
- `login_screen.dart` (스킵 기능 제거로 불필요)
