---
date: 2026-02-07
category: Mobile
title: 하단 네비게이션 UI 업데이트 - 프로필 아이콘 및 노란색 원형 인디케이터
author: Claude Sonnet 4.5
tags: [ui, navigation, theme, web, material3]
priority: medium
---

## 변경 사항

1. **프로필 탭 아이콘 변경**: `Icons.person` → `Icons.account_circle`
2. **선택된 탭에 노란색 원형 인디케이터 추가**: 레몬 테마(#FFEF5F) 강화
3. **모든 아이콘을 기본적으로 filled 스타일로 변경**: outlined → filled (더 명확한 시각적 표현)

## 배경

웹앱의 하단 네비게이션 UI 개선 요청:
- 프로필 탭 아이콘을 더 눈에 띄는 디자인으로 교체
- 선택된 탭을 시각적으로 명확하게 표시하여 UX 향상
- 앱의 브랜드 아이덴티티(레몬 = 노란색) 강화

## 구현 방법

### 1. 모든 아이콘을 filled 스타일로 변경

**파일**: `lib/presentation/screens/home/home_screen.dart`

모든 네비게이션 아이콘을 기본적으로 filled 스타일로 변경:

```dart
// Home 탭
NavigationDestination(
  icon: const Icon(Icons.school),
  selectedIcon: const Icon(Icons.school),
  label: l10n?.home ?? 'Home',
),

// Review 탭
NavigationDestination(
  icon: const Icon(Icons.replay),
  selectedIcon: const Icon(Icons.replay),
  label: l10n?.review ?? 'Review',
),

// Profile 탭
NavigationDestination(
  icon: const Icon(Icons.account_circle),
  selectedIcon: const Icon(Icons.account_circle),
  label: l10n?.profile ?? 'Profile',
),
```

**변경 내용**:
- Home: `Icons.school_outlined` → `Icons.school`
- Review: `Icons.replay_outlined` → `Icons.replay`
- Profile: `Icons.person_outlined` → `Icons.account_circle`

**근거**:
- Filled 아이콘이 시각적으로 더 명확하고 눈에 잘 띔
- 노란색 원형 인디케이터가 선택 상태를 명확히 표시하므로 outlined/filled 구분 불필요
- 더 대담하고 현대적인 디자인
- `account_circle` 아이콘은 프로필 섹션의 표준 디자인
- 원형 모티브가 노란색 원형 인디케이터와 일관성 유지

### 2. NavigationBarTheme 커스터마이징

**파일**: `lib/presentation/providers/theme_provider.dart`

Material 3의 `NavigationBarThemeData`에 다음 설정 추가:

```dart
navigationBarTheme: NavigationBarThemeData(
  backgroundColor: theme.cardBackgroundCol,
  indicatorColor: theme.primary.withOpacity(0.3), // 노란색 원 (30% 투명도)
  indicatorShape: const CircleBorder(), // 완벽한 원형
  elevation: 8.0,
  height: 80.0,
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
    if (states.contains(MaterialState.selected)) {
      return IconThemeData(
        color: theme.textPrimaryCol, // 선택된 아이콘은 어두운 색
        size: 28.0,
      );
    }
    return IconThemeData(
      color: theme.textSecondaryCol, // 선택 안 된 아이콘은 회색
      size: 24.0,
    );
  }),
  labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
    if (states.contains(MaterialState.selected)) {
      return TextStyle(
        color: theme.textPrimaryCol,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
      );
    }
    return TextStyle(
      color: theme.textSecondaryCol,
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
    );
  }),
),
```

**설계 결정**:
- **indicatorColor**: primary 색상(레몬 옐로우 #FFEF5F)을 30% 투명도로 사용하여 은은한 배경 생성
- **indicatorShape**: `CircleBorder()`로 완벽한 원형 표시
- **아이콘 크기**: 선택된 아이콘을 28px로 약간 크게 표시하여 강조
- **색상 대비**: 노란색 배경에 어두운 아이콘(textPrimaryCol)을 사용하여 가독성 확보
- **접근성**: 라벨을 항상 표시(`alwaysShow`)하여 접근성 향상

## 수정된 파일

1. `lib/presentation/screens/home/home_screen.dart` (Line 75-77)
   - 프로필 아이콘을 `account_circle`로 변경

2. `lib/presentation/providers/theme_provider.dart` (Line 279-319)
   - `NavigationBarThemeData` 추가
   - 중앙화된 테마 관리

## 기술적 장점

✅ **Material 3 네이티브 기능 활용**: 기존 애니메이션 및 접근성 유지
✅ **최소한의 코드 변경**: 2개 파일만 수정
✅ **중앙화된 테마 관리**: ThemeProvider에서 일괄 관리
✅ **크로스 플랫폼 일관성**: 웹/모바일 동일한 코드베이스
✅ **성능 오버헤드 없음**: 순수 테마 설정만 사용
✅ **쉬운 롤백 가능**: UI 변경만으로 데이터/API 영향 없음

## 트러블슈팅: 녹색 인디케이터 문제

**문제**: 초기 배포 후 노란색 대신 녹색 원형 인디케이터가 표시됨

**원인**: Material 3의 NavigationBar가 ColorScheme의 `secondaryContainer` 색상을 기본값으로 사용. 초기 설정에서 secondary 색상(녹색 #4CAF50)에서 파생된 색상이 적용됨

**해결책**: ColorScheme에 `secondaryContainer` 명시적 설정 추가
```dart
colorScheme: ColorScheme.light(
  primary: theme.primary,
  secondary: theme.secondary,
  // ...
  secondaryContainer: theme.primary.withOpacity(0.3), // 노란색 강제 적용
),
```

**최종 인디케이터 색상**: `theme.primary.withOpacity(0.3)` (레몬 옐로우 #FFEF5F, 30% 투명도)

## 배포

```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_web.sh
```

웹 앱 배포 완료: https://lemon.3chan.kr/app/

### 캐시 관리 개선 (추가 작업)

**문제**: Nginx가 `main.dart.js` 등 정적 자산을 7일간 캐시하여 배포 후 변경사항이 즉시 반영되지 않음

**해결책**: `build_web.sh` 스크립트 업데이트 및 `CLAUDE.md` 문서화

**변경 내용**:
1. `build_web.sh`에 자동 캐시 클리어 추가:
   - `version.json`에 빌드 타임스탬프 및 고유 빌드 번호 추가
   - Nginx 캐시 디렉토리 자동 정리 (`/var/cache/nginx/`)
   - 배포 후 사용자에게 하드 리프레시 안내 메시지 출력

2. `CLAUDE.md`에 "웹 앱 캐시 관리" 섹션 추가:
   - 캐시 문제 설명 및 해결 방법
   - 자동/수동 캐시 클리어 가이드
   - 사용자 측 브라우저 캐시 클리어 방법

**수정 파일**:
- `mobile/lemon_korean/build_web.sh`: 캐시 클리어 로직 추가
- `CLAUDE.md`: 웹 앱 캐시 관리 섹션 추가

## 검증 체크리스트

### 시각적 검증
- [x] 프로필 탭 아이콘이 `account_circle` 디자인으로 변경됨
- [x] 선택된 탭 뒤에 노란색 원형 인디케이터가 표시됨
- [x] 원형 인디케이터가 아이콘 중앙에 정렬됨
- [x] 탭 전환 시 원이 부드럽게 이동함 (Material 3 애니메이션)

### 기능 테스트
- [x] 3개 탭(Home, Review, Profile)을 각각 클릭하여 전환 확인
- [x] 탭 라벨이 모든 탭에서 표시됨
- [x] 선택된 아이콘이 더 크고 어두운 색으로 표시됨 (28px)
- [x] 선택 안 된 아이콘이 회색으로 표시됨 (24px)

### 접근성
- [x] 색상 대비 충분함 (어두운 아이콘 on 노란색 배경)
- [x] 라벨이 항상 표시되어 접근성 향상

## 향후 개선 가능 사항

1. **투명도 조정**: 필요 시 `theme.primary.withOpacity(0.3)`의 투명도 조정 가능
   - 더 은은하게: `0.2`
   - 더 뚜렷하게: `0.4`

2. **플랫폼별 스타일**: 필요 시 `kIsWeb` 조건문으로 웹/모바일 차별화 가능

## 롤백 계획

문제 발생 시:
1. 아이콘 롤백: `Icons.account_circle` → `Icons.person`
2. 테마 롤백: `navigationBarTheme` 전체 삭제
3. 웹 재배포: `./build_web.sh` 실행

## 기술 스택

- Flutter Material 3
- NavigationBar 위젯
- ThemeData 커스터마이징
- MaterialStateProperty (동적 스타일)

## 결론

Material 3의 강력한 테마 시스템을 활용하여 최소한의 변경으로 최대의 시각적 효과를 달성했습니다. 레몬 브랜드 아이덴티티를 강화하면서도 접근성과 성능을 유지하는 깔끔하고 유지보수 가능한 솔루션입니다.
