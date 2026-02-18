---
date: 2026-02-18
category: Mobile
title: Level Selection 카드 디자인을 Language Selection 1페이지와 통일
author: Claude Sonnet 4.5
tags: [onboarding, ui, design, flutter]
priority: medium
---

## 변경 개요

온보딩 2페이지(Level Selection)의 카드 디자인·아이콘·폰트를 1페이지(Language Selection)의 기준값에 맞춰 통일. 양쪽 화면의 메인 텍스트 색상을 `#43240D`(진한 갈색)으로 통일.

## 수정 파일

### 1. `widgets/level_selection_card.dart`

**카드 BG·테두리·radius·shadow**
- 미선택 BG: `0xFFFFF9D3` → `0xFFFBF6EF`
- 선택 BG: `0xFFFFF9E3` → `0xFFFFF9D3`
- 미선택 테두리: 1px `#9B8A74` → **없음** (`null`)
- 선택 테두리: 2px `#FFDB59` (유지)
- borderRadius: `4.5` → `4`
- boxShadow: 제거

**아이콘**
- 이전: 흰색 배경 Container + `#F2E3CE` 테두리 2.5px (~40×40)
- 이후: `SizedBox(30×30)` + `ClipRRect(borderRadius: 3)` + `SvgPicture` (흰 박스 제거)

**타이틀 폰트**
- fontSize: `screenWidth * 0.045` (~17px) → `18` (고정)
- fontWeight: `w600` → `w500`
- color: `#191F28` → `#43240D`

**import 정리**
- `OnboardingColors` import 제거 (boxShadow 삭제로 미사용)
- `iconSize` 변수 제거 (미사용)

### 2. `level_selection_screen.dart`

- 타이틀 color: `#121212` → `#43240D`

### 3. `language_selection_screen.dart`

- 타이틀 color: `#121212` → `#43240D`
- 프롬프트 color: `#121212` → `#43240D`
