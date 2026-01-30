import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../config/environment_config.dart';
import '../utils/app_logger.dart';
import '../../data/models/network_config_model.dart';

/// API Client using Dio
/// Handles HTTP requests with authentication and error handling
class ApiClient {
  static final ApiClient instance = ApiClient._init();

  late final Dio _dio;
  final _secureStorage = const FlutterSecureStorage();

  ApiClient._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiUrl,
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

  /// Update base URL after network config is loaded
  /// Must be called after AppConstants.updateFromConfig()
  void updateBaseUrl() {
    _dio.options.baseUrl = AppConstants.apiUrl;
    AppLogger.d('Updated base URL to: ${_dio.options.baseUrl}', tag: 'ApiClient');
  }

  // Helper method to create Dio instance for specific service
  Dio _createServiceDio(String baseURL) {
    return Dio(BaseOptions(
      baseUrl: baseURL,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: _dio.options.headers,  // Include auth headers
    ));
  }

  // ================================================================
  // NETWORK CONFIG
  // ================================================================

  /// Fetch network configuration from server
  /// This should be called BEFORE any other API calls
  /// Uses URLs from EnvironmentConfig (loaded from .env files)
  Future<NetworkConfigModel> getNetworkConfig() async {
    print('[ApiClient] Fetching network config from: ${EnvironmentConfig.adminUrl}');
    try {
      // Try admin service port first (for development mode)
      // Then fall back to gateway if that fails
      final configDio = Dio(BaseOptions(
        baseUrl: EnvironmentConfig.adminUrl,  // From .env file
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      print('[ApiClient] Making request to /api/admin/network/config');
      final response = await configDio.get('/api/admin/network/config');

      print('[ApiClient] Network config SUCCESS: ${response.data}');
      AppLogger.d('Network config response: ${response.data}', tag: 'ApiClient');

      return NetworkConfigModel.fromJson(response.data['config']);
    } catch (e) {
      print('[ApiClient] Network config FAILED from admin: $e');
      AppLogger.w('Failed to fetch network config from admin service', tag: 'ApiClient', error: e);

      // Try gateway as fallback
      try {
        final gatewayDio = Dio(BaseOptions(
          baseUrl: EnvironmentConfig.baseUrl,  // From .env file
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

        final response = await gatewayDio.get('/api/admin/network/config');
        AppLogger.d('Network config from gateway: ${response.data}', tag: 'ApiClient');
        return NetworkConfigModel.fromJson(response.data['config']);
      } catch (e2) {
        AppLogger.w('Failed to fetch from gateway too', tag: 'ApiClient', error: e2);
        AppLogger.i('Using default config from environment', tag: 'ApiClient');
        return NetworkConfigModel.defaultConfig();
      }
    }
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
    final contentDio = _createServiceDio(AppConstants.contentUrl);

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
    final contentDio = _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/lessons/$lessonId');
  }

  Future<Response> downloadLessonPackage(int lessonId) async {
    final contentDio = _createServiceDio(AppConstants.contentUrl);
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
    final contentDio = _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/vocabulary?lesson_id=$lessonId');
  }

  Future<Response> getVocabularyByLevel(int level) async {
    final contentDio = _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get('/api/content/vocabulary?level=$level');
  }

  Future<Response> getVocabularyByIds(List<int> ids) async {
    final contentDio = _createServiceDio(AppConstants.contentUrl);
    return await contentDio.post(
      '/api/content/vocabulary/batch',
      data: {'ids': ids},
    );
  }

  Future<Response> getSimilarVocabulary(
      String korean, {double minScore = 0.7}) async {
    final contentDio = _createServiceDio(AppConstants.contentUrl);
    return await contentDio.get(
      '/api/content/vocabulary/similar',
      queryParameters: {'korean': korean, 'min_score': minScore},
    );
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  Future<Response> getUserProgress(int userId) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/user/$userId');
  }

  Future<Response> getUserStats(int userId) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/stats/$userId');
  }

  Future<Response> getLessonProgress(int userId, int lessonId) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get('/api/progress/lesson/$lessonId');
  }

  Future<Response> startLesson(int userId, int lessonId) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/sync',
      data: {'progress': progressData},
    );
  }

  Future<Response> getReviewSchedule(int userId, {int limit = 20}) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.get(
      '/api/progress/review-schedule/$userId',
      queryParameters: {'limit': limit},
    );
  }

  Future<Response> markReviewDone(Map<String, dynamic> data) async {
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
    return await progressDio.post(
      '/api/progress/vocabulary/practice',
      data: {
        'user_id': userId,
        'vocabulary_id': vocabularyId,
        'quality': quality,
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
    final progressDio = _createServiceDio(AppConstants.progressUrl);
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
  final FlutterSecureStorage _storage;

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
