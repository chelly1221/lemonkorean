---
date: 2026-02-04
category: Mobile
title: Flutter Web API 마이그레이션 (dart:html → package:web)
author: Claude Sonnet 4.5
tags: [web, flutter, migration, storage-api, notification]
priority: high
---

# Flutter Web API 마이그레이션 (dart:html → package:web)

## 개요
Flutter 3.x의 `package:web`로 마이그레이션하면서 발생한 Storage API 및 Notification API 호환성 문제 수정.

---

## 1. Web Storage API 수정

### 배경
`dart:html`의 Storage API가 `package:web`에서 변경됨. 기존 `.keys`, `.containsKey()`, `.remove()` 메서드 없음.

### API 변경 매핑

| 이전 (dart:html) | 현재 (package:web) |
|---------|---------|
| `storage.keys` | `for (i in 0..<storage.length) storage.key(i)` |
| `storage.containsKey(key)` | `storage.getItem(key) != null` |
| `storage.remove(key)` | `storage.removeItem(key)` |
| `storage[key]` | `storage.getItem(key)` |
| `storage[key] = value` | `storage.setItem(key, value)` |

### 수정된 파일

#### local_storage_stub.dart (15곳)
`_getAllKeys()` 헬퍼 함수 추가:
```dart
static List<String> _getAllKeys() {
  final keys = <String>[];
  final storage = web.window.localStorage;
  for (var i = 0; i < storage.length; i++) {
    final key = storage.key(i);
    if (key != null) keys.add(key);
  }
  return keys;
}
```

#### secure_storage_web.dart (2곳)
`.remove()` → `.removeItem()`, `.containsKey()` → `.getItem() != null`

#### storage_utils_stub.dart (2곳)
동일한 `_getAllKeys()` 헬퍼 패턴 적용.

---

## 2. Notification API 수정

### 파일: notification_web.dart

**문제**: `JSPromise<JSString>.toDart` API 없음
```
Error: The getter 'toDart' isn't defined for the type 'JSPromise<JSString>'.
```

**수정**:
```dart
// Before
final permission = await web.Notification.requestPermission().toDart;

// After
final permission = web.Notification.permission;  // 동기 속성 사용
if (!_permissionGranted && permission == 'default') {
  AppLogger.i('Notification permission is default, user needs to grant permission');
}
```

---

## 검증
- ✅ 웹 빌드 성공
- ✅ localStorage 읽기/쓰기 정상
- ✅ 알림 권한 확인 정상

**작업 완료**: 2026-02-04
