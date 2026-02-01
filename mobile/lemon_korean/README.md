# Lemon Korean Mobile App (柠檬韩语)

중국어 화자를 위한 한국어 학습 앱 - Flutter 모바일 애플리케이션

## 프로젝트 개요

**핵심 특징:**
- 📱 오프라인 우선 (Offline-First) 아키텍처
- 🔄 자동 동기화 시스템
- 📦 레슨 다운로드 및 오프라인 학습
- 🎯 7단계 몰입형 학습 경험
- 🧠 SRS (Spaced Repetition System) 복습
- 🎨 Material Design 3

---

## 기술 스택

### 프레임워크
- **Flutter**: 3.0+
- **Dart**: 3.0+

### 주요 패키지
- `dio`: HTTP 클라이언트
- `hive_flutter`: 로컬 NoSQL 데이터베이스
- `sqflite`: SQLite 데이터베이스 (미디어 메타데이터)
- `flutter_secure_storage`: 보안 저장소 (토큰)
- `provider`: 상태 관리
- `connectivity_plus`: 네트워크 상태 감지
- `audioplayers`: 오디오 재생
- `cached_network_image`: 이미지 캐싱

---

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart      # API 엔드포인트
│   │   ├── app_constants.dart      # 앱 전역 상수
│   │   └── settings_keys.dart      # SharedPreferences 키
│   ├── storage/
│   │   ├── local_storage.dart      # Hive 로컬 저장소
│   │   └── database_helper.dart    # SQLite 헬퍼
│   ├── network/
│   │   └── api_client.dart         # Dio API 클라이언트
│   ├── platform/                   # 플랫폼 추상화 (22개 파일)
│   │   ├── interfaces/             # 5개 인터페이스
│   │   ├── io/                     # 4개 모바일 구현
│   │   └── web/                    # 13개 웹 스텁/구현
│   ├── services/
│   │   └── notification_service.dart  # 푸시 알림
│   └── utils/
│       ├── download_manager.dart   # 다운로드 관리
│       ├── sync_manager.dart       # 동기화 관리
│       ├── media_loader.dart       # 미디어 로딩
│       ├── media_helper.dart       # 미디어 헬퍼
│       ├── chinese_converter.dart  # 간체/번체 변환
│       └── storage_utils.dart      # 저장소 유틸
├── data/
│   ├── models/                     # 데이터 모델
│   └── repositories/               # 레포지토리 패턴
├── presentation/
│   ├── screens/
│   │   ├── auth/                   # 인증 화면
│   │   ├── home/                   # 홈 화면
│   │   ├── lesson/                 # 레슨 화면
│   │   │   └── stages/             # 7단계 레슨
│   │   │       └── quiz/           # 5개 퀴즈 유형
│   │   ├── download/               # 다운로드 관리
│   │   ├── profile/                # 프로필
│   │   ├── review/                 # SRS 복습
│   │   ├── settings/               # 설정 화면 (4개)
│   │   ├── stats/                  # 통계 화면 (2개)
│   │   ├── vocabulary_book/        # 단어장 (2개)
│   │   └── vocabulary_browser/     # 단어 검색
│   ├── providers/                  # 상태 관리 (8개 Providers)
│   └── widgets/                    # 재사용 위젯
├── l10n/                           # 다국어 지원 (6개 언어)
│   ├── app_zh.arb                  # 중국어 간체
│   ├── app_zh_TW.arb               # 중국어 번체
│   ├── app_ko.arb                  # 한국어
│   ├── app_en.arb                  # 영어
│   ├── app_ja.arb                  # 일본어
│   ├── app_es.arb                  # 스페인어
│   └── generated/                  # 자동 생성된 클래스
└── main.dart                       # 앱 진입점
```

**총 Dart 파일 수**: 115개 (104 소스 + 5 생성 + 6 l10n)

---

## 시작하기

### 1. 환경 설정

```bash
# Flutter SDK 설치 확인
flutter --version

