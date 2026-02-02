---
date: 2026-02-02
category: Mobile
title: 하드코딩된 중국어 텍스트를 한국어로 변경
author: Claude Opus 4.5
tags: [i18n, localization, korean, hardcoded-text]
priority: medium
---

# 하드코딩된 중국어 텍스트를 한국어로 변경

## 개요
앱 내 하드코딩된 중국어 텍스트를 한국어로 변경하여 일관된 사용자 경험을 제공합니다.

## 변경 파일

### 1. `lib/core/constants/app_constants.dart`
- `appNameChinese` → `appNameKorean` (柠檬韩语 → 레몬 한국어)
- 에러/성공 메시지 한국어 변경:
  - 网络连接失败 → 네트워크 연결 실패
  - 服务器错误 → 서버 오류
  - 认证失败 → 인증 실패
  - 登录成功 → 로그인 성공
  - 注册成功 → 회원가입 성공
  - 同步成功 → 동기화 성공
  - 下载成功 → 다운로드 성공

### 2. `lib/core/network/api_client.dart`
- 요청 취소, 파라미터 오류, 권한 오류, 리소스 미존재, 요청 과다 메시지 한국어 변경

### 3. `lib/core/utils/app_exception.dart`
- 모든 Exception 클래스의 기본 메시지 한국어 변경:
  - NetworkException: 네트워크 연결 실패
  - ServerException: 서버 오류
  - AuthException: 인증 실패
  - NotFoundException: 요청한 리소스가 존재하지 않습니다
  - ValidationException: 요청 파라미터 오류
  - ParseException: 데이터 파싱 오류

### 4. `lib/core/utils/validators.dart`
- 이메일, 비밀번호, 사용자명 유효성 검사 메시지 한국어 변경:
  - 请输入邮箱 → 이메일을 입력하세요
  - 密码至少需要 → 비밀번호는 최소...자 이상이어야 합니다
  - 两次输入的密码不一致 → 비밀번호가 일치하지 않습니다
  - 用户名只能包含 → 사용자명은 문자, 숫자, 밑줄만 포함할 수 있습니다

### 5. `lib/core/utils/sync_manager.dart`
- 동기화 상태 메시지 한국어 변경:
  - 正在同步 → 동기화 중
  - 离线模式 → 오프라인 모드
  - 已同步 → 동기화 완료
  - 刚刚/分钟前/小时前/天前 → 방금/분 전/시간 전/일 전

### 6. `lib/presentation/providers/auth_provider.dart`
- 인증 관련 에러 메시지 한국어 변경:
  - 加载用户信息失败 → 사용자 정보 로드 실패
  - 登录失败 → 로그인 실패
  - 注册失败 → 회원가입 실패
  - 登出时发生错误 → 로그아웃 중 오류 발생

### 7. `lib/data/repositories/auth_repository.dart`
- 서버 응답 및 에러 메시지 한국어 변경:
  - 服务器返回数据格式错误 → 서버 응답 데이터 형식 오류
  - 用户数据缺少ID → 사용자 데이터에 ID가 없습니다
  - 邮箱或密码错误 → 이메일 또는 비밀번호가 잘못되었습니다
  - 邮箱已被注册 → 이미 등록된 이메일입니다

### 8. `lib/presentation/screens/vocabulary_browser/vocabulary_browser_screen.dart`
- UI 텍스트 한국어 변경:
  - 单词浏览器 → 단어 브라우저
  - 搜索单词 → 단어 검색
  - 重试 → 다시 시도
  - 按级别/按字母/按相似度 → 레벨순/알파벳순/유사도순

## 검증
- `flutter analyze` 실행 결과 이번 변경과 관련된 오류 없음
- 기존 web 관련 경고는 별도 이슈로 처리 예정

## 참고
- i18n 시스템(app_localizations)과 별도로 하드코딩된 텍스트들을 변경한 것임
- 향후 이러한 하드코딩된 텍스트도 i18n 시스템으로 마이그레이션 검토 필요
