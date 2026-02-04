import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../platform/platform_factory.dart';
import '../platform/secure_storage_interface.dart';
import '../utils/app_logger.dart';

/// API Client using Dio
/// Handles HTTP requests with authentication and error handling
class ApiClient {
  static final ApiClient instance = ApiClient._init();

  late final Dio _dio;
  late final ISecureStorage _secureStorage;

  ApiClient._init() {
    _secureStorage = PlatformFactory.createSecureStorage();
    _dio = Dio(
      BaseOptions(
        // baseUrl will be set later after environment loads
        baseUrl: '',  // Empty initially
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor(_secureStorage));
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
  }

  Dio get dio => _dio;

  /// Ensure ApiClient is properly initialized with base URL
  /// Uses the static production URL from AppConstants
  Future<void> ensureInitialized() async {
    if (_dio.options.baseUrl.isEmpty || _dio.options.baseUrl == '') {
      _dio.options.baseUrl = AppConstants.apiUrl;
      AppLogger.d('Initialized base URL to: ${_dio.options.baseUrl}', tag: 'ApiClient');
    }
  }

  // Helper method to create Dio instance for specific service with token
  Future<Dio> _createServiceDio(String baseURL) async {
    // Read token from secure storage
    final token = await _secureStorage.read(key: AppConstants.tokenKey);

    return Dio(BaseOptions(
      baseUrl: baseURL,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));
  }

  // ================================================================
  // AUTH
  // ================================================================

  Future<Response> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'username': username,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );
  }

  Future<Response> getUserProfile() async {
    return await _dio.get('/auth/profile');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  // ================================================================
  // CONTENT
  // ================================================================

  Future<Response> getLessons({
    int? level,
    int? page,
    int? limit,
    String? language,
  }) async {
    // Use contentUrl for lesson data
    final contentDio = await _createServiceDio(AppConstants.contentUrl);

    return await contentDio.get(
      '/api/content/lessons',
      queryParameters: {
        if (level != null) 'level': level,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> getLesson(int lessonId, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/lessons/$lessonId',
      queryParameters: {
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> downloadLessonPackage(int lessonId, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/lessons/$lessonId/download',
      queryParameters: {
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> checkUpdates(List<Map<String, dynamic>> lessons) async {
    return await _dio.post(
      '/content/check-updates',
      data: {'lessons': lessons},
    );
  }

  Future<Response> checkLessonUpdates(
      Map<int, String> localVersions) async {
    return await _dio.post(
      '/content/check-updates',
      data: {'lessons': localVersions},
    );
  }

  Future<Response> getVocabularyByLesson(int lessonId, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary',
      queryParameters: {
        'lesson_id': lessonId,
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> getVocabularyByLevel(int level, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary',
      queryParameters: {
        'level': level,
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> getVocabularyByIds(List<int> ids, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.post(
      '/api/content/vocabulary/batch',
      data: {'ids': ids},
      queryParameters: {
        if (language != null) 'language': language,
      },
    );
  }

  Future<Response> getSimilarVocabulary(
      String korean, {double minScore = 0.7, String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary/similar',
      queryParameters: {
        'korean': korean,
        'min_score': minScore,
        if (language != null) 'language': language,
      },
    );
  }

  /// Get grammar rules with optional language
  Future<Response> getGrammar({int? level, String? category, String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/grammar',
      queryParameters: {
        if (level != null) 'level': level,
        if (category != null) 'category': category,
        if (language != null) 'language': language,
      },
    );
  }

  /// Get grammar rule by ID with optional language
  Future<Response> getGrammarById(int id, {String? language}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/grammar/$id',
      queryParameters: {
        if (language != null) 'language': language,
      },
    );
  }

  // ================================================================
  // BOOKMARKS
  // ================================================================

  /// Create a new vocabulary bookmark
  Future<Response> createBookmark(int vocabularyId, {String? notes}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.post(
      '/api/content/vocabulary/bookmarks',
      data: {
        'vocabulary_id': vocabularyId,
        if (notes != null) 'notes': notes,
      },
    );
  }

  /// Get all user bookmarks (with pagination)
  Future<Response> getUserBookmarks({int page = 1, int limit = 20}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary/bookmarks',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
  }

  /// Get single bookmark by ID
  Future<Response> getBookmark(int bookmarkId) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/vocabulary/bookmarks/$bookmarkId');
  }

  /// Update bookmark notes
  Future<Response> updateBookmarkNotes(int bookmarkId, String notes) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.put(
      '/api/content/vocabulary/bookmarks/$bookmarkId',
      data: {'notes': notes},
    );
  }

  /// Delete a bookmark
  Future<Response> deleteBookmark(int bookmarkId) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.delete('/api/content/vocabulary/bookmarks/$bookmarkId');
  }

  /// Batch create bookmarks
  Future<Response> createBookmarksBatch(List<Map<String, dynamic>> bookmarks) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.post(
      '/api/content/vocabulary/bookmarks/batch',
      data: {'bookmarks': bookmarks},
    );
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  Future<Response> getUserProgress(int userId) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/user/$userId');
  }

  Future<Response> getUserStats(int userId) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/stats/$userId');
  }

  Future<Response> getLessonProgress(int userId, int lessonId) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/lesson/$lessonId');
  }

  Future<Response> startLesson(int userId, int lessonId) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/update',
      data: {
        'user_id': userId,
        'lesson_id': lessonId,
        'status': 'in_progress',
      },
    );
  }

  Future<Response> completeLesson({
    required int lessonId,
    required int quizScore,
    required int timeSpent,
  }) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/complete',
      data: {
        'lesson_id': lessonId,
        'quiz_score': quizScore,
        'time_spent': timeSpent,
      },
    );
  }

  Future<Response> syncProgress(List<Map<String, dynamic>> progressData) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/sync',
      data: {'progress': progressData},
    );
  }

  Future<Response> getReviewSchedule(int userId, {int limit = 20}) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get(
      '/api/progress/review-schedule/$userId',
      queryParameters: {'limit': limit},
    );
  }

  Future<Response> markReviewDone(Map<String, dynamic> data) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/review/complete',
      data: data,
    );
  }

  /// Submit a vocabulary review with SRS quality rating
  Future<Response> submitReview(
    int userId,
    int vocabularyId, {
    required int quality,
  }) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/vocabulary/practice',
      data: {
        'user_id': userId,
        'vocabulary_id': vocabularyId,
        'quality': quality,
      },
    );
  }

  /// Submit batch vocabulary results from lesson quiz
  Future<Response> updateVocabularyBatch({
    required int userId,
    required int lessonId,
    required List<Map<String, dynamic>> vocabularyResults,
  }) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/vocabulary/batch',
      data: {
        'user_id': userId,
        'lesson_id': lessonId,
        'vocabulary_results': vocabularyResults,
      },
    );
  }

  // ================================================================
  // LEARNING SESSIONS
  // ================================================================

  /// Start a learning session
  Future<Response> startLearningSession({
    required int userId,
    required int lessonId,
    required String sessionType,
    required String deviceType,
  }) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/session/start',
      data: {
        'user_id': userId,
        'lesson_id': lessonId,
        'session_type': sessionType,
        'device_type': deviceType,
      },
    );
  }

  /// End a learning session
  Future<Response> endLearningSession({
    required int sessionId,
    required int itemsStudied,
    required int correctAnswers,
    required int incorrectAnswers,
  }) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/session/end',
      data: {
        'session_id': sessionId,
        'items_studied': itemsStudied,
        'correct_answers': correctAnswers,
        'incorrect_answers': incorrectAnswers,
      },
    );
  }

  /// Get session statistics for a user
  Future<Response> getSessionStats(int userId) async {
    final progressDio = await _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/session/stats/$userId');
  }

  // ================================================================
  // USER PREFERENCES
  // ================================================================

  /// Update user preferences
  Future<Response> updateUserPreferences(Map<String, dynamic> prefs) async {
    return await _dio.put(
      '/auth/preferences',
      data: prefs,
    );
  }

  // ================================================================
  // ANALYTICS
  // ================================================================

  Future<Response> logEvent({
    required String eventType,
    required Map<String, dynamic> eventData,
  }) async {
    return await _dio.post(
      '/analytics/events',
      data: {
        'event_type': eventType,
        'event_data': eventData,
      },
    );
  }

  // ================================================================
  // MEDIA
  // ================================================================

  String getMediaUrl(String mediaType, String key) {
    return '${AppConstants.mediaUrl}/$mediaType/$key';
  }

  Future<Response> downloadMedia(String url) async {
    return await _dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
  }

  // ================================================================
  // THEME
  // ================================================================

  /// Get app theme settings from admin API
  /// This is a public endpoint (no authentication required)
  Future<Response> getAppTheme() async {
    await ensureInitialized();
    return await _dio.get('/admin/app-theme/settings');
  }
}

