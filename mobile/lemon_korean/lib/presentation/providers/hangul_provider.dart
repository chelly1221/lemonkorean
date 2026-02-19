import 'package:flutter/foundation.dart';

import '../../data/models/hangul_character_model.dart';
import '../../data/models/hangul_lesson_progress_model.dart';
import '../../data/models/hangul_progress_model.dart';
import '../../data/repositories/hangul_repository.dart';
import '../../core/utils/app_logger.dart';

/// Hangul learning state
enum HangulLoadingState {
  initial,
  loading,
  loaded,
  error,
}

/// Hangul Provider
/// Manages Korean alphabet learning state
class HangulProvider with ChangeNotifier {
  final HangulRepository _repository = HangulRepository();

  // Characters
  List<HangulCharacterModel> _characters = [];
  Map<String, List<HangulCharacterModel>> _alphabetTable = {};
  HangulCharacterModel? _selectedCharacter;

  // Progress
  List<HangulProgressModel> _progress = [];
  HangulStats? _stats;
  Map<int, HangulProgressModel> _progressMap = {};

  // Lesson progress (Stage 0+ interactive lessons)
  final Map<String, HangulLessonProgressModel> _lessonProgress = {};

  // Review/Practice
  List<HangulCharacterModel> _reviewQueue = [];
  int _currentReviewIndex = 0;

  // State
  HangulLoadingState _loadingState = HangulLoadingState.initial;
  String? _errorMessage;

  // Getters
  List<HangulCharacterModel> get characters => _characters;
  Map<String, List<HangulCharacterModel>> get alphabetTable => _alphabetTable;
  HangulCharacterModel? get selectedCharacter => _selectedCharacter;
  List<HangulProgressModel> get progress => _progress;
  HangulStats? get stats => _stats;
  List<HangulCharacterModel> get reviewQueue => _reviewQueue;
  int get currentReviewIndex => _currentReviewIndex;
  HangulLoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _loadingState == HangulLoadingState.loading;

  // Computed getters
  List<HangulCharacterModel> get basicConsonants =>
      _alphabetTable['basic_consonants'] ?? [];
  List<HangulCharacterModel> get doubleConsonants =>
      _alphabetTable['double_consonants'] ?? [];
  List<HangulCharacterModel> get basicVowels =>
      _alphabetTable['basic_vowels'] ?? [];
  List<HangulCharacterModel> get compoundVowels =>
      _alphabetTable['compound_vowels'] ?? [];

  HangulCharacterModel? get currentReviewCharacter =>
      _currentReviewIndex < _reviewQueue.length
          ? _reviewQueue[_currentReviewIndex]
          : null;

  /// All characters (alias for characters)
  List<HangulCharacterModel> get allCharacters => _characters;

  int get dueForReviewCount => _stats?.dueForReview ?? 0;
  double get overallProgress => _stats?.progressPercent ?? 0.0;

  /// Get progress for a specific character
  HangulProgressModel? getProgressForCharacter(int characterId) {
    return _progressMap[characterId];
  }

  /// Check if character is mastered
  bool isCharacterMastered(int characterId) {
    final progress = _progressMap[characterId];
    return progress != null && progress.isMastered;
  }

  /// Check if character is due for review
  bool isCharacterDueForReview(int characterId) {
    final progress = _progressMap[characterId];
    return progress == null || progress.isDueForReview;
  }

  /// Find character by its Korean character string
  HangulCharacterModel? findCharacterByChar(String char) {
    try {
      return _characters.firstWhere((c) => c.character == char);
    } catch (_) {
      return null;
    }
  }

  // ================================================================
  // ACTIONS
  // ================================================================

