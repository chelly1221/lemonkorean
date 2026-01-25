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

## 참고 자료

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