# 의존성 설치
cd mobile/lemon_korean
flutter pub get
```

### 2. API 엔드포인트 설정

`lib/core/constants/app_constants.dart` 파일에서 API URL 설정:

```dart
static const String baseUrl = 'http://your-api-url';
```

### 3. 앱 실행

```bash
# 연결된 기기 확인
flutter devices

# Android 실행
flutter run

# iOS 실행 (macOS only)
flutter run -d ios

# 웹 실행
flutter run -d chrome
```

---

## 핵심 기능

### 1. 오프라인 우선 아키텍처

```dart
// 데이터 조회 패턴
Future<Lesson> getLesson(int id) async {
  // 1. 로컬에서 먼저 찾기
  final localLesson = LocalStorage.getLesson(id);
  if (localLesson != null) return localLesson;

  // 2. 네트워크에서 가져오기
  final networkLesson = await apiClient.getLesson(id);

  // 3. 로컬에 저장
  await LocalStorage.saveLesson(networkLesson);

  return networkLesson;
}
```

### 2. 자동 동기화

```dart
// 사용자 동작 → 로컬 저장 → 동기화 큐
await LocalStorage.saveProgress(progress);
await LocalStorage.addToSyncQueue({
  'type': 'lesson_complete',
  'data': progress,
});

// 네트워크 복구 시 자동 동기화
SyncProvider.sync();
```

### 3. 레슨 다운로드

```dart
// 레슨 패키지 다운로드
final package = await apiClient.downloadLessonPackage(lessonId);

// 미디어 파일 다운로드
for (final media in package['media_urls']) {
  await DownloadManager.downloadMedia(media);
}
```

---

## 상태 관리 (Provider)

### AuthProvider
- 로그인/로그아웃
- JWT 토큰 관리
- 사용자 정보

### LessonProvider
- 레슨 목록 조회
- 레슨 상세 정보
- 레슨 다운로드

### ProgressProvider
- 학습 진도 관리
- 레슨 완료 처리
- 복습 스케줄

### SyncProvider
- 오프라인 데이터 동기화
- 네트워크 상태 감지
- 동기화 큐 관리

---

## 로컬 저장소

### Hive (NoSQL)
```dart
// 레슨 데이터
LocalStorage.saveLesson(lesson);
LocalStorage.getLesson(lessonId);

// 진도 데이터
LocalStorage.saveProgress(progress);
LocalStorage.getProgress(lessonId);

// 동기화 큐
LocalStorage.addToSyncQueue(syncItem);
LocalStorage.getSyncQueue();
```

### SQLite (미디어 메타데이터)
```dart
// 미디어 파일 매핑
DatabaseHelper.insertMediaFile({
  'remote_key': 'images/lesson1.jpg',
  'local_path': '/storage/lesson1.jpg',
  'file_size': 1024000,
});

// 로컬 경로 조회
final localPath = await DatabaseHelper.getLocalPath('images/lesson1.jpg');
```

---

## API 통신

### Dio 인터셉터

```dart
// 1. Auth Interceptor - JWT 자동 추가
dio.interceptors.add(AuthInterceptor());

// 2. Logging Interceptor - 디버그 로깅
dio.interceptors.add(LoggingInterceptor());

// 3. Error Interceptor - 에러 처리
dio.interceptors.add(ErrorInterceptor());
```

### API 예제

```dart
// 로그인
final response = await apiClient.login(
  email: 'user@example.com',
  password: 'password123',
);

// 레슨 목록
final lessons = await apiClient.getLessons(level: 1);

