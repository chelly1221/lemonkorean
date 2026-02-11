import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../data/models/lemon_reward_model.dart';

/// Manages gamification state: lemon rewards per lesson, total lemon points,
/// tree lemons, and boss quiz completion.
class GamificationProvider with ChangeNotifier {
  static const String _rewardsBox = 'lemon_rewards';
  static const String _currencyBox = 'lemon_currency';
  static const String _bossBox = 'boss_quiz';

  // Cached lemon rewards (lesson_id -> LemonRewardModel)
  final Map<int, LemonRewardModel> _rewards = {};

  // Lemon currency
  int _totalLemons = 0;
  int _treeLemonsAvailable = 0;
  int _treeLemonsHarvested = 0;

  // Boss quiz completion (chapter key -> bool)
  final Map<String, bool> _bossQuizCompleted = {};

  // Server settings (with defaults matching migration 009)
  int _lemon3Threshold = 95;
  int _lemon2Threshold = 80;
  int _bossQuizBonus = 5;
  int _bossQuizPassPercent = 70;
  int _maxTreeLemons = 10;
  bool _adsEnabled = true;
  String _admobRewardedAdId = '';

  // Getters
  int get totalLemons => _totalLemons;
  int get treeLemonsAvailable => _treeLemonsAvailable;
  int get treeLemonsHarvested => _treeLemonsHarvested;
  int get lemon3Threshold => _lemon3Threshold;
  int get lemon2Threshold => _lemon2Threshold;
  int get bossQuizBonus => _bossQuizBonus;
  int get bossQuizPassPercent => _bossQuizPassPercent;
  int get maxTreeLemons => _maxTreeLemons;
  bool get adsEnabled => _adsEnabled;
  String get admobRewardedAdId => _admobRewardedAdId;

  /// Get lemons earned for a specific lesson (0 if not completed)
  int getLemonsForLesson(int lessonId) {
    return _rewards[lessonId]?.lemonsEarned ?? 0;
  }

  /// Get the LemonRewardModel for a lesson (null if not completed)
  LemonRewardModel? getRewardForLesson(int lessonId) {
    return _rewards[lessonId];
  }

  /// Check if boss quiz is completed for a chapter
  bool isBossQuizCompleted(int level, int week) {
    return _bossQuizCompleted['${level}_$week'] ?? false;
  }

  /// Load all saved rewards and currency from local storage,
  /// then fetch server settings (non-blocking on failure).
  Future<void> loadFromStorage() async {
    // Load rewards
    final allRewards = LocalStorage.getAllFromBox<Map>(_rewardsBox);
    _rewards.clear();
    for (final raw in allRewards) {
      try {
        final reward = LemonRewardModel.fromJson(Map<String, dynamic>.from(raw));
        _rewards[reward.lessonId] = reward;
      } catch (e) {
        debugPrint('[Gamification] Failed to parse reward: $e');
      }
    }

    // Load currency
    final currency = LocalStorage.getFromBox<Map>(_currencyBox, 'balance');
    if (currency != null) {
      _totalLemons = currency['total_lemons'] as int? ?? 0;
      _treeLemonsAvailable = currency['tree_lemons_available'] as int? ?? 0;
      _treeLemonsHarvested = currency['tree_lemons_harvested'] as int? ?? 0;
    }

    // Load boss quiz completions
    final bossData = LocalStorage.getAllFromBox<Map>(_bossBox);
    _bossQuizCompleted.clear();
    for (final raw in bossData) {
      final key = raw['key'] as String?;
      if (key != null) {
        _bossQuizCompleted[key] = true;
      }
    }

    // Fetch server settings (best-effort, keep defaults on failure)
    await _fetchServerSettings();

    notifyListeners();
  }

