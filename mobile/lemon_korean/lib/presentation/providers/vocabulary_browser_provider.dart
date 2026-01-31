import 'package:flutter/foundation.dart';
import '../../data/models/vocabulary_model.dart';
import '../../data/repositories/content_repository.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';

enum VocabSortType {
  level,          // Sort by level (lowest first)
  alphabetical,   // Sort by Korean alphabetically
  similarity,     // Sort by similarity_score (highest first)
}

class VocabularyBrowserProvider with ChangeNotifier {
  final ContentRepository _repository = ContentRepository();

  // State
  Map<int, List<VocabularyModel>> _vocabularyByLevel = {};
  int _currentLevel = 1;
  String _searchQuery = '';
  VocabSortType _sortType = VocabSortType.alphabetical;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get currentLevel => _currentLevel;
  String get searchQuery => _searchQuery;
  VocabSortType get sortType => _sortType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<VocabularyModel> get currentVocabulary {
    final words = _vocabularyByLevel[_currentLevel] ?? [];

    // Apply search filter
    var filtered = words;
    if (_searchQuery.isNotEmpty) {
      filtered = words.where((word) {
        final query = _searchQuery.toLowerCase();
        return word.korean.toLowerCase().contains(query) ||
               word.chinese.toLowerCase().contains(query) ||
               (word.pinyin?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sort
    return _sortWords(filtered, _sortType);
  }

  int get currentWordCount => currentVocabulary.length;

  Map<int, int> get wordCountsByLevel {
    return _vocabularyByLevel.map((level, words) => MapEntry(level, words.length));
  }

  // Methods
  Future<void> loadVocabularyForLevel(int level) async {
    if (_vocabularyByLevel.containsKey(level)) {
      // Already loaded
      _currentLevel = level;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _currentLevel = level;
    notifyListeners();

    try {
      // Check Hive cache first
      final cached = await LocalStorage.getVocabularyByLevel(level);
      if (cached != null && cached.isNotEmpty) {
        final cacheAge = await LocalStorage.getVocabularyCacheAge(level);
        if (cacheAge != null && cacheAge.inDays < 7) {
          // Cache is fresh - convert to VocabularyModel
          _vocabularyByLevel[level] = cached.map((item) => VocabularyModel.fromJson(item)).toList();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Fetch from API
      final words = await _repository.getVocabularyByLevel(level);
      if (words != null && words.isNotEmpty) {
        _vocabularyByLevel[level] = words;
        // Save to cache - convert to JSON
        await LocalStorage.saveVocabularyByLevel(level, words.map((w) => w.toJson()).toList());
      } else {
        _errorMessage = 'No vocabulary found for level $level';
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading vocabulary for level $level: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortType(VocabSortType type) {
    _sortType = type;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> refreshCurrentLevel() async {
    _vocabularyByLevel.remove(_currentLevel);
    await loadVocabularyForLevel(_currentLevel);
  }

  List<VocabularyModel> _sortWords(List<VocabularyModel> words, VocabSortType type) {
    final sorted = List<VocabularyModel>.from(words);

    switch (type) {
      case VocabSortType.level:
        sorted.sort((a, b) => a.level.compareTo(b.level));
        break;

      case VocabSortType.alphabetical:
        sorted.sort((a, b) => a.korean.compareTo(b.korean));
        break;

      case VocabSortType.similarity:
        sorted.sort((a, b) {
          final aScore = a.similarityScore ?? 0;
          final bScore = b.similarityScore ?? 0;
          return bScore.compareTo(aScore); // Descending
        });
        break;
    }

    return sorted;
  }

  @override
  void dispose() {
    _vocabularyByLevel.clear();
    super.dispose();
  }
}
