# Data Layer

The data layer implements the offline-first architecture for Lemon Korean, providing models and repositories for managing lessons, vocabulary, user progress, and synchronization.

## Architecture

```
Presentation Layer (Screens/Widgets)
        ↓
    Providers
        ↓
   Repositories (API + Local Storage)
        ↓
    Models (Hive)
        ↓
Local Storage (Hive + SQLite)
```

## Directory Structure

```
lib/data/
├── models/                          # Data models with Hive adapters
│   ├── user_model.dart             # User authentication & profile
│   ├── lesson_model.dart           # Lesson content & metadata
│   ├── vocabulary_model.dart       # Korean-Chinese vocabulary
│   └── progress_model.dart         # Progress & SRS reviews
│
└── repositories/                    # Data access layer
    ├── auth_repository.dart        # Authentication
    ├── content_repository.dart     # Lessons & vocabulary
    ├── progress_repository.dart    # Progress tracking & SRS
    └── offline_repository.dart     # Offline data management
```

---

## Models

All models use Hive for local storage with type adapters.

### 1. UserModel (typeId: 0)

User authentication and profile data.

**Fields:**
- `id` - User ID
- `email` - User email
- `username` - Display name
- `avatar` - Avatar URL
- `subscriptionType` - "free" or "premium"
- `createdAt` - Account creation date
- `lastLoginAt` - Last login timestamp

**Helpers:**
- `isPremium` - Check if user is premium
- `isFree` - Check if user is free tier

**Usage:**
```dart
final user = UserModel.fromJson(response.data);
await LocalStorage.saveUser(user.toJson());

if (user.isPremium) {
  // Show premium features
}
```

### 2. LessonModel (typeId: 1)

Lesson content with media URLs and download status.

**Fields:**
- `id` - Lesson ID
- `level` - Difficulty level (1-6)
- `titleKo` - Korean title
- `titleZh` - Chinese title
- `description` - Lesson description
- `content` - Full lesson content (JSON)
- `mediaUrls` - Map of media files (remote_key -> URL)
- `isDownloaded` - Download status
- `downloadedAt` - Download timestamp
- `estimatedMinutes` - Estimated completion time
- `vocabularyCount` - Number of vocabulary words

**Content Structure:**
```json
{
  "stage1_intro": {...},
  "stage2_vocabulary": {
    "words": [...],
    "matching_game": {...}
  },
  "stage3_grammar": {...},
  "stage4_practice": {...},
  "stage5_dialogue": {...},
  "stage6_quiz": {...},
  "stage7_summary": {...}
}
```

**Helpers:**
- `isPublished` - Check if lesson is published
- `displayTitle` - "Korean Title (Chinese Title)"
- `estimatedTime` - Formatted time (e.g., "30분", "1시간 30분")

**Usage:**
```dart
final lesson = await contentRepo.getLesson(123);

if (lesson.isDownloaded) {
  // Play offline
} else {
  // Download first
  await offlineRepo.downloadLesson(lesson.id);
}
```

### 3. VocabularyModel (typeId: 2)

Korean-Chinese vocabulary with similarity scoring.

**Fields:**
- `id` - Vocabulary ID
- `korean` - Korean word
- `hanja` - Hanja (optional)
- `chinese` - Chinese translation
- `pinyin` - Chinese pronunciation
- `pronunciation` - Korean romanization
- `partOfSpeech` - "noun", "verb", "adjective", etc.
- `level` - Difficulty level (1-6)
- `similarityScore` - Korean-Chinese similarity (0.0-1.0)
- `audioUrl` - Audio file URL
- `imageUrl` - Image URL
- `exampleSentences` - List of examples
- `tags` - Category tags

**Helpers:**
- `hasHanja` - Check if hanja exists
- `hasAudio` - Check if audio exists
- `displayWord` - "Korean (Hanja)" or "Korean"
- `partOfSpeechDisplay` - Chinese display (e.g., "名词")
- `similarityLevel` - "高相似度", "中等相似度", "低相似度"

