---
date: 2026-02-04
category: Mobile
title: Android 한글 쓰기연습 빈 대화상자 버그 수정
author: Claude Sonnet 4.5
tags: [flutter, android, hangul, bugfix, ui, race-condition]
priority: high
---

# Android 한글 쓰기연습 빈 대화상자 버그 수정

## 문제 요약

Android 앱에서 사용자가 한글 탭 → Activities 탭 → "한글 쓰기연습" 카드를 탭하면 빈 대화상자가 표시되는 버그가 발생했습니다. 웹 버전에서는 동일한 기능이 정상 작동했습니다.

## 근본 원인

### 레이스 컨디션 (Race Condition)

**기존 흐름:**
1. `HangulMainScreen` `initState()` → `_loadData()` → `provider.loadAlphabetTable()` 호출
2. 사용자가 "쓰기연습"을 빠르게 탭
3. `_showWritingCharacterDialog()` → `provider.allCharacters` 호출
4. **데이터 로딩 중이면 `characters.length == 0`** → 빈 대화상자 표시

### 웹 vs Android 차이

- **웹**:
  - 네트워크 응답 빠름
  - 브라우저 localStorage 캐시 활용
  - 데이터 로딩 완료 후 사용자 클릭 가능성 높음

- **Android**:
  - 네트워크 응답 상대적으로 느림
  - 첫 실행 시 Hive 로컬 캐시 비어있음
  - 사용자가 데이터 로딩 완료 전에 빠르게 탭할 가능성 높음

## 솔루션 설계

### 스마트 대화상자 (Smart Dialog) 접근법

단일 대화상자가 `HangulProvider`의 상태를 관찰하며 자동으로 UI를 전환하는 방식을 채택했습니다.

**대화상자 상태 처리:**
1. **로딩 중 (`isLoading`)**: CircularProgressIndicator + "Loading..." 메시지 표시
2. **에러 발생 (`loadingState == error`)**: 에러 아이콘 + 에러 메시지 + "Retry" 버튼
3. **데이터 없음 (`allCharacters.isEmpty`)**: 폴더 아이콘 + "No characters available" + "Reload" 버튼
4. **로드 완료 (그 외)**: 문자 그리드 표시 (기존 동작)

### 구현 세부사항

#### 1. Consumer 패턴 사용

```dart
showDialog(
  context: context,
  barrierDismissible: false, // 로딩 중 실수로 닫히지 않도록
  builder: (dialogContext) => Consumer<HangulProvider>(
    builder: (context, provider, child) {
      // Provider 상태 변화를 자동으로 감지하여 UI 업데이트
      ...
    },
  ),
);
```

#### 2. 상태별 UI 구성

**로딩 상태:**
- `provider.isLoading` 체크
- 중앙에 CircularProgressIndicator + 텍스트
- 액션 버튼 없음 (닫기 불가)

**에러 상태:**
- `provider.loadingState == HangulLoadingState.error` 체크
- 에러 아이콘 + `provider.errorMessage` 표시
- "Cancel" + "Retry" 버튼
- Retry 시 `provider.loadAlphabetTable()` 재호출

**빈 데이터 상태:**
- `provider.allCharacters.isEmpty` 체크
- 폴더 아이콘 + "No characters available" 메시지
- "Cancel" + "Reload" 버튼
- Reload 시 `provider.loadAlphabetTable()` 재호출

**정상 로드 상태:**
- 기존과 동일한 5열 GridView
- 각 문자 탭 시 → Writing Canvas 화면으로 이동

## 변경된 파일

### 1. hangul_main_screen.dart

**위치**: `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_main_screen.dart`

**변경 내용:**
- `_showWritingCharacterDialog()` 메서드 완전 재작성
- `Consumer<HangulProvider>` 패턴으로 상태 관찰
- 4가지 상태에 따른 동적 UI 렌더링
- `barrierDismissible: false` 설정으로 로딩 중 닫힘 방지

**라인 수:** ~130줄 (기존 63줄 → 193줄)

### 2. 다국어 지원 파일 (6개 언어)

**추가된 키:**
- `errorOccurred`: "An error occurred" / "오류가 발생했습니다" / etc.
- `reload`: "Reload" / "다시 불러오기" / etc.
- `noCharactersAvailable`: "No characters available" / "사용 가능한 문자가 없습니다" / etc.

**파일 목록:**
- `app_en.arb` (영어)
- `app_ko.arb` (한국어)
- `app_es.arb` (스페인어)
- `app_ja.arb` (일본어)
- `app_zh.arb` (중국어 간체)
- `app_zh_TW.arb` (중국어 번체)

**기존 키 재사용:**
- `loading`: "Loading..." / "로딩 중..."
- `cancel`: "Cancel" / "취소"
- `retry`: "Retry" / "재시도"

## 테스트 시나리오

### 1. 첫 실행 (빈 캐시)

**이전:**
- 앱 설치 후 첫 실행 → 한글 탭 → Activities → 쓰기연습 빠르게 탭
- **결과**: 빈 대화상자 ❌