  /// Fetch gamification settings from server.
  Future<void> _fetchServerSettings() async {
    try {
      final dio = Dio()..options.connectTimeout = const Duration(seconds: 5);
      final response = await dio.get(
        '${ApiConstants.adminBaseUrl}/gamification/settings',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        _lemon3Threshold = data['lemon_3_threshold'] as int? ?? 95;
        _lemon2Threshold = data['lemon_2_threshold'] as int? ?? 80;
        _bossQuizBonus = data['boss_quiz_bonus'] as int? ?? 5;
        _bossQuizPassPercent = data['boss_quiz_pass_percent'] as int? ?? 70;
        _maxTreeLemons = data['max_tree_lemons'] as int? ?? 10;
        _adsEnabled = data['ads_enabled'] as bool? ?? true;
        _admobRewardedAdId = data['admob_rewarded_ad_id'] as String? ?? '';
        debugPrint('[Gamification] Server settings loaded (v${data['version']})');
      }
    } catch (e) {
      debugPrint('[Gamification] Failed to fetch server settings, using defaults: $e');
    }
  }

  /// Record lemon reward for a completed lesson.
  /// Returns the number of lemons earned (may be 0 if no improvement).
  Future<int> recordLessonReward({
    required int lessonId,
    required int quizScorePercent,
  }) async {
    final newLemons = LemonRewardModel.calculateLemons(
      quizScorePercent,
      t3: _lemon3Threshold,
      t2: _lemon2Threshold,
    );
    final existing = _rewards[lessonId];

    // Only update if new score is better
    if (existing != null && existing.lemonsEarned >= newLemons) {
      return 0; // No improvement
    }

    final additionalLemons = newLemons - (existing?.lemonsEarned ?? 0);

    final reward = LemonRewardModel(
      lessonId: lessonId,
      lemonsEarned: newLemons,
      bestQuizScore: quizScorePercent,
      earnedAt: DateTime.now(),
    );

    // Save reward
    _rewards[lessonId] = reward;
    await LocalStorage.saveToBox(_rewardsBox, 'lesson_$lessonId', reward.toJson());

    // Update currency
    _totalLemons += additionalLemons;
    _treeLemonsAvailable += additionalLemons;
    await _saveCurrency();

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'lemon_reward',
      'data': {
        'lesson_id': lessonId,
        'lemons_earned': newLemons,
        'best_quiz_score': quizScorePercent,
        'additional_lemons': additionalLemons,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
    return additionalLemons;
  }

  /// Record boss quiz completion bonus.
  /// Uses server [_bossQuizBonus] by default.
  Future<void> recordBossQuizBonus({
    required int level,
    required int week,
    int? bonusLemons,
  }) async {
    bonusLemons ??= _bossQuizBonus;
    final key = '${level}_$week';
    if (_bossQuizCompleted[key] == true) return; // Already completed

    _bossQuizCompleted[key] = true;
    await LocalStorage.saveToBox(_bossBox, key, {'key': key, 'completed_at': DateTime.now().toIso8601String()});

    // Add bonus lemons
    _totalLemons += bonusLemons;
    _treeLemonsAvailable += bonusLemons;
    await _saveCurrency();

    await LocalStorage.addToSyncQueue({
      'type': 'boss_quiz_bonus',
      'data': {
        'level': level,
        'week': week,
        'bonus_lemons': bonusLemons,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// Harvest a lemon from the tree (after watching ad)
  Future<bool> harvestLemon() async {
    if (_treeLemonsAvailable <= 0) return false;

    _treeLemonsAvailable--;
    _treeLemonsHarvested++;
    await _saveCurrency();

    await LocalStorage.addToSyncQueue({
      'type': 'lemon_harvest',
      'data': {
        'harvested_at': DateTime.now().toIso8601String(),
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
    return true;
  }

  /// Save currency to local storage
  Future<void> _saveCurrency() async {
    await LocalStorage.saveToBox(_currencyBox, 'balance', {
      'total_lemons': _totalLemons,
      'tree_lemons_available': _treeLemonsAvailable,
      'tree_lemons_harvested': _treeLemonsHarvested,
    });
  }

  /// Spend lemons (for shop purchases). Returns true if successful.
  Future<bool> spendLemons(int amount) async {
    if (amount <= 0 || _totalLemons < amount) return false;

    _totalLemons -= amount;
    await _saveCurrency();

    await LocalStorage.addToSyncQueue({
      'type': 'lemon_spend',
      'data': {
        'amount': amount,
        'spent_at': DateTime.now().toIso8601String(),
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
    return true;
  }

  /// Get total lemons earned across all lessons
  int get totalLemonsEarned {
    int total = 0;
    for (final reward in _rewards.values) {
      total += reward.lemonsEarned;
    }
    return total;
  }
}