**Usage:**
```dart
final words = await contentRepo.getVocabularyByLesson(123);

for (final word in words) {
  print('${word.korean} = ${word.chinese}');
  print('Similarity: ${word.similarityLevel}');

  if (word.hasAudio) {
    await audioPlayer.play(word.audioUrl);
  }
}
```

### 4. ProgressModel (typeId: 3)

User progress tracking with stage-level granularity.

**Fields:**
- `id` - Progress ID
- `userId` - User ID
- `lessonId` - Lesson ID
- `status` - "not_started", "in_progress", "completed", "failed"
- `quizScore` - Quiz score (0-100)
- `timeSpent` - Time spent (seconds)
- `startedAt` - Start timestamp
- `completedAt` - Completion timestamp
- `stageProgress` - Stage-level progress (JSON)
- `attempts` - Number of attempts
- `isSynced` - Sync status

**Stage Progress Structure:**
```json
{
  "stage1_intro": true,
  "stage2_vocabulary": true,
  "stage3_grammar": false,
  "stage4_practice": false,
  "stage5_dialogue": false,
  "stage6_quiz": false,
  "stage7_summary": false
}
```

**Helpers:**
- `isNotStarted`, `isInProgress`, `isCompleted` - Status checks
- `isPassed` - Check if quiz score >= 80
- `progressPercentage` - 0-100 based on stages
- `timeSpentFormatted` - "30分15秒"
- `statusDisplay` - Chinese status display
- `scoreGrade` - "A", "B", "C", "D", "F"

**Usage:**
```dart
final progress = await progressRepo.getLessonProgress(userId, lessonId);

print('Progress: ${progress.progressPercentage}%');
print('Status: ${progress.statusDisplay}');
print('Score: ${progress.quizScore} (${progress.scoreGrade})');
```

### 5. ReviewModel (typeId: 4)

SRS (Spaced Repetition System) review scheduling.

**Fields:**
- `id` - Review ID
- `userId` - User ID
- `vocabularyId` - Vocabulary ID
- `nextReview` - Next review date
- `interval` - Interval in days
- `easeFactor` - Ease factor (SM-2 algorithm)
- `repetitions` - Number of successful reviews
- `lastReviewedAt` - Last review timestamp
- `lastQuality` - Last quality rating (0-5)

**Helpers:**
- `isDue` - Check if review is due now
- `daysUntilReview` - Days until next review
- `dueStatus` - "该复习了", "今天", "明天", "3天后"

**Usage:**
```dart
final dueReviews = await progressRepo.getDueReviews(userId);

for (final review in dueReviews) {
  print('Review vocabulary ${review.vocabularyId}');
  print('Status: ${review.dueStatus}');
}

// Submit review result (quality: 0-5)
await progressRepo.submitReview(userId, vocabId, quality: 4);
```

---

## Repositories

### 1. AuthRepository

Handles user authentication with JWT tokens.

**Methods:**

#### `register(email, password, username)`
Register new user and save locally.

```dart
final result = await authRepo.register(
  email: 'user@example.com',
  password: 'password123',
  username: 'John',
);

if (result.success) {
  print('User: ${result.user?.username}');
  print('Token: ${result.token}');
} else {
  print('Error: ${result.message}');
}
```

#### `login(email, password)`
Login user and save session.

```dart
final result = await authRepo.login(
  email: 'user@example.com',
  password: 'password123',
);

if (result.success) {
  // Navigate to home
}
```

#### `logout()`
Logout and clear all local data.

```dart
await authRepo.logout();
```

#### `refreshToken(refreshToken)`
Refresh access token.

```dart
final success = await authRepo.refreshToken(oldToken);
```

#### `getCurrentUserId()`
Get current user ID from local storage.

```dart
final userId = authRepo.getCurrentUserId();
if (userId != null) {
  // User is logged in
}
```

#### `isLoggedIn()`
Check if user is logged in.

```dart
if (authRepo.isLoggedIn()) {
  // Show home screen
} else {
  // Show login screen
}
```

---

### 2. ContentRepository

Manages lessons and vocabulary with offline-first pattern.

**Methods:**

#### `getLessons({level})`
Get all lessons, optionally filtered by level.

```dart
// All lessons
final allLessons = await contentRepo.getLessons();

// Level 1 lessons
final level1 = await contentRepo.getLessons(level: 1);
```

