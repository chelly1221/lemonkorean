# Lemon Korean - Quick Start Guide

## 빠른 시작 (5분)

### 1. 프로젝트 설정
```bash
cd mobile/lemon_korean
flutter pub get
```

### 2. API URL 설정
`lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'http://localhost'; // 개발 환경
// static const String baseUrl = 'https://api.lemonkorean.com'; // 프로덕션
```

### 3. 실행
```bash
# Android
flutter run

# iOS (macOS only)
flutter run -d ios

# Chrome (웹)
flutter run -d chrome
```

---

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart        # 전역 상수 (API URL, 색상 등)
│   ├── storage/
│   │   ├── local_storage.dart        # Hive 로컬 저장소
│   │   └── database_helper.dart      # SQLite 미디어 DB
│   └── network/
│       └── api_client.dart           # Dio HTTP 클라이언트
├── data/
│   ├── models/                       # 데이터 모델
│   └── repositories/                 # 레포지토리 패턴
├── presentation/
│   ├── screens/
│   │   ├── auth/                     # 로그인/회원가입
│   │   ├── home/                     # 홈 화면
│   │   └── lesson/                   # 레슨 화면 (TODO)
│   ├── providers/                    # Provider 상태 관리
│   │   ├── auth_provider.dart
│   │   ├── lesson_provider.dart
│   │   ├── progress_provider.dart
│   │   └── sync_provider.dart
│   └── widgets/                      # 재사용 위젯
└── main.dart
```

---

## 핵심 개념

### 1. 오프라인 우선
```dart
// 데이터 읽기: 로컬 → 네트워크 → 로컬 저장
final lesson = LocalStorage.getLesson(id) ?? await api.getLesson(id);

// 데이터 쓰기: 로컬 저장 → 동기화 큐 → 네트워크 (나중에)
await LocalStorage.saveProgress(data);
await LocalStorage.addToSyncQueue(data);
```

### 2. Provider 상태 관리
```dart
// Provider 사용
final authProvider = Provider.of<AuthProvider>(context);

// 또는
Consumer<AuthProvider>(
  builder: (context, auth, child) {
    return Text(auth.username ?? 'Guest');
  },
)
```

### 3. API 통신
```dart
// ApiClient 싱글톤 사용
final response = await ApiClient.instance.login(
  email: email,
  password: password,
);
```

---

## 기본 사용법

### 로그인
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final success = await authProvider.login(
  email: 'user@example.com',
  password: 'password123',
);

if (success) {
  // 홈 화면으로 이동
}
```

### 레슨 목록 조회
```dart
final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
await lessonProvider.fetchLessons();

// UI에서 사용
Consumer<LessonProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.lessons.length,
      itemBuilder: (context, index) {
        return LessonCard(lesson: provider.lessons[index]);
      },
    );
  },
)
```

### 동기화
```dart
final syncProvider = Provider.of<SyncProvider>(context);

// 수동 동기화
await syncProvider.forceSync();

// 자동 동기화는 백그라운드에서 자동 실행
```

---

## 다음 단계

### 1. 추가 화면 구현
- [ ] 레슨 상세 화면
- [ ] 7단계 스테이지 화면
- [ ] 진도 통계 화면
- [ ] 설정 화면

### 2. 다운로드 기능
```dart
// core/utils/download_manager.dart
class DownloadManager {
  Future<void> downloadLesson(int lessonId) async {
    // 레슨 패키지 다운로드
    // 미디어 파일 다운로드
    // 로컬 저장
  }
}
```

### 3. 미디어 재생
```dart
// audioplayers 사용
final player = AudioPlayer();
await player.play(UrlSource(audioUrl));
```

### 4. 이미지 로딩
```dart
// cached_network_image 사용
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

## 문제 해결

### Flutter 버전 확인
```bash
flutter --version
# Flutter 3.0 이상 필요
```

### 패키지 설치 에러
```bash
flutter clean
flutter pub get
```

### iOS 빌드 에러
```bash
cd ios
pod install
cd ..
flutter run
```

### Android 빌드 에러
```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

## 유용한 명령어

```bash
# Hot reload (개발 중)
r

# Hot restart
R

# 디버그 정보
flutter doctor

# 연결된 기기 확인
flutter devices

# 로그 확인
flutter logs

# APK 빌드
flutter build apk

# 코드 포맷팅
dart format lib/

# 정적 분석
flutter analyze
```

---

## 추천 VS Code 확장

- Flutter
- Dart
- Awesome Flutter Snippets
- Flutter Widget Snippets
- Pubspec Assist

---

## 개발 팁

1. **Hot Reload 활용**: 코드 변경 후 `r` 키로 즉시 반영
2. **DevTools 사용**: 성능 및 메모리 분석
3. **Provider 디버깅**: `Provider.debugCheckInvalidValueType` 활성화
4. **로그 출력**: `debugPrint()` 사용 (프로덕션에서 자동 제거)

---

## 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Provider 패키지](https://pub.dev/packages/provider)
- [Dio HTTP](https://pub.dev/packages/dio)
- [Hive DB](https://pub.dev/packages/hive)

---

## 지원

문제가 있으면 이슈를 등록해주세요!