// 진도 동기화
await apiClient.syncProgress(progressData);
```

---

## 웹 플랫폼 지원 (2026-01-31 추가)

### 개요
Flutter 앱은 웹 플랫폼도 지원합니다. 웹 버전은 브라우저 `localStorage`를 사용하여 모바일과 동일한 오프라인 우선 경험을 제공합니다.

### 웹 스텁 아키텍처

웹 빌드 시 Hive (모바일 전용)를 사용할 수 없으므로, 웹 플랫폼용 스텁을 사용합니다:

**스텁 파일 위치:**
```
lib/core/platform/web/stubs/
├── local_storage_stub.dart      # Hive → localStorage 대체 (562줄, 50+ 메서드)
├── hive_stub.dart               # Hive API 스텁
├── notification_stub.dart       # 알림 스텁 (제한된 기능)
└── secure_storage_web.dart      # 웹 보안 저장소
```

**LocalStorage 웹 스텁 상세:**
- **저장소**: 브라우저 `localStorage` API + JSON 인코딩
- **키 접두사**: `lk_` (예: `lk_setting_chineseVariant`)
- **메서드**: 모바일과 동일한 50+ 정적 메서드 제공
  - Settings (4): getSetting, saveSetting, deleteSetting, clearSettings
  - Lessons (6): saveLesson, getLesson, getAllLessons, hasLesson, deleteLesson, clearLessons
  - Vocabulary (7): 전체 단어 관리 + 레벨별 캐싱
  - Progress (5): 학습 진도 저장/로드
  - Reviews (4): SRS 복습 데이터
  - Bookmarks (9): 북마크 관리
  - Sync Queue (5): 웹에서는 no-op (항상 온라인 가정)
  - User Data (6): 사용자 캐시 및 ID
  - General (3): init, clearAll, close
- **에러 처리**: 모든 메서드에 try-catch, 기본값 반환
- **저장 한계**: 브라우저 localStorage 5-10MB (설정/소규모 데이터에 충분)

### 웹 빌드

```bash
# 웹 앱 빌드
flutter build web

# 빌드 출력: build/web/
# 빌드 시간: ~9-10분
# 최적화:
#   - Icon tree-shaking (99%+ 크기 감소)
#   - JS 압축 및 최적화
```

### 로컬 테스트

```bash
# 개발 모드로 실행
flutter run -d chrome

# 또는 빌드된 웹 앱 서빙
cd build/web
python3 -m http.server 8080

# 브라우저에서 접속
# http://localhost:8080
```

### 프로덕션 배포

**Docker Compose 배포:**
```bash
# 1. 웹 빌드
flutter build web

# 2. Nginx 재시작 (새 빌드 로드)
docker compose restart nginx

# Volume 매핑:
# ./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro
```

**배포 URL:**
- **프로덕션**: https://lemon.3chan.kr/app/
- **로컬**: http://localhost/app/
- **Nginx 위치**: `location /app/`

### 웹 앱 검증

```bash
# 브라우저에서 접속 후 DevTools (F12) 확인:

# 1. Console 탭
#    - 에러 없는지 확인
#    - LateInitializationError 없음 확인

# 2. Application → Local Storage
#    - lk_setting_chineseVariant: "simplified"
#    - lk_setting_notificationsEnabled: false
#    - lk_setting_dailyReminderEnabled: true

# 3. 기능 테스트
#    - Settings 변경 후 새로고침 시 유지 확인
#    - 중국어 간체/번체 토글 동작 확인
```

### 웹 vs 모바일 차이점

| 항목 | 모바일 (Hive) | 웹 (localStorage) |
|------|---------------|-------------------|
| 저장 용량 | 무제한 (기기 저장소) | 5-10MB |
| 오프라인 지원 | ✅ 완전 지원 | ❌ 온라인 전용 |
| 동기화 큐 | ✅ 완전 동작 | ⚠️ No-op (즉시 동기화) |
| 미디어 다운로드 | ✅ 지원 | ⚠️ 제한적 |
| 성능 | ⚡ 매우 빠름 | 🔵 빠름 |
| 데이터 지속성 | ✅ 앱 삭제 전까지 | ⚠️ 브라우저 캐시 정리 시 삭제 |

---

## 다국어 지원 (i18n)

### 지원 언어

| 언어 | 코드 | ARB 파일 |
|------|------|----------|
| 중국어 간체 | zh | app_zh.arb |
| 중국어 번체 | zh_TW | app_zh_TW.arb |
| 한국어 | ko | app_ko.arb |
| 영어 | en | app_en.arb |
| 일본어 | ja | app_ja.arb |
| 스페인어 | es | app_es.arb |

### ARB 파일 구조

```json
{
  "@@locale": "zh",
  "appTitle": "柠檬韩语",
  "@appTitle": {
    "description": "应用标题"
  },
  "login": "登录",
  "register": "注册",
  ...
}
```

### 번역 추가하기

```bash
# 1. ARB 파일에 새 키 추가
# lib/l10n/app_zh.arb 등