#### `getLesson(id)`
Get single lesson (local first, then network).

```dart
final lesson = await contentRepo.getLesson(123);
if (lesson != null) {
  print(lesson.displayTitle);
}
```

#### `downloadLessonPackage(id)`
Download complete lesson package with content.

```dart
final lesson = await contentRepo.downloadLessonPackage(123);
if (lesson != null && lesson.isDownloaded) {
  print('Downloaded: ${lesson.titleKo}');
}
```

#### `checkForUpdates(localVersions)`
Check if lessons need updates.

```dart
final localVersions = {
  123: '1.0.0',
  124: '1.0.1',
};

final outdated = await contentRepo.checkForUpdates(localVersions);
print('Need updates: $outdated'); // [123]
```

#### `getDownloadedLessons()`
Get all downloaded lessons (offline).

```dart
final offline = await contentRepo.getDownloadedLessons();
print('${offline.length} lessons available offline');
```

#### `deleteDownloadedLesson(id)`
Delete downloaded lesson content.

```dart
await contentRepo.deleteDownloadedLesson(123);
```

#### `getVocabularyByLesson(lessonId)`
Get vocabulary for specific lesson.

```dart
final words = await contentRepo.getVocabularyByLesson(123);
```

#### `getVocabularyByLevel(level)`
Get vocabulary by difficulty level.

```dart
final level1Words = await contentRepo.getVocabularyByLevel(1);
```

#### `searchVocabulary(query)`
Search vocabulary (local only for speed).

```dart
final results = await contentRepo.searchVocabulary('안녕');
```

#### `getSimilarVocabulary(vocabularyId, {limit})`
Get similar vocabulary by similarity score.

```dart
final similar = await contentRepo.getSimilarVocabulary(456, limit: 5);
```

#### `clearCache()`
Clear all cached content.

```dart
await contentRepo.clearCache();
```

#### `getCacheStats()`
Get cache statistics.

```dart
final stats = await contentRepo.getCacheStats();
print('Lessons: ${stats['total_lessons']}');
print('Downloaded: ${stats['downloaded_lessons']}');
```

---

### 3. ProgressRepository

Tracks user progress and SRS reviews with offline sync.

**Methods:**

#### `getUserProgress(userId)`
Get all progress for user.

```dart
final allProgress = await progressRepo.getUserProgress(userId);
```

#### `getLessonProgress(userId, lessonId)`
Get progress for specific lesson.

```dart
final progress = await progressRepo.getLessonProgress(userId, lessonId);
if (progress != null) {
  print('${progress.progressPercentage}% complete');
}
```

#### `startLesson(userId, lessonId)`
Start lesson (mark as in_progress).

```dart
final progress = await progressRepo.startLesson(userId, lessonId);
```

#### `completeLesson(userId, lessonId, quizScore, timeSpent, stageProgress)`
Complete lesson with score and stages.

```dart
final progress = await progressRepo.completeLesson(
  userId,
  lessonId,
  quizScore: 85,
  timeSpent: 1800, // 30 minutes
  stageProgress: {
    'stage1_intro': true,
    'stage2_vocabulary': true,
    'stage3_grammar': true,
    'stage4_practice': true,
    'stage5_dialogue': true,
    'stage6_quiz': true,
    'stage7_summary': true,
  },
);

print('Grade: ${progress.scoreGrade}');
```

#### `updateStageProgress(userId, lessonId, stageName, stageData)`
Update individual stage progress.

```dart
await progressRepo.updateStageProgress(
  userId,
  lessonId,
  'stage2_vocabulary',
  true,
);
```

#### `getReviewSchedule(userId)`
Get all SRS reviews for user.

```dart
final reviews = await progressRepo.getReviewSchedule(userId);
```

#### `getDueReviews(userId)`
Get reviews that are due now.

```dart
final dueReviews = await progressRepo.getDueReviews(userId);
print('${dueReviews.length} reviews due');
```

#### `submitReview(userId, vocabularyId, quality)`
Submit review result (quality: 0-5).

