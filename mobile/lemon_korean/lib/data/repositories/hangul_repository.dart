import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/result.dart';
import '../../core/utils/app_exception.dart';
import '../../core/platform/platform_factory.dart';
import '../models/hangul_character_model.dart';
import '../models/hangul_progress_model.dart';

/// Hangul Repository
/// Handles Korean alphabet characters and learning progress with offline-first pattern
class HangulRepository {
  // Hive box names
  static const String _charactersBoxName = 'hangul_characters';
  static const String _progressBoxName = 'hangul_progress';

  // Helper to create Dio with token
  Future<Dio> _createContentDio() async {
    final storage = PlatformFactory.createSecureStorage();
    final token = await storage.read(key: AppConstants.tokenKey);

    return Dio(BaseOptions(
      baseUrl: AppConstants.contentUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));
  }

  Future<Dio> _createProgressDio() async {
    final storage = PlatformFactory.createSecureStorage();
    final token = await storage.read(key: AppConstants.tokenKey);

    return Dio(BaseOptions(
      baseUrl: AppConstants.progressUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));
  }

  // ================================================================
  // CHARACTERS
  // ================================================================

  /// Get all hangul characters
  Future<Result<List<HangulCharacterModel>>> getCharactersResult({
    String? characterType,
  }) async {
    try {
      final dio = await _createContentDio();
      final response = await dio.get(
        '/api/content/hangul/characters',
        queryParameters: {
          if (characterType != null) 'character_type': characterType,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['characters'] ?? [];
        final characters =
            data.map((json) => HangulCharacterModel.fromJson(json)).toList();

        // Save to local storage
        await _saveCharactersLocal(characters);

        return Success(characters, isFromCache: false);
      }

      // Fallback to local
      final cached = await _getLocalCharacters(characterType: characterType);
      return Error(
        'Server returned status ${response.statusCode}',
        code: ErrorCodes.serverError,
        cachedData: cached,
      );
    } catch (e, stackTrace) {
      AppLogger.w('getCharacters error', tag: 'HangulRepository', error: e);

      final cached = await _getLocalCharacters(characterType: characterType);
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(
        exception.message,
        code: exception.code,
        cachedData: cached,
      );
    }
  }

  /// Get all hangul characters (simple version)
  Future<List<HangulCharacterModel>> getCharacters({
    String? characterType,
  }) async {
    final result = await getCharactersResult(characterType: characterType);
    return result.when(
      success: (data, _) => data,
      error: (_, __, cachedData) => cachedData ?? [],
    );
  }

  /// Get alphabet table (organized by type)
  Future<Result<Map<String, List<HangulCharacterModel>>>> getAlphabetTableResult() async {
    try {
      final dio = await _createContentDio();
      final response = await dio.get('/api/content/hangul/table');

      if (response.statusCode == 200) {
        final tableData = response.data['table'] as Map<String, dynamic>? ?? {};

        final table = <String, List<HangulCharacterModel>>{};

        tableData.forEach((key, value) {
          if (value is List) {
            table[key] = value
                .map((json) => HangulCharacterModel.fromJson(json))
                .toList();
          }
        });

        // Save all characters
        final allCharacters = table.values.expand((list) => list).toList();
        await _saveCharactersLocal(allCharacters);

        return Success(table, isFromCache: false);
      }

      // Fallback
      final cached = await _getLocalAlphabetTable();
      return Error(
        'Server returned status ${response.statusCode}',
        code: ErrorCodes.serverError,
        cachedData: cached,
      );
    } catch (e, stackTrace) {
      AppLogger.w('getAlphabetTable error', tag: 'HangulRepository', error: e);

      final cached = await _getLocalAlphabetTable();
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(
        exception.message,
        code: exception.code,
        cachedData: cached,
      );
    }
  }

  /// Get single character by ID
  Future<HangulCharacterModel?> getCharacter(int id) async {
    try {
      // Check local first
      final localChar = await _getLocalCharacter(id);

      // Try remote
      final dio = await _createContentDio();
      final response = await dio.get('/api/content/hangul/characters/$id');

      if (response.statusCode == 200) {
        final char = HangulCharacterModel.fromJson(response.data['character']);
        await _saveCharacterLocal(char);
        return char;
      }

      return localChar;
    } catch (e) {
      AppLogger.w('[HangulRepository] getCharacter error: $e');
      return _getLocalCharacter(id);
    }
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  /// Get user's hangul progress
  Future<Result<List<HangulProgressModel>>> getProgressResult(int userId) async {
    try {
      final dio = await _createProgressDio();
      final response = await dio.get('/api/progress/hangul/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['progress'] ?? [];
        final progress =
            data.map((json) => HangulProgressModel.fromJson(json)).toList();

        // Save to local
        await _saveProgressLocal(userId, progress);

        return Success(progress, isFromCache: false);
      }

      final cached = await _getLocalProgress(userId);
      return Error(
        'Server returned status ${response.statusCode}',
        code: ErrorCodes.serverError,
        cachedData: cached,
      );
    } catch (e, stackTrace) {
      AppLogger.w('getProgress error', tag: 'HangulRepository', error: e);

      final cached = await _getLocalProgress(userId);
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(
        exception.message,
        code: exception.code,
        cachedData: cached,
      );
    }
  }

  /// Get hangul stats
  Future<HangulStats?> getStats(int userId) async {
    try {
      final dio = await _createProgressDio();
      final response = await dio.get('/api/progress/hangul/$userId');

      if (response.statusCode == 200 && response.data['stats'] != null) {
        return HangulStats.fromJson(response.data['stats']);
      }
      return null;
    } catch (e) {
      AppLogger.w('[HangulRepository] getStats error: $e');
      return null;
    }
  }

  /// Record practice result for a character
  Future<Result<Map<String, dynamic>>> recordPractice({
    required int userId,
    required int characterId,
    required bool isCorrect,
    int? responseTime,
  }) async {
    try {
      final dio = await _createProgressDio();
      final response = await dio.post(
        '/api/progress/hangul/$userId/$characterId',
        data: {
          'is_correct': isCorrect,
          'response_time': responseTime ?? 0,
        },
      );

      if (response.statusCode == 200) {
        // Update local progress
        await _updateLocalProgress(userId, characterId, response.data);

        return Success(response.data, isFromCache: false);
      }

      return const Error(
        'Failed to record practice',
        code: ErrorCodes.serverError,
      );
    } catch (e, stackTrace) {
      AppLogger.w('recordPractice error', tag: 'HangulRepository', error: e);

      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(exception.message, code: exception.code);
    }
  }

  /// Get characters due for review
  Future<Result<List<HangulCharacterModel>>> getReviewScheduleResult(
      int userId, {int limit = 20}) async {
    try {
      final dio = await _createProgressDio();
      final response = await dio.get(
        '/api/progress/hangul/review/$userId',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        // Convert review items to character models (may need enrichment)
        final characters = <HangulCharacterModel>[];

        for (final item in items) {
          final characterId = item['character_id'] as int;
          final char = await getCharacter(characterId);
          if (char != null) {
            characters.add(char);
          }
        }

        return Success(characters, isFromCache: false);
      }

      return const Error(
        'Failed to get review schedule',
        code: ErrorCodes.serverError,
      );
    } catch (e, stackTrace) {
      AppLogger.w('getReviewSchedule error', tag: 'HangulRepository', error: e);

      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(exception.message, code: exception.code);
    }
  }

  // ================================================================
  // LOCAL STORAGE HELPERS
  // ================================================================

  Future<void> _saveCharactersLocal(List<HangulCharacterModel> characters) async {
    try {
      for (final char in characters) {
        await LocalStorage.saveToBox(_charactersBoxName, char.id.toString(), char.toJson());
      }
    } catch (e) {
      AppLogger.w('[HangulRepository] saveCharactersLocal error: $e');
    }
  }

  Future<void> _saveCharacterLocal(HangulCharacterModel char) async {
    try {
      await LocalStorage.saveToBox(_charactersBoxName, char.id.toString(), char.toJson());
    } catch (e) {
      AppLogger.w('[HangulRepository] saveCharacterLocal error: $e');
    }
  }

  Future<List<HangulCharacterModel>> _getLocalCharacters({
    String? characterType,
  }) async {
    try {
      final allData = LocalStorage.getAllFromBox<Map<dynamic, dynamic>>(_charactersBoxName);
      var characters = allData
          .map((data) => HangulCharacterModel.fromJson(Map<String, dynamic>.from(data)))
          .toList();

      if (characterType != null) {
        characters = characters
            .where((c) => c.characterType == characterType)
            .toList();
      }

      characters.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return characters;
    } catch (e) {
      AppLogger.w('[HangulRepository] getLocalCharacters error: $e');
      return [];
    }
  }

  Future<HangulCharacterModel?> _getLocalCharacter(int id) async {
    try {
      final data = LocalStorage.getFromBox<Map<dynamic, dynamic>>(
          _charactersBoxName, id.toString());
      if (data != null) {
        return HangulCharacterModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      AppLogger.w('[HangulRepository] getLocalCharacter error: $e');
      return null;
    }
  }

  Future<Map<String, List<HangulCharacterModel>>> _getLocalAlphabetTable() async {
    final characters = await _getLocalCharacters();

    final table = <String, List<HangulCharacterModel>>{
      'basic_consonants': [],
      'double_consonants': [],
      'basic_vowels': [],
      'compound_vowels': [],
    };

    for (final char in characters) {
      switch (char.characterType) {
        case 'basic_consonant':
          table['basic_consonants']!.add(char);
          break;
        case 'double_consonant':
          table['double_consonants']!.add(char);
          break;
        case 'basic_vowel':
          table['basic_vowels']!.add(char);
          break;
        case 'compound_vowel':
          table['compound_vowels']!.add(char);
          break;
      }
    }

    return table;
  }

  Future<void> _saveProgressLocal(int userId, List<HangulProgressModel> progress) async {
    try {
      for (final p in progress) {
        final key = '${userId}_${p.characterId}';
        await LocalStorage.saveToBox(_progressBoxName, key, p.toJson());
      }
    } catch (e) {
      AppLogger.w('[HangulRepository] saveProgressLocal error: $e');
    }
  }

  Future<List<HangulProgressModel>> _getLocalProgress(int userId) async {
    try {
      final allData = LocalStorage.getAllFromBox<Map<dynamic, dynamic>>(_progressBoxName);
      return allData
          .map((data) => HangulProgressModel.fromJson(Map<String, dynamic>.from(data)))
          .where((p) => p.userId == userId)
          .toList();
    } catch (e) {
      AppLogger.w('[HangulRepository] getLocalProgress error: $e');
      return [];
    }
  }

  Future<void> _updateLocalProgress(
      int userId, int characterId, Map<String, dynamic> data) async {
    try {
      final key = '${userId}_$characterId';
      final existing = LocalStorage.getFromBox<Map<dynamic, dynamic>>(_progressBoxName, key);

      if (existing != null) {
        final updated = Map<String, dynamic>.from(existing);
        updated.addAll(data);
        await LocalStorage.saveToBox(_progressBoxName, key, updated);
      }
    } catch (e) {
      AppLogger.w('[HangulRepository] updateLocalProgress error: $e');
    }
  }
}
