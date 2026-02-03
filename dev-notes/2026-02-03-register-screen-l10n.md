---
date: 2026-02-03
category: Mobile
title: RegisterScreen 중국어 병기 제거 및 l10n 적용
author: Claude Opus 4.5
tags: [l10n, i18n, register, auth, bilingual-text]
priority: medium
---

## 변경 내용

`RegisterScreen`에서 `BilingualText`/`InlineBilingualText` 위젯을 사용한 중국어+한국어 병기를 l10n 기반 단일 언어 표시로 변경했습니다.

## 변경 파일

- `lib/presentation/screens/auth/register_screen.dart`

## 세부 변경 사항

### 1. Import 변경
- 제거: `../../widgets/bilingual_text.dart`
- 추가: `../../../core/utils/l10n_extensions.dart`

### 2. BilingualText → l10n 변경 (11개 항목)

| 위치 | 변경 전 | 변경 후 |
|------|---------|---------|
| 타이틀 | BilingualText 위젯 | `context.l10n.createAccount` |
| 서브타이틀 | BilingualText 위젯 | `context.l10n.startJourney` |
| 사용자 이름 라벨 | InlineBilingualText | `context.l10n.username` |
| 이메일 라벨 | InlineBilingualText | `context.l10n.email` |
| 비밀번호 라벨 | InlineBilingualText | `context.l10n.password` |
| 비밀번호 확인 라벨 | InlineBilingualText | `context.l10n.confirmPassword` |
| 인터페이스 언어 | InlineBilingualText | `context.l10n.interfaceLanguage` |
| 비밀번호 요구사항 | InlineBilingualText | `context.l10n.passwordRequirements` |
| 등록 버튼 | InlineBilingualText | `context.l10n.register` |
| 계정 있음 | InlineBilingualText | `context.l10n.haveAccount` |
| 로그인 링크 | InlineBilingualText | `context.l10n.loginNow` |

### 3. hintText 변경 (4개 항목)

| 위치 | 변경 전 | 변경 후 |
|------|---------|---------|
| 사용자 이름 | `'请输入用户名'` | `context.l10n.enterUsername` |
| 이메일 | `'请输入邮箱地址'` | `context.l10n.enterEmail` |
| 비밀번호 | `'请输入密码'` | `context.l10n.enterPassword` |
| 비밀번호 확인 | `'请再次输入密码'` | `context.l10n.enterConfirmPassword` |

### 4. 비밀번호 요구사항 변경

| 변경 전 | 변경 후 |
|---------|---------|
| `'至少${AppConstants.minPasswordLength}个字符'` | `context.l10n.minCharacters(AppConstants.minPasswordLength)` |
| `'包含字母和数字'` | `context.l10n.containLettersNumbers` |

### 5. 언어 선택 드롭다운 항목

| 변경 전 | 변경 후 |
|---------|---------|
| `'简体中文'` (하드코딩) | `context.l10n.simplifiedChinese` |
| `'繁體中文'` (하드코딩) | `context.l10n.traditionalChinese` |

## 결과

- 회원가입 화면의 모든 텍스트가 사용자 언어 설정에 따라 동적으로 변경됨
- 중국어/한국어 병기 표시 제거, 단일 언어로 깔끔하게 표시
- 6개 언어 지원: 한국어, 영어, 중국어(간체), 중국어(번체), 일본어, 스페인어