  /// Load alphabet table
  Future<void> loadAlphabetTable() async {
    _loadingState = HangulLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getAlphabetTableResult();

    result.when(
      success: (data, _) {
        _alphabetTable = data;
        _characters = data.values.expand((list) => list).toList();
        _loadingState = HangulLoadingState.loaded;
        AppLogger.i('[HangulProvider] Loaded ${_characters.length} characters');
      },
      error: (message, code, cachedData) {
        if (cachedData != null && cachedData.isNotEmpty) {
          _alphabetTable = cachedData;
          _characters = cachedData.values.expand((list) => list).toList();
          _loadingState = HangulLoadingState.loaded;
          AppLogger.w('[HangulProvider] Using cached data: $message');
        } else {
          _errorMessage = message;
          _loadingState = HangulLoadingState.error;
        }
      },
    );

    notifyListeners();
  }

  /// Load characters (simple list)
  Future<void> loadCharacters({String? characterType}) async {
    _loadingState = HangulLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getCharactersResult(
      characterType: characterType,
    );

    result.when(
      success: (data, _) {
        _characters = data;
        _loadingState = HangulLoadingState.loaded;
      },
      error: (message, code, cachedData) {
        if (cachedData != null && cachedData.isNotEmpty) {
          _characters = cachedData;
          _loadingState = HangulLoadingState.loaded;
        } else {
          _errorMessage = message;
          _loadingState = HangulLoadingState.error;
        }
      },
    );

    notifyListeners();
  }

  /// Load user progress
  Future<void> loadProgress(int userId) async {
    final result = await _repository.getProgressResult(userId);

    result.when(
      success: (data, _) {
        _progress = data;
        _progressMap = {for (var p in data) p.characterId: p};
      },
      error: (message, code, cachedData) {
        if (cachedData != null) {
          _progress = cachedData;
          _progressMap = {for (var p in cachedData) p.characterId: p};
        }
      },
    );

    // Also load stats
    _stats = await _repository.getStats(userId);

    notifyListeners();
  }

  /// Select a character for detail view
  void selectCharacter(HangulCharacterModel character) {
    _selectedCharacter = character;
    notifyListeners();
  }

  /// Clear selected character
  void clearSelectedCharacter() {
    _selectedCharacter = null;
    notifyListeners();
  }

  /// Load review queue
  Future<void> loadReviewQueue(int userId, {int limit = 20}) async {
    final result = await _repository.getReviewScheduleResult(userId, limit: limit);

    result.when(
      success: (data, _) {
        _reviewQueue = data;
        _currentReviewIndex = 0;
      },
      error: (message, code, cachedData) {
        // If no review schedule from server, create from local progress
        _reviewQueue = _characters
            .where((c) => isCharacterDueForReview(c.id))
            .take(limit)
            .toList();
        _currentReviewIndex = 0;
      },
    );

    notifyListeners();
  }

