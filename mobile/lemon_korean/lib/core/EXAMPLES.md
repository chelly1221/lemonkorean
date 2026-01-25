# Core Layer - 사용 예제

## 1. 앱 초기화

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/storage/local_storage.dart';
import 'core/utils/sync_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await LocalStorage.init();

  // SyncManager 초기화
  await SyncManager.instance.init();

  runApp(const MyApp());
}
```

---

## 2. 로그인 및 인증

```dart
import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';

class AuthExample {
  final apiClient = ApiClient.instance;

  Future<bool> login(String email, String password) async {
    try {
      // API 호출
      final response = await apiClient.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // 사용자 정보 저장
        final userId = data['user']['id'];
        await LocalStorage.saveUserId(userId);

        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await apiClient.logout();
    await LocalStorage.clearUserId();
  }
}
```

---

## 3. 레슨 목록 조회 (오프라인 우선)

```dart
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';

class LessonExample {
  final apiClient = ApiClient.instance;

  Future<List<Map<String, dynamic>>> getLessons() async {
    try {
      // 1. 네트워크에서 가져오기 시도
      final response = await apiClient.getLessons();

      if (response.statusCode == 200) {
        final lessons = List<Map<String, dynamic>>.from(
          response.data['lessons'],
        );

        // 2. 로컬에 저장
        for (final lesson in lessons) {
          await LocalStorage.saveLesson(lesson);
        }

        return lessons;
      }
    } catch (e) {
      print('Network error: $e');
    }

    // 3. 네트워크 실패 시 로컬에서 가져오기
    return LocalStorage.getAllLessons();
  }

  Future<Map<String, dynamic>?> getLesson(int lessonId) async {
    // 로컬 우선
    final localLesson = LocalStorage.getLesson(lessonId);
    if (localLesson != null) {
      return localLesson;
    }

    // 네트워크에서 가져오기
    try {
      final response = await apiClient.getLesson(lessonId);

      if (response.statusCode == 200) {
        final lesson = response.data;
        await LocalStorage.saveLesson(lesson);
        return lesson;
      }
    } catch (e) {
      print('Error fetching lesson: $e');
    }

    return null;
  }
}
```

---

## 4. 레슨 다운로드

```dart
import 'package:flutter/material.dart';
import 'core/utils/download_manager.dart';

class DownloadExample extends StatefulWidget {
  final int lessonId;

  const DownloadExample({Key? key, required this.lessonId}) : super(key: key);

  @override
  State<DownloadExample> createState() => _DownloadExampleState();
}

class _DownloadExampleState extends State<DownloadExample> {
  final downloadManager = DownloadManager.instance;
  double _progress = 0.0;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _setupDownloadCallbacks();
  }

