---
date: 2026-02-26
category: Mobile
title: 커뮤니티 탭 UX 전면 개선 - 에이전트 팀 분석 기반
author: Claude Opus 4.6
tags: [community, ux, accessibility, interaction-design, ui-overhaul]
priority: high
---

## 개요

6명의 전문 에이전트 팀(Mobile UI Designer, Usability Analyst, Interaction Designer, Service Designer, UX Strategist, Leader)이 커뮤니티 탭을 종합 분석하고, 식별된 문제점들을 수정/개선했습니다.

## 수정된 Critical 버그 (3건)

### C1: 댓글 삭제 상태 바이패스
- **파일**: `comment_item.dart`, `post_detail_screen.dart`
- **문제**: `CommentItem`이 `SnsRepository().deleteComment()` 직접 호출하여 부모 상태와 피드 댓글 수 불일치
- **수정**: `onDelete` 콜백 패턴으로 변경, 부모의 `_deleteComment()` 메서드를 통해 상태 동기화

### C2: 피드 에러 상태 미표시
- **파일**: `community_screen.dart`
- **문제**: `FeedProvider.errorMessage`가 UI에서 소비되지 않아 네트워크 오류 시 빈 화면 표시
- **수정**: `_FeedErrorView` 위젯 추가 (wifi_off 아이콘 + 에러 메시지 + 재시도 버튼)

### C3: 접근성 시맨틱 없음
- **파일**: `post_card.dart`, `category_filter_chips.dart`
- **문제**: 모든 커뮤니티 위젯에 `Semantics` 라벨 없음
- **수정**: PostCard, 좋아요/댓글/공유 버튼, 아바타, 카테고리 칩에 시맨틱 라벨 추가

## 주요 UX 개선 사항

### 네비게이션 & 첫 사용자 경험
- **Discover 탭 기본값**: 새 사용자(팔로우 0명)는 Discover 탭으로 시작, 팔로우 포스트가 있으면 Following으로 전환
- **탭 중앙 정렬**: Following/Discover 탭이 오른쪽 정렬에서 중앙으로 변경
- **하드코딩 한국어 수정**: '글쓰기', '게시물', '대화방' → l10n 패턴 적용

### PostCard 개선
- **더블탭 좋아요**: 컨텐츠 영역 더블탭으로 좋아요 + 하트 오버레이 애니메이션 (800ms)
- **햅틱 피드백**: 좋아요, 공유 시 `HapticFeedback.lightImpact()` / `selectionClick()` 추가
- **학습 포스트 시각 구분**: 파란색 왼쪽 보더 (3px) + 연한 파란 배경 (`#F5F9FF`)
- **공유 버튼 수정**: 실제 클립보드 복사 구현 (`Clipboard.setData`)
- **게시물 삭제 메뉴**: 작성자에게 PopupMenuButton (삭제 확인 다이얼로그 포함)
- **아바타 크기 증가**: 36px → 40px
- **액션 행 구분선 제거**: Divider 대신 SizedBox(height: 8)
- **좋아요 버튼 애니메이션**: TweenAnimationBuilder로 1.0→1.3 스케일 애니메이션

### 로딩 & 빈 상태
- **스켈레톤 로딩**: CircularProgressIndicator 대신 3개의 `_SkeletonPostCard` (펄스 애니메이션 0.3-0.7 opacity)
- **Following 빈 상태**: 추천 사용자 3명 인라인 표시 + 팔로우 버튼
- **Discover 빈 상태**: "Be the first to post!" CTA 버튼 추가
- **피드 끝 표시**: "You're all caught up" 인디케이터

### FAB & 스크롤
- **FAB 스크롤 숨김**: 아래로 스크롤 시 AnimatedSlide + AnimatedScale로 FAB 숨김, 위로 스크롤 시 표시
- **음성방 Live 배너**: 활성 음성방이 있으면 피드 상단에 녹색 배너 표시 (참가자 수 + Join 버튼)

### 카테고리 필터 칩
- FilterChip → ChoiceChip 변경 (체크마크 제거)
- 선택 상태 대비 향상 (alpha 0.3 → 0.45, 보더 1.0 → 1.5)
- 시맨틱 라벨 추가

### 댓글 시스템
- **댓글 제출 로딩 상태**: `_isSubmittingComment` 플래그 + 전송 버튼 비활성화/로딩 표시
- **게시물 삭제 UI**: AppBar에 PopupMenuButton + 확인 다이얼로그

### 게시물 작성 화면
- **학습 템플릿**: "Today I Learned", "Practice Writing", "Question" 3종 (learning 카테고리 선택 시)
- **태그 UI**: 최대 5개 태그, 카테고리별 추천 태그, 인라인 입력
- **글자 수 카운터 개선**: 50자 미만 주황색, 20자 미만 빨간색 경고
- **미리보기**: 작성 중 포스트 미리보기 (카테고리 배지 + 내용 2줄 + 태그)

## 수정된 파일

```
mobile/lemon_korean/lib/presentation/screens/
├── community/
│   ├── community_screen.dart          # 전면 개편 (에러, 스켈레톤, FAB, 배너, 빈 상태)
│   └── widgets/
│       ├── post_card.dart             # 전면 개편 (접근성, 더블탭, 학습 보더, 삭제 메뉴)
│       └── category_filter_chips.dart # ChoiceChip + 접근성
├── post_detail/
│   ├── post_detail_screen.dart        # 댓글 로딩, 게시물 삭제 UI
│   └── widgets/
│       ├── comment_item.dart          # onDelete 콜백 패턴
│       └── comment_input.dart         # isSubmitting 지원
└── create_post/
    └── create_post_screen.dart        # 템플릿, 태그, 카운터, 미리보기
```

## 향후 개선 과제 (에이전트 팀 권장)

### 단기 (1-4주)
- 학습 레벨 뱃지를 PostCard 작성자 옆에 표시
- 네이티브 이미지 피커 통합 (현재 URL 수동 입력)
- 음성방을 피드 카드로 표시

### 중기 (1-3개월)
- 커뮤니티 게임화 연동 (포스팅/도움에 레몬 보상)
- AI 한국어 교정 ("Check my Korean" 버튼)
- 게시물 번역 토글
- 언어 필터링 (Discover 탭)

### 장기 (3-12개월)
- 스터디 그룹 기능
- AI 대화 파트너 (빈 음성방)
- 스마트 피드 랭킹 (시간순 → 관련도)
- 커뮤니티 프리미엄 티어
