---
date: 2026-02-10
category: Mobile|Backend|Database|Frontend
title: SNS Phase 1 구현 - 피드 + 친구찾기/팔로우
author: Claude Opus 4.6
tags: [sns, community, feed, follow, social, phase1]
priority: high
---

# SNS Phase 1 구현 - 피드 + 친구찾기/팔로우

## 개요

레몬 한국어 앱에 SNS 기능 Phase 1을 구현했습니다:
- **피드**: Following/Discover 탭으로 구분, 학습/일반 카테고리 필터
- **게시글**: 텍스트 + 사진(최대 4장) 게시, 좋아요, 댓글
- **친구찾기**: 유저 검색, 추천 유저, 팔로우/언팔로우
- **모더레이션**: 신고, 차단, Admin 대시보드 관리

## 구현 범위

### 1. DB 마이그레이션 (`database/postgres/migrations/010_add_sns_tables.sql`)
- `users` 테이블 확장 (bio, follower_count, following_count, post_count, is_public, sns_banned)
- 6개 신규 테이블: user_follows, posts, post_likes, post_comments, sns_reports, user_blocks
- 인덱스, 제약 조건, 트리거 포함

### 2. SNS 백엔드 서비스 (`services/sns/`, 포트 3007)
- Node.js Express 기반, 기존 Auth 서비스 패턴 준수
- 24개 파일: config, middleware, models(6), controllers(6), routes(6)
- 주요 API: 피드(cursor 기반), 게시글 CRUD, 댓글, 팔로우, 프로필, 신고, 차단
- JWT 인증 (requireAuth / optionalAuth)
- 이미지는 기존 Media 서비스(MinIO) 재사용

### 3. 인프라
- `docker-compose.yml`: sns-service 컨테이너 추가
- `nginx/nginx.conf`: upstream + location /api/sns/ 추가

### 4. Flutter 앱
**모델** (3개):
- `PostModel`, `CommentModel`, `SnsUserModel` - Hive 불필요 (온라인 전용)

**데이터 레이어**:
- `SnsRepository` - 20개 API 메서드
- `FeedProvider` - Following/Discover 피드, 게시글 CRUD, 좋아요, 댓글
- `SocialProvider` - 유저 검색, 추천, 팔로우, 프로필, 신고, 차단

**화면** (13개 파일):
- `community/` - 피드 메인 (Following/Discover 탭), PostCard, PostImageGrid, CategoryFilterChips
- `create_post/` - 게시글 작성, ImagePickerGrid
- `post_detail/` - 게시글 상세, CommentItem, CommentInput
- `user_profile/` - 타인 프로필, ProfileHeader
- `friend_search/` - 유저 검색, UserSearchCard

**네비게이션**: 3탭 → 4탭 (Home, Community, Review, Profile)

### 5. 다국어 (6개 언어, ~53개 키)
- ko, en, es, ja, zh, zh_TW 모든 ARB 파일에 SNS 문자열 추가
- `flutter gen-l10n` 실행 완료

### 6. Admin 모더레이션
- `services/admin/` - SNS 관리 페이지 (신고 처리, 게시글 삭제, 유저 차단)
- 4개 탭: 통계, 신고, 게시글, 유저

## 설계 결정

| 결정 | 이유 |
|------|------|
| 별도 SNS 서비스 (포트 3007) | 기존 서비스 비대화 방지 |
| Cursor 기반 페이지네이션 | 새 게시글 추가 시에도 일관된 결과 |
| 온라인 전용 (Hive 불사용) | SNS는 네트워크 필수, 오프라인 캐시 불필요 |
| 비정규화 카운터 | 읽기 성능 최적화 (like_count, follower_count 등) |
| 1방향 팔로우 (Instagram 모델) | 상호 친구가 아닌 팔로우 모델 |
| Pull 기반 새로고침 | Phase 2에서 Socket.IO 실시간 추가 예정 |

## 후속 작업

- **Phase 2**: 1:1 텍스트 채팅 (Socket.IO)
- **Phase 3**: 음성대화방 (LiveKit, 셀프호스팅)

## 파일 목록 (신규)

```
database/postgres/migrations/010_add_sns_tables.sql
services/sns/ (24개 파일)
mobile/lemon_korean/lib/data/models/post_model.dart
mobile/lemon_korean/lib/data/models/comment_model.dart
mobile/lemon_korean/lib/data/models/sns_user_model.dart
mobile/lemon_korean/lib/data/repositories/sns_repository.dart
mobile/lemon_korean/lib/presentation/providers/feed_provider.dart
mobile/lemon_korean/lib/presentation/providers/social_provider.dart
mobile/lemon_korean/lib/presentation/screens/community/ (4개)
mobile/lemon_korean/lib/presentation/screens/create_post/ (2개)
mobile/lemon_korean/lib/presentation/screens/post_detail/ (3개)
mobile/lemon_korean/lib/presentation/screens/user_profile/ (2개)
mobile/lemon_korean/lib/presentation/screens/friend_search/ (2개)
services/admin/src/routes/sns-moderation.routes.js
services/admin/src/controllers/sns-moderation.controller.js
services/admin/public/js/pages/sns-moderation.js
```

## 파일 목록 (수정)

```
docker-compose.yml (sns-service 추가)
nginx/nginx.conf (upstream + location 추가)
mobile/lemon_korean/lib/main.dart (FeedProvider, SocialProvider 등록)
mobile/lemon_korean/lib/presentation/screens/home/home_screen.dart (4탭)
mobile/lemon_korean/lib/l10n/app_*.arb (6개 파일, SNS 키 추가)
mobile/lemon_korean/lib/l10n/generated/*.dart (자동 생성)
services/admin/src/index.js (SNS 모더레이션 라우트)
services/admin/public/js/router.js (SNS 페이지)
services/admin/public/js/components/sidebar.js (SNS 메뉴)
services/admin/public/index.html (SNS JS 포함)
```
