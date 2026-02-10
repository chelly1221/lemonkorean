---
date: 2026-02-10
category: Backend|Mobile|Database
title: SNS Phase 1 검증 및 수정 완료
author: Claude Opus 4.6
tags: [sns, migration, i18n, bugfix]
priority: high
---

# SNS Phase 1 검증 및 수정

## 수정 내용

### 1. DB 마이그레이션 적용 + 테이블명 수정
- `010_add_sns_tables.sql` 실행하여 6개 SNS 테이블 생성
- **테이블명 불일치 발견**: 마이그레이션이 `posts`, `post_comments`로 생성했으나, SNS 서비스 코드는 `sns_posts`, `sns_comments` 참조
- DB에서 `ALTER TABLE RENAME` 실행하여 수정
- 마이그레이션 파일도 올바른 테이블명으로 업데이트

### 2. Nginx 재시작
- SNS 라우팅 설정 적용을 위해 nginx 컨테이너 재시작

### 3. Flutter 컴파일 오류 수정

#### i18n 누락 키 20개 추가 (6개 ARB 파일)
`noFollowingPosts`, `all`, `learning`, `general`, `linkCopied`, `postFailed`, `newPost`, `category`, `writeYourThoughts`, `photos`, `addPhoto`, `imageUrlHint`, `noSuggestions`, `noResults`, `postDetail`, `comments`, `noComments`, `deleteCommentConfirm`, `failedToLoadProfile`, `userNotFound`

#### Duration.clamp() 오류 4곳 수정
Dart `Duration`에 `.clamp()` 메서드 없음 → `Duration(milliseconds: (n).clamp(0, max))` 패턴으로 대체
- `post_card.dart`
- `friend_search_screen.dart` (2곳)
- `post_detail_screen.dart`

## 검증 결과

| 항목 | 결과 |
|------|------|
| DB 테이블 | ✅ 6개 테이블 존재 (sns_posts, sns_comments, post_likes, user_follows, user_blocks, sns_reports) |
| API 엔드포인트 | ✅ `/api/sns/posts/discover` → `{"success":true,"posts":[]}` |
| API 프로필 | ✅ `/api/sns/profiles/1` → 정상 응답 |
| flutter analyze | ✅ SNS 관련 오류 0개 (기존 web Storage/vocabulary_stage 오류만 남음) |