  /// Record a practice attempt
  Future<bool> recordPractice({
    required int userId,
    required int characterId,
    required bool isCorrect,
    int? responseTime,
  }) async {
    final result = await _repository.recordPractice(
      userId: userId,
      characterId: characterId,
      isCorrect: isCorrect,
      responseTime: responseTime,
    );

    bool success = false;
    result.when(
      success: (data, isFromCache) {
        success = true;
        final existing = _progressMap[characterId];
        if (existing != null) {
          // Extract SRS data from server response (inside 'srs' object)
          final srs = data['srs'] as Map<String, dynamic>?;

          final updated = existing.copyWith(
            masteryLevel: srs?['mastery_level'] as int? ?? existing.masteryLevel,
            correctCount: isCorrect
                ? existing.correctCount + 1
                : existing.correctCount,
            wrongCount: !isCorrect
                ? existing.wrongCount + 1
                : existing.wrongCount,
            streakCount: isCorrect ? existing.streakCount + 1 : 0,
            easeFactor: (srs?['easiness_factor'] as num?)?.toDouble() ??
                existing.easeFactor,
            intervalDays: srs?['interval_days'] as int? ?? existing.intervalDays,
            nextReview: srs?['next_review_at'] != null
                ? DateTime.tryParse(srs!['next_review_at'].toString())
                : existing.nextReview,
            lastPracticed: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _progressMap[characterId] = updated;

          // Sync _progress list with _progressMap
          final idx = _progress.indexWhere((p) => p.characterId == characterId);
          if (idx >= 0) {
            _progress[idx] = updated;
          }
        } else {
          // No existing progress - create new entry
          final srs = data['srs'] as Map<String, dynamic>?;
          final newProgress = HangulProgressModel(
            id: 0,
            userId: userId,
            characterId: characterId,
            masteryLevel: srs?['mastery_level'] as int? ?? (isCorrect ? 1 : 0),
            correctCount: isCorrect ? 1 : 0,
            wrongCount: isCorrect ? 0 : 1,
            streakCount: isCorrect ? 1 : 0,
            easeFactor: (srs?['easiness_factor'] as num?)?.toDouble() ?? 2.5,
            intervalDays: srs?['interval_days'] as int? ?? 1,
            nextReview: srs?['next_review_at'] != null
                ? DateTime.tryParse(srs!['next_review_at'].toString())
                : null,
            lastPracticed: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _progressMap[characterId] = newProgress;
          _progress.add(newProgress);
        }
      },
      error: (message, code, _) {
        AppLogger.e('[HangulProvider] recordPractice error: $message');
        success = false;
      },
    );

    notifyListeners();
    return success;
  }

  /// Move to next review item
  void nextReviewItem() {
    if (_currentReviewIndex < _reviewQueue.length - 1) {
      _currentReviewIndex++;
      notifyListeners();
    }
  }

  /// Check if review session is complete
  bool get isReviewComplete => _currentReviewIndex >= _reviewQueue.length - 1;

  /// Reset review session
  void resetReview() {
    _currentReviewIndex = 0;
    notifyListeners();
  }

  /// Shuffle review queue
  void shuffleReviewQueue() {
    _reviewQueue.shuffle();
    _currentReviewIndex = 0;
    notifyListeners();
  }

  // ================================================================
  // LESSON PROGRESS (Stage 0+ interactive lessons)
  // ================================================================

  /// Get lesson progress by lesson ID (e.g. '0-1').
  HangulLessonProgressModel? getLessonProgress(String lessonId) {
    return _lessonProgress[lessonId];
  }

  /// Get all completed lesson IDs for a stage.
  int getCompletedLessonCount(int stage) {
    return _lessonProgress.values
        .where((p) => p.lessonId.startsWith('$stage-') && p.isCompleted)
        .length;
  }

  /// Load lesson progress from local storage.
  Future<void> loadLessonProgress() async {
    try {
      final allData = await _repository.getAllLessonProgress();
      _lessonProgress.clear();
      for (final p in allData) {
        _lessonProgress[p.lessonId] = p;
      }
      notifyListeners();
    } catch (e) {
      AppLogger.w('[HangulProvider] loadLessonProgress error: $e');
    }
  }

  /// Mark a lesson as completed and save progress.
  Future<void> completeLesson({
    required String lessonId,
    required int totalSteps,
    required int bestScore,
    required int lemonsEarned,
  }) async {
    final existing = _lessonProgress[lessonId];

    // Only update if new score is better or not yet completed
    if (existing != null && existing.isCompleted && existing.bestScore >= bestScore) {
      return;
    }

    final progress = HangulLessonProgressModel(
      lessonId: lessonId,
      userId: 0, // Will be set by repository
      completedSteps: totalSteps,
      totalSteps: totalSteps,
      isCompleted: true,
      bestScore: bestScore,
      lemonsEarned: lemonsEarned,
      completedAt: DateTime.now(),
    );

    _lessonProgress[lessonId] = progress;
    notifyListeners();

    await _repository.saveLessonProgress(progress);
  }

  /// Clear all data (for logout)
  void clear() {
    _characters = [];
    _alphabetTable = {};
    _selectedCharacter = null;
    _progress = [];
    _stats = null;
    _progressMap = {};
    _reviewQueue = [];
    _currentReviewIndex = 0;
    _lessonProgress.clear();
    _loadingState = HangulLoadingState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
