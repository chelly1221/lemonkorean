---
date: 2026-02-04
category: Mobile
title: 5개 use_build_context_synchronously 경고 수정
author: Claude Sonnet 4.5
tags: [flutter, warnings, async, buildcontext, cleanup]
priority: medium
---

# use_build_context_synchronously 경고 수정

## 개요
Flutter 앱에서 발생하는 5개의 `use_build_context_synchronously` 경고를 수정했습니다. 이 경고는 async 작업 후 BuildContext를 사용할 때 컨텍스트가 무효화될 수 있는 문제를 방지하기 위한 것입니다.

**변경 전**: 108개 경고
**변경 후**: 103개 경고 (5개 제거)

---

## 문제 분석

BuildContext는 다음 상황에서 무효화될 수 있습니다:
- `await` 작업 중 위젯이 dispose됨
- 네비게이션 스택이 변경됨
- 위젯 생명주기가 진행됨

기존 코드는 `if (!mounted) return;`만 사용했으나, 이는 위젯 dispose만 체크하고 async 경계를 넘은 컨텍스트 사용은 체크하지 못합니다.

---

## 수정된 파일 및 패턴

### 패턴 1: Navigator 사용 (2개 경고)

**파일**:
- `lib/presentation/screens/onboarding/level_selection_screen.dart:188`
- `lib/presentation/screens/onboarding/weekly_goal_screen.dart:246`

**수정 방법**:
```dart
// Before
() async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.setUserLevel(_selectedLevel!);

    if (!mounted) return;

    Navigator.push(context, ...); // ❌ WARNING
}

// After
() async {
    final settingsProvider = context.read<SettingsProvider>();
    final navigator = Navigator.of(context); // ✅ async 전에 캡처

    await settingsProvider.setUserLevel(_selectedLevel!);

    if (!mounted) return;

    navigator.push(...); // ✅ 캡처된 NavigatorState 사용
}
```

**원리**: `Navigator.of(context)`는 `NavigatorState` 객체를 반환하며, 이는 컨텍스트가 변경되어도 유효합니다.

---

### 패턴 2: ScaffoldMessenger 사용 (2개 경고)

**파일**: `lib/presentation/widgets/bookmark_button.dart:85, 106`

**수정 방법**:
```dart
// Before
if (success && mounted) {
    await _animationController.forward();
    await _animationController.reverse();

    _showSnackBar(
        AppLocalizations.of(context)!.addedToVocabularyBook, // ❌ WARNING
        isSuccess: true
    );
}

// After
if (success && mounted) {
    final l10n = AppLocalizations.of(context)!; // ✅ async 전에 캡처
    final messenger = ScaffoldMessenger.of(context); // ✅ async 전에 캡처

    await _animationController.forward();
    await _animationController.reverse();

    if (!mounted) return; // ✅ async 후 mounted 체크

    messenger.showSnackBar( // ✅ 캡처된 참조 사용
        SnackBar(
            content: Text(l10n.addedToVocabularyBook),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
        ),
    );
    widget.onBookmarked?.call();
}
```

**추가 변경**:
- `_showSnackBar` 헬퍼 메서드 제거 (더 이상 필요 없음)
- 인라인으로 SnackBar 코드 작성하여 명확성 향상

---

### 패턴 3: Provider 사용 (1개 경고)

**파일**: `lib/presentation/screens/vocabulary_book/vocabulary_book_screen.dart:472`

**수정 방법**:
```dart
// Before
onPressed: () async {
    final confirm = await _showRemoveConfirmation(vocabulary.korean);
    if (confirm == true) {
        context.read<BookmarkProvider>().removeBookmark(bookmark.id); // ❌ WARNING
    }
}

// After
onPressed: () async {
    final bookmarkProvider = context.read<BookmarkProvider>(); // ✅ async 전에 캡처
    final confirm = await _showRemoveConfirmation(vocabulary.korean);

    if (confirm == true && mounted) { // ✅ mounted 체크 추가
        bookmarkProvider.removeBookmark(bookmark.id); // ✅ 캡처된 provider 사용
    }
}
```

**원리**: `context.read<T>()`는 provider 인스턴스를 반환하며, async 경계를 넘어도 유효합니다.

---

## 수정 원칙

### 1. Async 전에 컨텍스트 의존 객체 캡처
```dart
final navigator = Navigator.of(context);
final messenger = ScaffoldMessenger.of(context);
final l10n = AppLocalizations.of(context)!;
final provider = context.read<MyProvider>();
```

### 2. Async 후 mounted 체크
```dart
await someAsyncOperation();

if (!mounted) return; // ✅ 항상 체크
```

### 3. 캡처된 참조 사용
```dart
navigator.push(...);        // ✅ context가 아닌 navigator 사용
messenger.showSnackBar(...); // ✅ context가 아닌 messenger 사용
```

---

## 테스트 결과

### Flutter Analyze
```bash
flutter analyze 2>&1 | grep "use_build_context_synchronously"
# 결과: 0개 (성공)

flutter analyze 2>&1 | grep "issues found"
# 결과: 103 issues found (108에서 5개 감소)
```

### 기능 테스트
✅ 온보딩 플로우 (레벨 선택 → 주간 목표)
✅ 북마크 추가/제거
✅ 단어장 화면에서 북마크 삭제
✅ SnackBar 메시지 표시
✅ 다국어 메시지 표시

---

## 영향 범위

**변경된 파일**: 4개
**제거된 경고**: 5개
**새로운 경고**: 0개
**Breaking Changes**: 없음

---

## 추가 개선 사항

### BookmarkButton 리팩토링
- `_showSnackBar` 헬퍼 메서드 제거
- SnackBar 생성 코드 인라인화
- 코드 중복 증가했지만 async 컨텍스트 처리가 더 명확해짐

---

## 참고

- Flutter의 표준 async 컨텍스트 처리 패턴 적용
- `mounted` 체크는 여전히 중요하며 유지됨
- 모든 변경은 내부 구현 세부사항이며 공개 API에 영향 없음

---

## 다음 단계

나머지 103개 경고 중 다음 우선순위:
1. `prefer_const_constructors` (가장 많은 비중)
2. `prefer_const_declarations`
3. 기타 린트 규칙 위반

---

**검증 완료**: ✅
**프로덕션 배포 준비**: ✅
