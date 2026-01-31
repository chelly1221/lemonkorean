import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';

class LessonProvider with ChangeNotifier {
  final _apiClient = ApiClient.instance;

  List<Map<String, dynamic>> _lessons = [];
  Map<String, dynamic>? _currentLesson;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get lessons => _lessons;
  Map<String, dynamic>? get currentLesson => _currentLesson;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch lessons from API or local storage
  Future<void> fetchLessons({int? level}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try to fetch from API
      final response = await _apiClient.getLessons(level: level);

      if (response.statusCode == 200) {
        _lessons = List<Map<String, dynamic>>.from(response.data['lessons']);

        // Save to local storage
        for (final lesson in _lessons) {
          await LocalStorage.saveLesson(lesson);
        }

        _isLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      // Network error - fallback to local storage
      _errorMessage = e.toString();
    }

    // Load from local storage
    _lessons = LocalStorage.getAllLessons();
    _isLoading = false;
    notifyListeners();
  }

  /// Get lesson by ID
  Future<void> getLesson(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check local storage first
      final localLesson = LocalStorage.getLesson(lessonId);

      if (localLesson != null) {
        _currentLesson = localLesson;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch from API
      final response = await _apiClient.getLesson(lessonId);

      if (response.statusCode == 200) {
        _currentLesson = response.data;

        // Save to local storage
        await LocalStorage.saveLesson(_currentLesson!);

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Download lesson package
  Future<bool> downloadLessonPackage(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.downloadLessonPackage(lessonId);

      if (response.statusCode == 200) {
        final package = response.data;

        // Save lesson to local storage
        await LocalStorage.saveLesson(package);

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Download failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