Uses SuperMemo SM-2 algorithm:
- **0** - Complete blackout
- **1** - Incorrect, but familiar
- **2** - Incorrect, but remembered
- **3** - Correct with difficulty
- **4** - Correct with hesitation
- **5** - Perfect recall

```dart
final review = await progressRepo.submitReview(
  userId,
  vocabularyId,
  quality: 4, // Correct with hesitation
);

print('Next review: ${review?.dueStatus}');
```

#### `syncProgress()`
Sync all pending progress (called by SyncManager).

```dart
final result = await progressRepo.syncProgress();
print('Synced: ${result.syncedCount}');
print('Failed: ${result.failedCount}');
```

#### `getUserStats(userId)`
Get user statistics.

```dart
final stats = await progressRepo.getUserStats(userId);
print('Completed: ${stats['completed_lessons']}');
print('Average Score: ${stats['average_score']}');
print('Time Spent: ${stats['total_time_spent']} seconds');
```

---

### 4. OfflineRepository

Unified interface for offline data management.

**Methods:**

#### `init()`
Initialize offline functionality.

```dart
await offlineRepo.init();
```

#### `downloadLesson(lessonId, {onProgress, onComplete})`
Download lesson with all media files.

```dart
final success = await offlineRepo.downloadLesson(
  123,
  onProgress: (lessonId, progress) {
    print('${progress.percentage}% - ${progress.message}');
  },
  onComplete: (lessonId) {
    print('Download complete!');
  },
);
```

#### `cancelDownload(lessonId)`
Cancel active download.

```dart
offlineRepo.cancelDownload(123);
```

#### `getDownloadProgress(lessonId)`
Get download progress for lesson.

```dart
final progress = offlineRepo.getDownloadProgress(123);
if (progress != null) {
  print('${progress.percentage}%');
}
```

#### `isDownloading(lessonId)`
Check if lesson is currently downloading.

```dart
if (offlineRepo.isDownloading(123)) {
  print('Download in progress...');
}
```

#### `isLessonAvailableOffline(lessonId)`
Check if lesson is fully available offline.

```dart
final available = await offlineRepo.isLessonAvailableOffline(123);
if (available) {
  // Can play offline
}
```

#### `getOfflineLessons()`
Get all lessons available offline.

```dart
final offlineLessons = await offlineRepo.getOfflineLessons();
```

#### `syncAll()`
Sync all offline data.

```dart
final result = await offlineRepo.syncAll();
print('Synced ${result.syncedCount} items');
```

#### `isOnline()`
Check if network is available.

```dart
if (offlineRepo.isOnline()) {
  print('Connected to internet');
}
```

#### `getSyncQueueSize()`
Get number of pending sync items.

```dart
final queueSize = offlineRepo.getSyncQueueSize();
print('$queueSize items pending sync');
```

#### `getStorageStats()`
Get storage statistics.

```dart
final stats = await offlineRepo.getStorageStats();
print('Storage: ${stats.totalStorageMB.toStringAsFixed(2)} MB');
print('Downloaded: ${stats.downloadedLessons}/${stats.totalLessons}');
print('Media files: ${stats.mediaFileCount}');
print('Sync queue: ${stats.syncQueueSize}');
```

#### `deleteLesson(lessonId)`
Delete lesson and associated media.

```dart
await offlineRepo.deleteLesson(123);
```

#### `deleteAllDownloads()`
Delete all downloaded content.

```dart
await offlineRepo.deleteAllDownloads();
```

#### `clearAllCache()`
Clear all cache (keeps progress).

```dart
await offlineRepo.clearAllCache();
```

#### `clearAllData()`
Clear everything (use with caution).

```dart
await offlineRepo.clearAllData();
```

#### `cleanupOldFiles({maxSizeMB})`
Cleanup old files using LRU.

```dart
await offlineRepo.cleanupOldFiles(maxSizeMB: 500);
```

#### `exportUserData(userId)`
Export user data for backup.

```dart
final backup = await offlineRepo.exportUserData(userId);
// Save to file or cloud
```

#### `importUserData(data)`
Import user data from backup.

```dart
await offlineRepo.importUserData(backupData);
```

