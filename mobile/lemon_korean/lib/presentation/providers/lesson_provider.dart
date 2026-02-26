import 'package:flutter/foundation.dart';

import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../data/repositories/content_repository.dart';

class LessonProvider with ChangeNotifier {
  final _contentRepository = ContentRepository();

  List<Map<String, dynamic>> _lessons = [];
  Map<String, dynamic>? _currentLesson;
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get lessons => _lessons;
  Map<String, dynamic>? get currentLesson => _currentLesson;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLessons({int? level, String? language}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lessonModels =
          await _contentRepository.getLessons(level: level, language: language);
      _lessons = lessonModels.map((lesson) => lesson.toJson()).toList();
    } catch (e) {
      _errorMessage = e.toString();
      _lessons = LocalStorage.getAllLessons();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getLesson(int lessonId, {String? language}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lesson =
          await _contentRepository.getLesson(lessonId, language: language);
      _currentLesson = lesson?.toJson();
    } catch (e) {
      _errorMessage = e.toString();
      _currentLesson = LocalStorage.getLesson(lessonId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> downloadLessonPackage(int lessonId, {String? language}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lesson = await _contentRepository.downloadLessonPackage(lessonId,
          language: language);
      _isLoading = false;
      notifyListeners();
      return lesson != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
