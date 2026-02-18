---
date: 2026-02-18
category: Mobile
title: 전체 폰트 Pretendard 적용 + 온보딩 1단계 문구 변경
author: Claude Sonnet 4.5
tags: [font, onboarding, l10n, pretendard]
priority: medium
---

## 변경 내용

### 1. Pretendard 폰트 번들 적용

기존에 주석 처리되어 있던 NotoSansKR 폰트 설정을 Pretendard로 교체.
Google Fonts에 없으므로 OTF 파일을 직접 번들에 포함.

**다운로드 출처**: `https://github.com/orioncactus/pretendard/releases/v1.3.9/Pretendard-1.3.9.zip`

**추가된 파일**:
- `mobile/lemon_korean/assets/fonts/Pretendard-Regular.otf` (weight: 400)
- `mobile/lemon_korean/assets/fonts/Pretendard-Medium.otf` (weight: 500)
- `mobile/lemon_korean/assets/fonts/Pretendard-SemiBold.otf` (weight: 600)
- `mobile/lemon_korean/assets/fonts/Pretendard-Bold.otf` (weight: 700)
- `mobile/lemon_korean/assets/fonts/Pretendard-ExtraBold.otf` (weight: 800)

**수정된 파일**:
- `pubspec.yaml`: fonts 섹션 추가, `assets/fonts/` 경로 등록
- `lib/data/models/app_theme_model.dart`: `defaultTheme()` 내 `fontFamily: 'NotoSansKR'` → `'Pretendard'`, `fontSource: 'google'` → `'local'`

참고: `theme_provider.dart`는 이미 `fontFamily: theme.fontFamily`가 루트 ThemeData에 설정되어 있어 별도 수정 불필요.

### 2. 온보딩 1단계 문구 변경 (6개 언어)

앱 이름/언어 선택 안내에서 마스코트(모니) 소개 문구로 교체.

| 언어 | 제목 (Title) | 부제 (Prompt) |
|------|-------------|---------------|
| KO | 반가워요! 모니라고 해요 | 어떤 언어부터 함께 배울까요? |
| EN | Nice to meet you! I'm Moni | Which language shall we start learning? |
| JA | はじめまして！モニです | どの言語から一緒に学びますか？ |
| ZH | 你好！我是莫妮 | 从哪种语言开始一起学习呢？ |
| ZH_TW | 你好！我是莫妮 | 從哪種語言開始一起學習呢？ |
| ES | ¡Mucho gusto! Soy Moni | ¿Qué idioma empezamos a aprender juntos? |

**수정된 ARB 파일**: `app_ko.arb`, `app_en.arb`, `app_ja.arb`, `app_zh.arb`, `app_zh_TW.arb`, `app_es.arb`
- 키: `onboardingLanguageTitle`, `onboardingLanguagePrompt`

## 검증

```bash
cd mobile/lemon_korean
flutter pub get
flutter run  # 온보딩 1단계 진입 후 문구/폰트 확인
```
