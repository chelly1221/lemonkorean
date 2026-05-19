# Lemon Korean - Architecture Documentation

## 아키텍처 개요

### 전체 구조
```
┌─────────────────────────────────────────────────┐
│                  Presentation                   │
│  (Screens, Widgets, Providers - State Mgmt)    │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│                    Data Layer                   │
│         (Repositories, Models)                  │
└─────────────────┬───────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
┌───────▼────────┐  ┌──────▼──────┐
│  Local Storage │  │   Network   │
│  (Hive/SQLite) │  │ (Dio/HTTP)  │
└────────────────┘  └─────────────┘
```

---

## 레이어 설명

### 1. Presentation Layer
**책임**: UI 렌더링 및 사용자 상호작용 처리

**구성 요소:**
- **Screens**: 화면 단위 위젯
- **Widgets**: 재사용 가능한 UI 컴포넌트
- **Providers**: 상태 관리 (Provider 패턴)

**원칙:**
- UI 로직과 비즈니스 로직 분리
- Provider를 통한 상태 관리
- 화면 간 데이터 전달은 Provider 사용

### 2. Data Layer
**책임**: 데이터 소스 추상화

**구성 요소:**
- **Repositories**: 데이터 접근 로직
- **Models**: 데이터 구조 정의

**패턴:**
```dart
class LessonRepository {
  Future<Lesson> getLesson(int id) async {
    // 1. 로컬 확인
    final local = LocalStorage.getLesson(id);
    if (local != null) return local;

    // 2. 네트워크 요청
    final network = await ApiClient.getLesson(id);

    // 3. 로컬 저장
    await LocalStorage.saveLesson(network);

    return network;
  }
}
```

### 3. Core Layer
**책임**: 앱 전역 기능 및 유틸리티

**구성 요소:**
- **Storage**: 로컬 데이터 저장소 (Hive, SQLite)
- **Network**: HTTP 클라이언트 (Dio)
- **Utils**: 공통 유틸리티
- **Constants**: 전역 상수

---

## 온보딩 플로우 (2026-02-02 추가)

### 온보딩 데이터 플로우
```
앱 시작
    │
    ▼
SettingsProvider.hasCompletedOnboarding
    │
    ├── false → 온보딩 화면
    │              │
    │              ▼
    │         1. LanguageSelectionScreen
    │              │
    │              ▼
    │         2. WelcomeIntroductionScreen
    │              │
    │              ▼
    │         3. LevelSelectionScreen
    │              │
    │              ▼
    │         4. WeeklyGoalScreen
    │              │
    │              ▼
    │         5. PersonalizationCompleteScreen
    │              │
    │              ▼
    │         SettingsProvider 저장:
    │         - hasCompletedOnboarding: true
    │         - userLevel: 선택값
    │         - weeklyGoal: 선택값
    │         - weeklyGoalTarget: 분 단위
    │              │
    └── true → HomeScreen
```

### 온보딩 Provider 연동
```dart
// SettingsProvider (새로운 필드)
- bool _hasCompletedOnboarding
- String _userLevel      // 'beginner', 'elementary', 'intermediate', 'advanced'
- String _weeklyGoal     // 'light', 'regular', 'intensive', 'pro'
- int _weeklyGoalTarget  // 5, 15, 30, 60 (분)

// 저장소
- SharedPreferences (웹: localStorage)
- 키: has_completed_onboarding, user_level, weekly_goal, weekly_goal_target
```

---

## 데이터 플로우

### 읽기 (Read) 플로우
```
UI Request
    │
    ▼
Provider
    │
    ▼
Repository
    │
    ├──► LocalStorage (Hive)
    │         │
    │         ├── Hit   → Return Data
    │         │
    │         └── Miss
    │              │
    │              ▼
    └──► ApiClient (Network)
              │
              ▼
         Save to Local
              │
              ▼
         Return Data
```

### 쓰기 (Write) 플로우
```
UI Action
    │
    ▼
Provider
    │
    ▼
LocalStorage.save()
    │
    ▼
SyncQueue.add()
    │
    ▼
(Background Sync)
    │
    ▼
ApiClient.post()
    │
    ├── Success → Remove from Queue
    │
    └── Failure → Retry Later
```

---

## 상태 관리 (Provider Pattern)