**수정 후:**
- 동일한 단계
- **결과**: "Loading..." 표시 → 자동으로 문자 그리드로 전환 ✅

### 2. 네트워크 오프라인

**이전:**
- 네트워크 끔 → 쓰기연습 탭
- **결과**: 빈 대화상자 또는 에러 미처리 ❌

**수정 후:**
- 네트워크 끔 → 쓰기연습 탭
- **결과**:
  - 캐시 데이터 있으면 → 문자 그리드 표시 ✅
  - 캐시 없으면 → 에러 메시지 + Retry 버튼 ✅

### 3. 빠른 탭 테스트

**이전:**
- 앱 시작 후 즉시 한글 탭 → Activities → 쓰기연습 빠르게 탭
- **결과**: 레이스 컨디션으로 빈 대화상자 ❌

**수정 후:**
- 동일한 단계
- **결과**: 로딩 상태 감지 후 자동으로 UI 전환 ✅

### 4. 정상 케이스 (캐시된 데이터)

**이전:**
- 데이터 로드 완료 후 쓰기연습 탭
- **결과**: 문자 그리드 표시 ✅

**수정 후:**
- 동일한 동작
- **결과**: 문자 그리드 표시 (회귀 없음) ✅

### 5. 웹 플랫폼

**확인 사항:**
- 웹에서 기존 동작 유지 확인
- 모든 상태 전환이 웹에서도 정상 작동 확인

## 기술적 이점

### 1. 자동 상태 동기화

`Consumer` 패턴 사용으로 Provider 상태 변화 시 대화상자가 자동으로 업데이트됩니다. 별도의 리스너나 콜백 관리가 불필요합니다.

### 2. 단일 대화상자 전략

여러 대화상자를 겹쳐서 표시하는 대신 하나의 대화상자가 내부 상태를 전환하므로:
- UX가 더 부드러움
- 대화상자 스택 관리 불필요
- 메모리 효율적

### 3. 에러 복구 메커니즘

"Retry" 버튼으로 사용자가 직접 데이터 재로드를 시도할 수 있어 네트워크 문제 발생 시 앱 재시작 불필요합니다.

### 4. 오프라인 우선 아키텍처 활용

`HangulRepository`의 기존 오프라인 캐시 메커니즘을 그대로 활용하며, UI 레이어에서만 상태 표시를 개선했습니다.

## Edge Cases 처리

### 1. Provider null 체크
- `Consumer` 사용으로 Provider 자동 주입 → null 발생 불가

### 2. 로딩 중 대화상자 닫기
- `barrierDismissible: false`로 로딩 중 실수로 닫히는 것 방지

### 3. 여러 번 Retry 실패
- 각 Retry마다 `loadAlphabetTable()` 재호출
- Repository 레벨에서 캐시 fallback 처리

### 4. 대화상자 열린 상태에서 데이터 로드 완료
- `Consumer`가 자동으로 Provider 변화 감지하여 UI 업데이트

## 성능 영향

- **최소**: 대화상자 내에서만 `Consumer` 사용
- **메모리**: 단일 대화상자 재사용으로 메모리 효율적
- **CPU**: 상태 변화 시에만 rebuild (Provider 최적화)

## 호환성

- **Flutter 버전**: 3.x 이상
- **플랫폼**: Android, iOS, Web 모두 지원
- **하위 호환성**: 기존 코드와 완전 호환 (API 변경 없음)

## 후속 작업 제안

### 1. 다른 대화상자에도 패턴 적용

한글 모듈의 다른 기능 대화상자에도 동일한 Smart Dialog 패턴 적용 고려.

### 2. 로딩 최적화

앱 시작 시 백그라운드에서 한글 데이터 미리 로드하여 첫 탭 시 즉시 표시.

```dart
// main.dart에서
Future<void> _preloadHangulData() async {
  final hangulProvider = Provider.of<HangulProvider>(context, listen: false);
  await hangulProvider.loadAlphabetTable();
}
```

### 3. 프로그레스 피드백 개선

로딩 중 "Loading 14/40 characters..." 같은 진행률 표시 추가.

## 결론

이번 수정으로 Android 앱의 한글 쓰기연습 기능이 모든 네트워크 상태와 타이밍 조건에서 안정적으로 작동하게 되었습니다. 특히 첫 실행이나 느린 네트워크 환경에서 사용자 경험이 크게 개선되었습니다.

**핵심 개선점:**
- ✅ 레이스 컨디션 완전 해결
- ✅ 로딩/에러/빈 데이터 상태 명확히 표시
- ✅ 사용자가 에러 복구 가능 (Retry 버튼)
- ✅ 코드 가독성 및 유지보수성 향상
- ✅ 웹 플랫폼 호환성 유지

**변경 범위:**
- 파일 수: 7개 (1 Dart + 6 i18n)
- 코드 변경: ~130줄
- Breaking changes: 없음
- 하위 호환성: 100%
