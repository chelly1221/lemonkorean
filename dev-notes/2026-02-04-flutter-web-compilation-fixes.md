---
date: 2026-02-04
category: Mobile
title: Flutter 웹 컴파일 에러 수정
author: Claude Sonnet 4.5
tags: [web, flutter, compilation, bug-fix]
priority: high
---

# Flutter 웹 컴파일 에러 수정

## 개요
Flutter 웹 빌드 시 발생한 컴파일 에러 3건을 수정하여 빌드 성공.

---

## 1. hangul_shadowing_screen.dart - 누락된 필드

**에러**:
```
Error: The setter '_recordingPath' isn't defined for the type '_HangulShadowingScreenState'.
```

**수정**: `_recordingPath` 필드 선언 추가
```dart
class _HangulShadowingScreenState extends State<HangulShadowingScreen> {
  bool _isSupported = false;
  String? _recordingPath;  // ← 추가
```

---

## 2. writing_canvas.dart - const 표현식 오류

**에러**:
```
Error: Not a constant expression.
canvas.drawLine(Offset(size.width, 0), const Offset(0, size.height), dashedPaint);
```

**수정**: `size.height`는 런타임 값이므로 `const` 제거
```dart
// Before
canvas.drawLine(Offset(size.width, 0), const Offset(0, size.height), dashedPaint);
// After
canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), dashedPaint);
```

---

## 3. download_manager_stub.dart - 메서드 시그니처 불일치

**문제**: 모바일 버전은 `language` 파라미터를 받지만 웹 스텁은 받지 않음.

**수정**:
```dart
// Before
Future<bool> downloadLesson(int lessonId) async { ... }
// After
Future<bool> downloadLesson(int lessonId, {String? language}) async { ... }
```

---

## 검증
- ✅ `flutter build web --release` 성공 (164.3초)
- ✅ 한글 섀도잉 화면 정상 동작
- ✅ 한글 쓰기 캔버스 대각선 그리드 정상 렌더링

**작업 완료**: 2026-02-04