### Provider 계층 구조
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => LessonProvider()),
    ChangeNotifierProvider(create: (_) => ProgressProvider()),
    ChangeNotifierProvider(create: (_) => SyncProvider()),
  ],
  child: MaterialApp(...),
)
```

### Provider 사용 패턴

#### 1. Consumer (UI 갱신)
```dart
Consumer<AuthProvider>(
  builder: (context, auth, child) {
    return Text(auth.username ?? 'Guest');
  },
)
```

#### 2. Provider.of (액션 트리거)
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.login(email, password);
```

#### 3. Selector (특정 값만 구독)
```dart
Selector<LessonProvider, int>(
  selector: (context, provider) => provider.lessons.length,
  builder: (context, count, child) {
    return Text('Total: $count');
  },
)
```

---

## 오프라인 우선 전략

### 1. 데이터 우선순위
```
Local Cache (즉시) > Network (비동기) > Fallback (로컬)
```

### 2. 동기화 전략

#### Optimistic Update
```dart
// 1. 즉시 UI 업데이트
await LocalStorage.saveProgress(progress);
notifyListeners();

// 2. 백그라운드 동기화
await SyncQueue.add(progress);
```

#### Background Sync
```dart
// 5분마다 자동 동기화
Timer.periodic(Duration(minutes: 5), (_) {
  if (isOnline) SyncProvider.sync();
});

// 네트워크 복구 시 즉시 동기화
connectivity.onConnectivityChanged.listen((result) {
  if (result != ConnectivityResult.none) {
    SyncProvider.sync();
  }
});
```

### 3. 충돌 해결
```dart
// Last-Write-Wins (마지막 쓰기 우선)
if (serverTimestamp > localTimestamp) {
  useServerData();
} else {
  keepLocalData();
}
```

---

## 에러 처리

### 계층별 에러 처리

#### 1. Network Layer
```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, handler) {
    final errorMessage = _mapError(err);
    handler.next(DioException(..., error: errorMessage));
  }
}
```

#### 2. Provider Layer
```dart
class LessonProvider with ChangeNotifier {
  String? _errorMessage;

  Future<void> fetchLessons() async {
    try {
      // ... fetch logic
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
```

#### 3. UI Layer
```dart
if (provider.errorMessage != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(provider.errorMessage!)),
  );
}
```

---

## 성능 최적화

### 1. 리스트 최적화
```dart
// ✅ Good: ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ Bad: ListView with List.generate
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### 2. 이미지 캐싱
```dart
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 400,  // 메모리 절약
  maxWidthDiskCache: 800,  // 디스크 캐시 크기 제한
)
```

### 3. 상태 분리
```dart
// 전체 Provider 대신 Selector 사용
Selector<LessonProvider, bool>(
  selector: (_, provider) => provider.isLoading,
  builder: (_, isLoading, __) {
    return isLoading ? LoadingWidget() : ContentWidget();
  },
)
```

### 4. const 위젯
```dart
// ✅ 불필요한 리빌드 방지
const Text('Static Text');

// ❌ 매번 재생성
Text('Static Text');
```

---

## 보안

### 1. 토큰 저장
```dart
// flutter_secure_storage 사용
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
```

### 2. API 통신
```dart
// HTTPS 강제
const baseUrl = 'https://api.lemonkorean.com';