#### `getDiagnostics()`
Get diagnostic information.

```dart
final diagnostics = await offlineRepo.getDiagnostics();
print(diagnostics);
```

#### `verifyIntegrity()`
Verify data integrity.

```dart
final issues = await offlineRepo.verifyIntegrity();
if (issues.isEmpty) {
  print('All data is intact');
} else {
  print('Issues found:');
  for (final issue in issues) {
    print('- $issue');
  }
}
```

---

## Offline-First Pattern

All repositories follow the offline-first pattern:

1. **Read Operations:**
   - Check local storage first
   - Fetch from network in background
   - Update local storage
   - Return local data immediately

2. **Write Operations:**
   - Save to local storage first
   - Add to sync queue
   - Try to sync immediately
   - Background sync if network unavailable

3. **Sync Queue:**
   - All write operations added to queue
   - Automatic sync on network recovery
   - Periodic sync every 5 minutes
   - Manual sync available

### Example Flow

```dart
// User completes lesson offline
final progress = await progressRepo.completeLesson(
  userId: 123,
  lessonId: 456,
  quizScore: 85,
  timeSpent: 1800,
);

// Data saved locally ✓
// Added to sync queue ✓
// Sync attempted (fails - offline) ✗

// ... User connects to WiFi ...

// SyncManager detects network recovery
// Automatic sync triggered
final result = await offlineRepo.syncAll();

// All pending progress synced ✓
// Queue cleared ✓
```

---

## Hive Type Adapters

To generate Hive type adapters, run:

```bash
flutter packages pub run build_runner build
```

This generates `.g.dart` files:
- `user_model.g.dart`
- `lesson_model.g.dart`
- `vocabulary_model.g.dart`
- `progress_model.g.dart`

---

## Testing

### Unit Tests

Test repositories with mock API client:

```dart
test('ContentRepository fetches lessons offline', () async {
  final repo = ContentRepository();

  // Mock network failure
  when(apiClient.getLessons()).thenThrow(Exception('Network error'));

  // Should fallback to local
  final lessons = await repo.getLessons();
  expect(lessons, isNotEmpty);
});
```

### Integration Tests

Test full offline flow:

```dart
testWidgets('Download and play lesson offline', (tester) async {
  // Download lesson
  await offlineRepo.downloadLesson(123);

  // Disconnect network
  await connectivity.setConnectivity(ConnectivityResult.none);

  // Play lesson
  final lesson = await contentRepo.getLesson(123);
  expect(lesson, isNotNull);
  expect(lesson!.isDownloaded, true);

  // Complete lesson
  final progress = await progressRepo.completeLesson(
    userId: 1,
    lessonId: 123,
    quizScore: 90,
    timeSpent: 1500,
  );

  expect(progress.isSynced, false);
  expect(offlineRepo.getSyncQueueSize(), 1);

  // Reconnect and sync
  await connectivity.setConnectivity(ConnectivityResult.wifi);
  final result = await offlineRepo.syncAll();

  expect(result.success, true);
  expect(offlineRepo.getSyncQueueSize(), 0);
});
```

---

## Performance Considerations

### Caching Strategy

- **Lessons**: Cache in Hive, expire on version change
- **Vocabulary**: Cache indefinitely, update on sync
- **Progress**: Always local first, sync in background
- **Media**: LRU cache with 500MB limit

### Sync Optimization

- **Batch sync**: Group similar operations
- **Debouncing**: Wait 5 seconds before syncing stage progress
- **Retry**: 3 attempts with exponential backoff
- **Conflict resolution**: Server wins on conflicts

### Storage Limits

- **Max cache size**: 500 MB (configurable)
- **Max sync queue**: 1000 items (warn at 100)
- **LRU cleanup**: Delete oldest accessed files first
- **Orphan cleanup**: Remove media without lesson references

---

## Next Steps

1. **Generate Hive adapters**: `flutter packages pub run build_runner build`
2. **Implement providers**: Create ChangeNotifier providers for each repository
3. **Build UI screens**: Use providers to bind data to widgets
4. **Add tests**: Write unit and integration tests
5. **Optimize sync**: Fine-tune sync intervals and batch sizes