  void _setupDownloadCallbacks() {
    downloadManager.onProgress = (lessonId, progress) {
      if (lessonId == widget.lessonId) {
        setState(() {
          _progress = progress;
        });
      }
    };

    downloadManager.onComplete = (lessonId) {
      if (lessonId == widget.lessonId) {
        setState(() {
          _message = '下载完成！';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('下载完成')),
        );
      }
    };

    downloadManager.onError = (lessonId, error) {
      if (lessonId == widget.lessonId) {
        setState(() {
          _message = '错误: $error';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载失败: $error')),
        );
      }
    };
  }

  Future<void> _startDownload() async {
    setState(() {
      _message = '开始下载...';
    });

    await downloadManager.downloadLesson(widget.lessonId);
  }

  void _cancelDownload() {
    downloadManager.cancelDownload(widget.lessonId);
    setState(() {
      _message = '已取消';
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDownloading = downloadManager.isDownloading(widget.lessonId);

    return Column(
      children: [
        Text(_message),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: _progress),
        const SizedBox(height: 8),
        Text('${(_progress * 100).toStringAsFixed(1)}%'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isDownloading ? null : _startDownload,
              child: const Text('下载'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: isDownloading ? _cancelDownload : null,
              child: const Text('取消'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## 5. 진도 저장 및 동기화

```dart
import 'core/storage/local_storage.dart';

class ProgressExample {
  Future<void> completeLesson({
    required int lessonId,
    required int quizScore,
    required int timeSpent,
  }) async {
    // 진도 데이터
    final progressData = {
      'lesson_id': lessonId,
      'status': 'completed',
      'quiz_score': quizScore,
      'time_spent': timeSpent,
      'completed_at': DateTime.now().toIso8601String(),
    };

    // 1. 로컬에 저장
    await LocalStorage.saveProgress(progressData);

    // 2. 동기화 큐에 추가
    await LocalStorage.addToSyncQueue({
      'type': 'lesson_complete',
      'data': progressData,
      'created_at': DateTime.now().toIso8601String(),
    });

    // 3. 즉시 동기화 시도 (네트워크가 있으면)
    // SyncManager가 자동으로 처리
  }

  Map<String, dynamic>? getProgress(int lessonId) {
    return LocalStorage.getProgress(lessonId);
  }

  List<Map<String, dynamic>> getAllProgress() {
    return LocalStorage.getAllProgress();
  }
}
```

---

## 6. 동기화 관리

```dart
import 'package:flutter/material.dart';
import 'core/utils/sync_manager.dart';

class SyncExample extends StatefulWidget {
  const SyncExample({Key? key}) : super(key: key);

  @override
  State<SyncExample> createState() => _SyncExampleState();
}

class _SyncExampleState extends State<SyncExample> {
  final syncManager = SyncManager.instance;
  String _statusMessage = '';
  int _queueSize = 0;

  @override
  void initState() {
    super.initState();
    _setupSyncCallbacks();
    _updateStatus();
  }

  void _setupSyncCallbacks() {
    syncManager.onSyncStatusChanged = (status) {
      setState(() {
        _statusMessage = status.statusMessage;
      });
    };

    syncManager.onQueueSizeChanged = (size) {
      setState(() {
        _queueSize = size;
      });
    };

    syncManager.onSyncError = (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('同步错误: $error')),
      );
    };
  }

  void _updateStatus() {
    setState(() {
      _statusMessage = syncManager.statusMessage;
      _queueSize = syncManager.queueSize;
    });
  }

  Future<void> _forceSync() async {
    final result = await syncManager.forceSync();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '同步完成: ${result.syncedItems} 成功, ${result.failedItems} 失败',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  syncManager.isOnline
                      ? Icons.cloud_done
                      : Icons.cloud_off,
                  color: syncManager.isOnline ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_statusMessage),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_queueSize > 0)
              Text(
                '待同步: $_queueSize 项',
                style: const TextStyle(color: Colors.orange),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: syncManager.isSyncing ? null : _forceSync,
              child: syncManager.isSyncing
                  ? const Text('正在同步...')
                  : const Text('立即同步'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 7. 미디어 로딩

```dart
import 'package:flutter/material.dart';
import 'core/utils/media_helper.dart';

class MediaExample extends StatelessWidget {
  final String imageKey;

  const MediaExample({Key? key, required this.imageKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이미지 로딩 (로컬 우선)
        MediaHelper.buildImage(
          imageKey,
          width: 300,
          height: 200,
          fit: BoxFit.cover,
          placeholder: const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: Container(
            color: Colors.grey,
            child: const Icon(Icons.error),
          ),
        ),

        const SizedBox(height: 16),

        // 썸네일
        MediaHelper.buildThumbnail(
          imageKey,
          size: 100,
        ),

        const SizedBox(height: 16),

        // 미디어 정보
        FutureBuilder<bool>(
          future: MediaHelper.isMediaAvailableLocally(imageKey),
          builder: (context, snapshot) {
            final isLocal = snapshot.data ?? false;
            return Chip(
              label: Text(isLocal ? '已下载' : '在线'),
              backgroundColor: isLocal ? Colors.green : Colors.orange,
            );
          },
        ),
      ],
    );
  }
}
```

---

## 8. 완전한 학습 플로우

```dart
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/download_manager.dart';
import 'core/utils/sync_manager.dart';

class LearningFlowExample {
  final apiClient = ApiClient.instance;
  final downloadManager = DownloadManager.instance;
  final syncManager = SyncManager.instance;

  // Step 1: 레슨 다운로드
  Future<void> downloadLesson(int lessonId) async {
    print('1. 다운로드 시작...');
    await downloadManager.downloadLesson(lessonId);
    print('2. 다운로드 완료');
  }

  // Step 2: 오프라인 학습
  Future<Map<String, dynamic>?> studyLesson(int lessonId) async {
    print('3. 레슨 로드 (로컬)...');
    final lesson = LocalStorage.getLesson(lessonId);

    if (lesson == null) {
      print('레슨을 찾을 수 없습니다. 다운로드가 필요합니다.');
      return null;
    }

    print('4. 학습 중...');
    return lesson;
  }

  // Step 3: 진도 저장
  Future<void> saveProgress({
    required int lessonId,
    required int quizScore,
  }) async {
    print('5. 진도 저장 (로컬)...');

    final progressData = {
      'lesson_id': lessonId,
      'status': 'completed',
      'quiz_score': quizScore,
      'completed_at': DateTime.now().toIso8601String(),
    };

    await LocalStorage.saveProgress(progressData);

    print('6. 동기화 큐에 추가...');
    await LocalStorage.addToSyncQueue({
      'type': 'lesson_complete',
      'data': progressData,
    });
  }

  // Step 4: 동기화
  Future<void> syncData() async {
    print('7. 네트워크 확인...');

    if (!syncManager.isOnline) {
      print('오프라인 상태. 나중에 자동 동기화됩니다.');
      return;
    }

    print('8. 동기화 시작...');
    final result = await syncManager.forceSync();

    print('9. 동기화 완료: ${result.syncedItems} 항목');
  }

  // 전체 플로우
  Future<void> completeFlow(int lessonId) async {
    // 다운로드
    await downloadLesson(lessonId);

    // 학습
    final lesson = await studyLesson(lessonId);
    if (lesson == null) return;

    // 진도 저장 (예: 퀴즈 점수 85점)
    await saveProgress(lessonId: lessonId, quizScore: 85);

    // 동기화
    await syncData();

    print('✅ 학습 플로우 완료!');
  }
}
```

---

## 9. 에러 처리 패턴

```dart
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'core/constants/app_constants.dart';

class ErrorHandlingExample {
  final apiClient = ApiClient.instance;

  Future<void> handleApiCall() async {
    try {
      final response = await apiClient.getLessons();

      if (response.statusCode == 200) {
        // 성공 처리
        print('Success: ${response.data}');
      }
    } on DioException catch (e) {
      // Dio 에러 처리
      if (e.type == DioExceptionType.connectionTimeout) {
        print(AppConstants.networkErrorMessage);
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 401:
            print(AppConstants.authErrorMessage);
            // 로그아웃 처리
            break;
          case 404:
            print('리소스를 찾을 수 없습니다');
            break;
          case 500:
            print(AppConstants.serverErrorMessage);
            break;
          default:
            print(AppConstants.unknownErrorMessage);
        }
      }
    } catch (e) {
      // 기타 에러
      print('Unexpected error: $e');
    }
  }
}
```

---

## 10. 캐시 관리

```dart
import 'core/utils/media_helper.dart';
import 'core/storage/database_helper.dart';
import 'core/constants/app_constants.dart';

class CacheManagementExample {
  Future<void> manageCacheSize() async {
    // 현재 캐시 크기 확인
    final currentSize = await MediaHelper.getTotalCacheSize();
    print('Current cache: ${MediaHelper.formatFileSize(currentSize)}');

    // 최대 크기 초과 시 정리
    if (currentSize > AppConstants.imageCacheSize) {
      print('Cleaning up old cache...');
      await MediaHelper.clearOldCache(
        maxSizeBytes: AppConstants.imageCacheSize,
      );

      final newSize = await MediaHelper.getTotalCacheSize();
      print('New cache size: ${MediaHelper.formatFileSize(newSize)}');
    }
  }

  Future<void> deleteLessonCache(int lessonId) async {
    // 레슨 미디어 크기 확인
    final size = await MediaHelper.getLessonMediaSize(lessonId);
    print('Lesson media size: ${MediaHelper.formatFileSize(size)}');

    // 삭제
    await MediaHelper.deleteLessonMedia(lessonId);
    print('Lesson cache deleted');
  }
}
```

---

## 참고사항

### 오프라인 우선 원칙
1. 모든 읽기는 로컬 우선
2. 모든 쓰기는 로컬 즉시 저장
3. 네트워크는 백그라운드 동기화
4. 에러 발생 시 로컬 데이터 폴백

### 성능 최적화
- 이미지는 CachedNetworkImage 사용
- 리스트는 ListView.builder 사용
- Provider는 Selector로 세분화
- 불필요한 리빌드 방지 (const 위젯)

### 보안
- 토큰은 FlutterSecureStorage에만 저장
- 민감한 데이터는 암호화
- HTTPS 통신 필수