// Certificate Pinning (선택)
dio.httpClientAdapter = IOHttpClientAdapter(
  createHttpClient: () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) {
      return cert.sha1.toLowerCase() == expectedSha1;
    };
    return client;
  },
);
```

### 3. 민감 데이터 암호화
```dart
// Hive 암호화 (옵션)
final encryptionKey = await _getEncryptionKey();
final box = await Hive.openBox(
  'secure_box',
  encryptionCipher: HiveAesCipher(encryptionKey),
);
```

---

## 테스트 전략

### 1. Unit Tests
```dart
test('Login success', () async {
  final provider = AuthProvider();
  final success = await provider.login(
    email: 'test@example.com',
    password: 'password',
  );
  expect(success, true);
  expect(provider.isAuthenticated, true);
});
```

### 2. Widget Tests
```dart
testWidgets('Login button test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: LoginScreen()),
  );

  final button = find.text('登录');
  expect(button, findsOneWidget);

  await tester.tap(button);
  await tester.pumpAndSettle();
});
```

### 3. Integration Tests
```dart
testWidgets('Full login flow', (tester) async {
  await tester.pumpWidget(MyApp());

  // Enter credentials
  await tester.enterText(find.byType(TextField).first, 'email');
  await tester.enterText(find.byType(TextField).last, 'password');

  // Tap login
  await tester.tap(find.text('登录'));
  await tester.pumpAndSettle();

  // Verify navigation
  expect(find.text('课程'), findsOneWidget);
});
```

---

## 모니터링

### 1. 로깅
```dart
if (AppConstants.enableDebugMode) {
  print('[${DateTime.now()}] $message');
}
```

### 2. 에러 리포팅
```dart
// Sentry, Firebase Crashlytics 등
FlutterError.onError = (details) {
  errorReporter.captureException(
    details.exception,
    stackTrace: details.stack,
  );
};
```

### 3. Analytics
```dart
await analytics.logEvent(
  name: 'lesson_complete',
  parameters: {
    'lesson_id': lessonId,
    'score': score,
  },
);
```

---

## 코드베이스 통계 (2026-03-11)

- **총 Dart 파일**: 323개
- **Providers**: 17개 (auth, bookmark, character, dm, download, feed, gamification, hangul, lesson, progress, settings, social, speech, sync, theme, vocabulary_browser, voice_room)
- **Core Services**: 16개 파일 (`lib/core/services/`)
- **한글 스테이지**: 13개 (Stage 0~12, `lib/presentation/screens/hangul/stage*/`)
- **게임 모듈**: 26개 파일 (`lib/game/`)

---

## Core Services (`lib/core/services/`)

앱의 핵심 비즈니스 로직을 담당하는 서비스 레이어.

### 음성/발음 서비스
- **whisper_service.dart** - Whisper 음성 인식 (조건부 export)
- **whisper_service_native.dart** - 네이티브 Whisper 구현
- **whisper_service_stub.dart** - 웹 스텁
- **gop_service.dart** - GOP(Goodness of Pronunciation) 서비스 (조건부 export)
- **gop_service_native.dart** - 네이티브 GOP 구현
- **gop_service_stub.dart** - 웹 스텁
- **gop_models.dart** - GOP 데이터 모델
- **pronunciation_scorer.dart** - 임베딩 기반 발음 점수 산출
- **speech_model_manager.dart** - 번들 음성 모델 관리
- **audio_recorder_service.dart** - 오디오 녹음

### 기타 서비스
- **notification_service.dart** - 알림 서비스
- **socket_service.dart** - Socket.IO 실시간 통신
- **ad_service.dart** - 광고 서비스 (조건부 export)
- **admob_service.dart** / **admob_service_web.dart** - AdMob
- **adsense_service.dart** - 웹 AdSense

---

## 게임 모듈 (`lib/game/`)

Flame 엔진 기반 2D 게임 모듈 (26개 파일).

```
game/
├── core/                    # 게임 엔진 코어
│   ├── game_bridge.dart     # Flutter ↔ Flame 연동
│   ├── game_constants.dart  # 게임 상수
│   ├── palette_swap.dart    # 팔레트 스왑
│   └── sprite_loader.dart   # 스프라이트 로더
├── components/              # 게임 컴포넌트
│   ├── character/           # 캐릭터 (pixel_character, animation, shadow, equipment)
│   ├── effects/             # 이펙트 (particle, emoji, gesture, speaking_aura)
│   ├── pet/                 # 펫 (pixel_pet)
│   ├── room/                # 방 (background, floor, furniture, day_night)
│   └── ui/                  # UI (name_label, mute_badge, connection_quality)
├── mini_games/              # 미니게임
│   ├── mini_game_base.dart
│   ├── word_puzzle/
│   └── korean_quiz/
├── my_room/                 # 마이룸
│   └── my_room_game.dart
└── voice_stage/             # 음성 대화방 스테이지
    ├── voice_stage_game.dart
    └── remote_character.dart
```

---

## 한글 커리큘럼 (Stage 0~12)

13단계 한글 학습 커리큘럼. 각 스테이지는 `lib/presentation/screens/hangul/stage{N}/`에 위치.

| Stage | 내용 |
|-------|------|
| 0 | 기본 모음 (ㅏ, ㅓ, ㅗ, ㅜ, ㅡ, ㅣ) |
| 1 | 기본 자음 |
| 2-3 | 자음 확장 |
| 4-5 | 복합 모음 |
| 6-7 | 음절 조합 |
| 8-9 | 받침 (종성) |
| 10 | 겹받침 |
| 11 | 음운 규칙 |
| 12 | 종합 복습 |

---

## 참고 자료

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
