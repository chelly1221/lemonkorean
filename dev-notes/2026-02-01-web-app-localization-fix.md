---
date: 2026-02-01
category: Mobile
title: 웹 앱 언어 설정 미적용 버그 수정
author: Claude Opus 4.5
tags: [bugfix, localization, i18n, web, flutter]
priority: medium
---

# 웹 앱 언어 설정 미적용 버그 수정

## 개요
웹 버전에서 언어 설정을 변경해도 홈 화면의 네비게이션 바, 섹션 헤더, 메뉴 항목 등에 적용되지 않는 버그를 수정했습니다.

## 문제점 / 배경

### 증상
- 웹 앱에서 설정 → 언어 설정에서 언어를 변경해도 홈 화면의 UI 텍스트가 변경되지 않음
- 하단 네비게이션 바 라벨이 중국어로 고정
- 홈, 복습, 프로필 탭의 섹션 헤더와 메뉴 항목들이 중국어로 고정

### 원인
`home_screen.dart` 파일에서 모든 UI 텍스트가 `AppLocalizations`를 사용하지 않고 **하드코딩된 중국어 문자열**을 사용하고 있었음:
- 네비게이션 바: `'首页'`, `'复习'`, `'我的'`
- 홈 탭: `'继续学习'`, `'所有课程'`, `'筛选'`
- 복습 탭: `'复习计划'`, `'今日复习'`, `'开始复习'`
- 프로필 탭: `'学习统计'`, `'已完成课程'`, `'设置'`, `'退出登录'` 등

## 해결 방법 / 구현

### 1. 누락된 ARB 키 추가
6개의 ARB 파일(zh, zh_TW, en, ko, ja, es)에 다음 키들을 추가:

| 키 | 중국어 (zh) | 영어 (en) | 한국어 (ko) |
|---|---|---|---|
| `filter` | 筛选 | Filter | 필터 |
| `reviewSchedule` | 复习计划 | Review Schedule | 복습 계획 |
| `todayReview` | 今日复习 | Today's Review | 오늘의 복습 |
| `startReview` | 开始复习 | Start Review | 복습 시작 |
| `learningStats` | 学习统计 | Learning Statistics | 학습 통계 |
| `completedLessonsCount` | 已完成课程 | Completed Lessons | 완료한 강의 |
| `studyDays` | 学习天数 | Study Days | 학습 일수 |
| `masteredWordsCount` | 掌握单词 | Mastered Words | 습득 단어 |
| `myVocabularyBook` | 我的单词本 | My Vocabulary Book | 나의 단어장 |
| `vocabularyBrowser` | 单词浏览器 | Vocabulary Browser | 단어 브라우저 |
| `about` | 关于 | About | 정보 |
| `premiumMember` | 高级会员 | Premium Member | 프리미엄 회원 |
| `freeUser` | 免费用户 | Free User | 무료 사용자 |
| `wordsWaitingReview` | {count}个单词等待复习 | {count} words waiting for review | {count}개 단어 복습 대기 중 |
| `user` | 用户 | User | 사용자 |

### 2. home_screen.dart 수정
하드코딩된 중국어 문자열을 `AppLocalizations` 호출로 교체:

```dart
// Before: 하드코딩된 문자열
NavigationDestination(
  label: '首页',
  tooltip: '홈',
),

// After: AppLocalizations 사용
NavigationDestination(
  label: l10n?.home ?? 'Home',
),
```

### 3. BilingualText 위젯 제거
`BilingualText`와 `InlineBilingualText` 위젯을 사용하는 대신 단순 `Text` 위젯과 `AppLocalizations`를 사용:

```dart
// Before: BilingualText 위젯
BilingualText(
  chinese: '学习统计',
  korean: '학습 통계',
  chineseStyle: TextStyle(...),
),

// After: 단순 Text + AppLocalizations
Text(
  l10n?.learningStats ?? 'Learning Statistics',
  style: TextStyle(...),
),
```

## 변경된 파일

### ARB 파일 (6개)
- `/mobile/lemon_korean/lib/l10n/app_zh.arb` - 중국어 간체
- `/mobile/lemon_korean/lib/l10n/app_zh_TW.arb` - 중국어 번체
- `/mobile/lemon_korean/lib/l10n/app_en.arb` - 영어
- `/mobile/lemon_korean/lib/l10n/app_ko.arb` - 한국어
- `/mobile/lemon_korean/lib/l10n/app_ja.arb` - 일본어
- `/mobile/lemon_korean/lib/l10n/app_es.arb` - 스페인어

### Dart 파일 (1개)
- `/mobile/lemon_korean/lib/presentation/screens/home/home_screen.dart` - 홈 화면 전체 로컬라이제이션 적용

## 코드 예시

### 네비게이션 바 수정
```dart
// Before
bottomNavigationBar: NavigationBar(
  destinations: [
    NavigationDestination(label: '首页', tooltip: '홈'),
    NavigationDestination(label: '复习', tooltip: '복습'),
    NavigationDestination(label: '我的', tooltip: '내 정보'),
  ],
),

// After
bottomNavigationBar: Builder(
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    return NavigationBar(
      destinations: [
        NavigationDestination(label: l10n?.home ?? 'Home'),
        NavigationDestination(label: l10n?.review ?? 'Review'),
        NavigationDestination(label: l10n?.profile ?? 'Profile'),
      ],
    );
  },
),
```

### 복습 탭 수정
```dart
// Before
const BilingualText(
  chinese: '今日复习',
  korean: '오늘의 복습',
),

// After
Text(
  l10n?.todayReview ?? "Today's Review",
  style: const TextStyle(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.bold,
  ),
),
```

### 로그아웃 다이얼로그 수정
```dart
// Before
AlertDialog(
  title: const Text('确认退出'),
  content: const Text('确定要退出登录吗？'),
  actions: [
    TextButton(child: const Text('取消')),
    TextButton(child: const Text('确定')),
  ],
),

// After
AlertDialog(
  title: Text(dialogL10n?.logout ?? 'Log Out'),
  content: Text(dialogL10n?.confirmLogout ?? 'Are you sure you want to log out?'),
  actions: [
    TextButton(child: Text(dialogL10n?.cancel ?? 'Cancel')),
    TextButton(child: Text(dialogL10n?.confirm ?? 'Confirm')),
  ],
),
```

## 테스트

### 웹 앱 테스트 방법
1. 웹 앱 접속: https://lemon.3chan.kr/app/
2. 설정 → 언어 설정에서 언어 변경 (영어, 한국어, 일본어, 스페인어)
3. 다음 항목이 변경되는지 확인:
   - 하단 네비게이션 바 라벨 (홈, 복습, 내 정보)
   - 홈 탭: "수업" 섹션 헤더, "필터" 버튼
   - 복습 탭: "복습 계획" 헤더, "오늘의 복습" 카드, "복습 시작" 버튼
   - 프로필 탭: 모든 섹션 헤더와 메뉴 항목
   - 로그아웃 다이얼로그

### 빌드 명령어
```bash
cd mobile/lemon_korean
flutter gen-l10n
flutter build web --release
docker compose restart nginx
```

## 관련 이슈 / 참고사항

- 이 수정은 `BilingualText` 위젯 사용 패턴에서 표준 `AppLocalizations` 패턴으로 전환하는 작업입니다
- 향후 다른 화면들도 같은 패턴으로 수정이 필요할 수 있습니다
- 중국어 간체/번체 설정은 별도의 `ChineseConverter`를 통해 처리되며, 이 수정과는 독립적입니다
- 지원 언어: 중국어(간체/번체), 영어, 한국어, 일본어, 스페인어
