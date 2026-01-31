import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/app_constants.dart';
import '../config/environment_config.dart';
import '../platform/platform_factory.dart';
import '../platform/secure_storage_interface.dart';
import '../utils/app_logger.dart';
import '../../data/models/network_config_model.dart';

// Conditional import for web platform
import 'dart:html' as html if (dart.library.io) '';

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
  /// Must be called after EnvironmentConfig.init() and AppConstants.initFromEnvironment()
  Future<void> ensureInitialized() async {
    if (_dio.options.baseUrl.isEmpty || _dio.options.baseUrl == '') {
      _dio.options.baseUrl = AppConstants.apiUrl;
      AppLogger.d('Initialized base URL to: ${_dio.options.baseUrl}', tag: 'ApiClient');
    }
  }

  /// Update base URL after network config is loaded
  /// Must be called after AppConstants.updateFromConfig()
  void updateBaseUrl() {
    _dio.options.baseUrl = AppConstants.apiUrl;
    AppLogger.d('Updated base URL to: ${_dio.options.baseUrl}', tag: 'ApiClient');
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
  // NETWORK CONFIG
  // ================================================================

  /// Fetch network configuration from server
  /// This should be called BEFORE any other API calls
  /// Tries multiple URLs with comprehensive fallback logic:
  /// 1. For web: Nginx gateway first (avoids CORS)
  /// 2. Production/environment URLs
  /// 3. Development URL fallbacks
  Future<NetworkConfigModel> getNetworkConfig() async {
    // Build comprehensive list of URLs to try
    final urls = <String>[];

    if (kIsWeb) {
      // For web: Try Nginx gateway first (port 80/443) to avoid CORS
      try {
        final currentHost = html.window.location.host; // e.g., "3chan.kr:3007"
        final baseHost = currentHost.split(':')[0]; // "3chan.kr"

        // Try Nginx routes first (same-origin, no CORS)
        urls.add('http://$baseHost');  // Nginx gateway with /api/admin/network/config route
        urls.add(html.window.location.origin);  // Current origin (e.g., http://3chan.kr:3007)
        urls.add('http://$baseHost:3006');  // Admin service direct
        print('[ApiClient] Web platform detected, host: $baseHost');
      } catch (e) {
        print('[ApiClient] Could not get window.location: $e');
      }
    } else {
      // Mobile: Try admin service and environment URLs
      urls.add(EnvironmentConfig.adminUrl);
      urls.add(EnvironmentConfig.baseUrl);
    }

    // Fallbacks for both platforms
    urls.add('http://3chan.kr');                   // Production Nginx
    urls.add('http://3chan.kr:3006');              // Production Admin
    urls.add('http://localhost:3006');             // Local dev
    urls.add('http://192.168.0.100:3006');         // Local network dev

    // Remove duplicates while preserving order
    final uniqueUrls = <String>[];
    for (final url in urls) {
      if (!uniqueUrls.contains(url)) {
        uniqueUrls.add(url);
      }
    }

    print('[ApiClient] Will try ${uniqueUrls.length} URLs for network config');

    // Try each URL until one succeeds
    for (final url in uniqueUrls) {
      try {
        print('[ApiClient] Trying network config from: $url');
        final configDio = Dio(BaseOptions(
          baseUrl: url,
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

        final response = await configDio.get('/api/admin/network/config');
        print('[ApiClient] Network config SUCCESS from: $url');
        AppLogger.d('Network config response: ${response.data}', tag: 'ApiClient');
        return NetworkConfigModel.fromJson(response.data['config']);
      } catch (e) {
        print('[ApiClient] Network config FAILED from $url: $e');
      }
    }

    // All attempts failed, use default config
    print('[ApiClient] All ${uniqueUrls.length} attempts failed, using default config');
    AppLogger.i('Using default config from environment', tag: 'ApiClient');
    return NetworkConfigModel.defaultConfig();
  }

  /// URL에서 호스트 부분만 추출 (scheme://host)
  String _extractHost(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}';
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

  Future<Response> getUserProfile(int userId) async {
    return await _dio.get('/auth/profile/$userId');
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
  }) async {
    // Use contentUrl for lesson data (supports dev mode direct port access)
    final contentDio = await _createServiceDio(AppConstants.contentUrl);

    return await contentDio.get(
      '/api/content/lessons',
      queryParameters: {
        if (level != null) 'level': level,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
  }

  Future<Response> getLesson(int lessonId) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/lessons/$lessonId');
  }

  Future<Response> downloadLessonPackage(int lessonId) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/lessons/$lessonId/download');
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

  Future<Response> getVocabularyByLesson(int lessonId) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/vocabulary?lesson_id=$lessonId');
  }

  Future<Response> getVocabularyByLevel(int level) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/vocabulary?level=$level');
  }

  Future<Response> getVocabularyByIds(List<int> ids) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.post(
      '/api/content/vocabulary/batch',
      data: {'ids': ids},
    );
  }

  Future<Response> getSimilarVocabulary(
      String korean, {double minScore = 0.7}) async {
    final contentDio = await _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary/similar',
      queryParameters: {'korean': korean, 'min_score': minScore},
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
        errorMessage = '请求已取消';
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
        return response.data['message'] ?? '请求参数错误';
      case 401:
        return AppConstants.authErrorMessage;
      case 403:
        return '没有权限访问';
      case 404:
        return '请求的资源不存在';
      case 429:
        return '请求过于频繁，请稍后重试';
      case 500:
      case 502:
      case 503:
        return AppConstants.serverErrorMessage;
      default:
        return response.data['message'] ?? AppConstants.unknownErrorMessage;
    }
  }
}
