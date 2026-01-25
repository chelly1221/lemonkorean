# Core Layer - 핵심 유틸리티

## 개요

Core 레이어는 앱 전역에서 사용되는 핵심 기능을 제공합니다.

---

## 디렉토리 구조

```
core/
├── constants/
│   └── app_constants.dart        # 전역 상수
├── network/
│   └── api_client.dart           # HTTP 클라이언트 (Dio)
├── storage/
│   ├── local_storage.dart        # Hive 로컬 저장소
│   └── database_helper.dart      # SQLite 데이터베이스
└── utils/
    ├── download_manager.dart     # 다운로드 관리자
    └── sync_manager.dart         # 동기화 관리자
```

---

## 1. Storage (저장소)

### LocalStorage (Hive)
**용도**: 구조화된 데이터 저장 (JSON)

```dart
// 레슨 저장
await LocalStorage.saveLesson(lessonData);

// 레슨 조회
final lesson = LocalStorage.getLesson(lessonId);

// 진도 저장
await LocalStorage.saveProgress(progressData);

// 동기화 큐 추가
await LocalStorage.addToSyncQueue({
  'type': 'lesson_complete',
  'data': progressData,
});
```

**저장되는 데이터:**
- Lessons (레슨 메타데이터 및 콘텐츠)
- Vocabulary (단어 데이터)
- Progress (학습 진도)
- Sync Queue (동기화 대기 큐)
- Settings (사용자 설정)

### DatabaseHelper (SQLite)
**용도**: 미디어 파일 메타데이터 관리

```dart
// 미디어 파일 저장
await DatabaseHelper.instance.insertMediaFile({
  'remote_key': 'images/lesson1.jpg',
  'local_path': '/storage/lesson1.jpg',
  'file_type': 'image',
  'file_size': 1024000,
  'lesson_id': 1,
});

// 로컬 경로 조회
final localPath = await DatabaseHelper.instance.getLocalPath('images/lesson1.jpg');

// 레슨 미디어 삭제
await DatabaseHelper.instance.deleteMediaFilesByLesson(lessonId);
```

**테이블 구조:**
- `media_files`: 다운로드된 미디어 파일 메타데이터
- `download_queue`: 다운로드 대기 큐

---

## 2. Network (네트워크)

### ApiClient (Dio)
**용도**: HTTP 통신 및 API 호출

```dart
// 싱글톤 사용
final apiClient = ApiClient.instance;

// 로그인
final response = await apiClient.login(
  email: 'user@example.com',
  password: 'password123',
);

// 레슨 조회
final lessons = await apiClient.getLessons(level: 1);

// 진도 동기화
await apiClient.syncProgress(progressData);
```

**주요 기능:**
- JWT 자동 인증 (AuthInterceptor)
- 토큰 자동 갱신
- 에러 처리 및 재시도
- 디버그 로깅

**인터셉터:**
1. **AuthInterceptor**: JWT 토큰 자동 추가 및 갱신
2. **LoggingInterceptor**: 요청/응답 로깅 (디버그 모드)
3. **ErrorInterceptor**: 에러 메시지 포맷팅

---

## 3. Utils (유틸리티)

### DownloadManager
**용도**: 레슨 및 미디어 파일 다운로드

```dart
final downloadManager = DownloadManager.instance;

// 콜백 설정
downloadManager.onProgress = (lessonId, progress) {
  print('Download progress: ${progress * 100}%');
};

downloadManager.onComplete = (lessonId) {
  print('Download complete: $lessonId');
};

downloadManager.onError = (lessonId, error) {
  print('Download error: $error');
};

// 레슨 다운로드
await downloadManager.downloadLesson(lessonId);

// 진행률 확인
final progress = downloadManager.getProgress(lessonId);
print('Progress: ${progress?.percentComplete}%');

// 다운로드 취소
downloadManager.cancelDownload(lessonId);

// 레슨 삭제
await downloadManager.deleteLesson(lessonId);
```

**주요 기능:**
- 레슨 패키지 다운로드
- 미디어 파일 병렬 다운로드
- 진행률 추적
- 다운로드 취소/재개
- 캐시 관리

**다운로드 프로세스:**
1. 레슨 메타데이터 다운로드
2. 미디어 URL 추출
3. 미디어 파일 다운로드
4. 로컬 저장소에 저장
5. 데이터베이스 업데이트

### SyncManager
**용도**: 오프라인 데이터 동기화

```dart
final syncManager = SyncManager.instance;

// 초기화
await syncManager.init();

// 콜백 설정
syncManager.onSyncStatusChanged = (status) {
  print('Sync status: ${status.statusMessage}');
};

syncManager.onQueueSizeChanged = (size) {
  print('Queue size: $size');
};

syncManager.onSyncError = (error) {
  print('Sync error: $error');
};

// 수동 동기화
final result = await syncManager.forceSync();
print('Synced: ${result.syncedItems}, Failed: ${result.failedItems}');

// 상태 확인
print('Is online: ${syncManager.isOnline}');
print('Queue size: ${syncManager.queueSize}');
print('Last sync: ${syncManager.lastSyncTime}');
```