// ================================================================
// INTERCEPTORS
// ================================================================

/// Auth Interceptor - Adds JWT token to requests
class _AuthInterceptor extends Interceptor {
  final ISecureStorage _storage;

  /// Dedicated Dio instance for retrying requests (without interceptors to avoid infinite loops)
  late final Dio _retryDio;

  _AuthInterceptor(this._storage) {
    // Create a separate Dio instance for retries without interceptors
    _retryDio = Dio(BaseOptions(
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _storage.read(key: AppConstants.tokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Try to refresh token
    if (err.response?.statusCode == 401) {
      final refreshToken =
          await _storage.read(key: AppConstants.refreshTokenKey);

      if (refreshToken != null) {
        try {
          // Refresh token
          final response = await ApiClient.instance.refreshToken(refreshToken);

          final newToken = response.data['token'];
          final newRefreshToken = response.data['refresh_token'];

          // Save new tokens
          await _storage.write(key: AppConstants.tokenKey, value: newToken);
          await _storage.write(
            key: AppConstants.refreshTokenKey,
            value: newRefreshToken,
          );

          // Retry original request using dedicated retry Dio instance
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await _retryDio.fetch(opts);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed - logout user
          AppLogger.w('Token refresh failed, logging out user', tag: 'Auth', error: e);
          await _storage.delete(key: AppConstants.tokenKey);
          await _storage.delete(key: AppConstants.refreshTokenKey);
        }
      }
    }

    handler.next(err);
  }
}

/// Logging Interceptor - Logs requests and responses in debug mode
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logRequest(
      options.method,
      options.uri.toString(),
      headers: options.headers.cast<String, dynamic>(),
      data: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logResponse(
      response.statusCode,
      response.requestOptions.uri.toString(),
      data: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logNetworkError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      error: err.message,
      statusCode: err.response?.statusCode,
    );
    handler.next(err);
  }
}

/// Error Interceptor - Handles and formats errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = AppConstants.networkErrorMessage;
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(err.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = '요청이 취소되었습니다';
        break;
      default:
        errorMessage = AppConstants.unknownErrorMessage;
    }

    // Create custom error
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    handler.next(customError);
  }

  String _handleResponseError(Response? response) {
    if (response == null) {
      return AppConstants.serverErrorMessage;
    }

    switch (response.statusCode) {
      case 400:
        return response.data['message'] ?? '요청 파라미터 오류';
      case 401:
        return AppConstants.authErrorMessage;
      case 403:
        return '접근 권한이 없습니다';
      case 404:
        return '요청한 리소스가 존재하지 않습니다';
      case 429:
        return '요청이 너무 많습니다. 나중에 다시 시도하세요';
      case 500:
      case 502:
      case 503:
        return AppConstants.serverErrorMessage;
      default:
        return response.data['message'] ?? AppConstants.unknownErrorMessage;
    }
  }
}