# 2. 번역 클래스 생성
flutter gen-l10n

# 3. 코드에서 사용
Text(AppLocalizations.of(context)!.appTitle)
```

### 번역 키 수

- **총 키 수**: 206개
- **카테고리**: UI, 레슨, 설정, 오류 메시지, 알림 등

### 언어 변경

```dart
// SettingsProvider에서 언어 변경
context.read<SettingsProvider>().setLanguage('ko');

// 또는 시스템 언어 자동 감지
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

### 문제 해결

**Q: 웹 빌드 시 LateInitializationError 발생**

A: 웹 스텁이 올바르게 구현되어 있는지 확인:
```dart
// lib/core/platform/web/stubs/local_storage_stub.dart
// 50+ 메서드가 모두 구현되어 있어야 함
```

**Q: localStorage 저장 용량 초과**

A: 브라우저 localStorage는 5-10MB 제한이 있습니다. 큰 데이터는 서버에서 직접 로드하세요:
```dart
// 캐시하지 않고 직접 API 호출
final lesson = await apiClient.getLesson(id);
```

**Q: 웹에서 오프라인 모드 지원**

A: 현재 웹 버전은 온라인 전용입니다. Service Worker 기반 오프라인 지원은 향후 개선 예정입니다.

---

## 빌드 및 배포

### Android 빌드

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

### iOS 빌드

```bash
# Release IPA
flutter build ios --release

# Archive
flutter build ipa
```

---

## 환경 변수

개발/프로덕션 환경별 설정:

```dart
// lib/core/constants/app_constants.dart

// Development
static const String baseUrl = 'http://localhost';

// Production
static const String baseUrl = 'https://api.lemonkorean.com';
```

---

## 디버깅

### 로그 출력

```bash
# 실시간 로그
flutter logs

# 특정 레벨
flutter logs --verbose
```

### DevTools

```bash
# DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 테스트

### Unit Tests

```bash
flutter test
```

### Widget Tests

```dart
testWidgets('Login button test', (WidgetTester tester) async {
  await tester.pumpWidget(LoginScreen());
  expect(find.text('登录'), findsOneWidget);
});
```

---

## 성능 최적화

### 1. 이미지 캐싱
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: CacheManager(
    Config('customCacheKey', maxNrOfCacheObjects: 100),
  ),
)
```

### 2. Lazy Loading
```dart
ListView.builder(
  itemCount: lessons.length,
  itemBuilder: (context, index) => LessonCard(lessons[index]),
)
```

### 3. 메모리 관리
```dart
@override
void dispose() {
  controller.dispose();
  subscription.cancel();
  super.dispose();
}
```

---

## 문제 해결

### Q: Pod install 실패 (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Q: Gradle 빌드 실패 (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Q: 네트워크 권한 에러 (Android)
`android/app/src/main/AndroidManifest.xml`에 추가:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 라이센스

MIT License

---

## 기여

Pull Request 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 연락처

프로젝트 링크: [https://github.com/your-repo/lemon-korean](https://github.com/your-repo/lemon-korean)