**주요 기능:**
- 네트워크 상태 모니터링
- 자동 동기화 (5분마다)
- 네트워크 복구 시 즉시 동기화
- 동기화 큐 관리
- 배치 동기화

**동기화 항목:**
- 레슨 완료 진도
- 복습 완료 기록
- 이벤트 로그

---

## 사용 예제

### 완전한 오프라인 워크플로우

```dart
// 1. 레슨 다운로드
await DownloadManager.instance.downloadLesson(lessonId);

// 2. 오프라인 학습 (로컬 데이터 사용)
final lesson = LocalStorage.getLesson(lessonId);

// 3. 진도 저장 (로컬)
await LocalStorage.saveProgress({
  'lesson_id': lessonId,
  'status': 'completed',
  'quiz_score': 85,
});

// 4. 동기화 큐 추가
await LocalStorage.addToSyncQueue({
  'type': 'lesson_complete',
  'data': progressData,
});

// 5. 자동 동기화 (네트워크 복구 시)
// SyncManager가 자동으로 처리
```

### 미디어 파일 로딩

```dart
// 미디어 URL 가져오기
String getMediaUrl(String remoteKey) async {
  // 1. 로컬 경로 확인
  final localPath = await DatabaseHelper.instance.getLocalPath(remoteKey);

  if (localPath != null && await File(localPath).exists()) {
    return localPath; // 로컬 파일 사용
  }

  // 2. 원격 URL 반환
  return '${AppConstants.mediaUrl}/$remoteKey';
}

// 사용
final imageUrl = await getMediaUrl('images/lesson1.jpg');

// CachedNetworkImage와 함께 사용
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

---

## 초기화 순서

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Hive 초기화
  await LocalStorage.init();

  // 2. SyncManager 초기화
  await SyncManager.instance.init();

  runApp(MyApp());
}
```

---

## 에러 처리

### Network 에러
```dart
try {
  final response = await ApiClient.instance.login(email, password);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    // 네트워크 타임아웃
  } else if (e.response?.statusCode == 401) {
    // 인증 실패
  }
}
```

### Storage 에러
```dart
try {
  await LocalStorage.saveLesson(lessonData);
} catch (e) {
  // Hive 저장 실패
  print('Storage error: $e');
}
```

### Download 에러
```dart
downloadManager.onError = (lessonId, error) {
  // 다운로드 실패 처리
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('下载失败'),
      content: Text(error),
    ),
  );
};
```

---

## 성능 최적화

### 1. 배치 작업
```dart
// ❌ Bad: 개별 저장
for (final lesson in lessons) {
  await LocalStorage.saveLesson(lesson);
}

// ✅ Good: 트랜잭션 사용
// (Hive는 자동으로 최적화됨)
```

### 2. 캐시 관리
```dart
// LRU 캐시 정리
await DatabaseHelper.instance.cleanupOldFiles(maxSizeBytes);
```

### 3. 동기화 최적화
```dart
// 배치 동기화 (한 번에 여러 항목)
await ApiClient.instance.syncProgress(progressDataList);
```

---

## 디버깅

### 로그 활성화
```dart
// app_constants.dart
static const bool enableDebugMode = true;
```

### Storage 확인
```dart
// Hive 데이터 확인
final lessons = LocalStorage.getAllLessons();
print('Total lessons: ${lessons.length}');

// SQLite 데이터 확인
final totalSize = await DatabaseHelper.instance.getTotalStorageUsed();
print('Storage used: ${totalSize / 1024 / 1024} MB');
```

### 동기화 상태
```dart
print('Queue size: ${SyncManager.instance.queueSize}');
print('Is syncing: ${SyncManager.instance.isSyncing}');
print('Is online: ${SyncManager.instance.isOnline}');
```

---

## 테스트

### Unit Tests
```dart
test('LocalStorage save and retrieve', () async {
  await LocalStorage.saveLesson({'id': 1, 'title': 'Test'});
  final lesson = LocalStorage.getLesson(1);
  expect(lesson?['title'], 'Test');
});

test('SyncManager syncs queue', () async {
  await LocalStorage.addToSyncQueue({'type': 'test'});
  final result = await SyncManager.instance.sync();
  expect(result.success, true);
});
```

---

## 참고 자료

- [Hive Documentation](https://docs.hivedb.dev/)
- [Dio Documentation](https://pub.dev/packages/dio)
- [SQLite Flutter](https://pub.dev/packages/sqflite)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
