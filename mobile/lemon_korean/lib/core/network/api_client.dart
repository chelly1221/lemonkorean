import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

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
    return await _dio.get(
      '/content/lessons',
      queryParameters: {
        if (level != null) 'level': level,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
  }

  Future<Response> getLesson(int lessonId) async {
    return await _dio.get('/content/lessons/$lessonId');
  }

  Future<Response> downloadLessonPackage(int lessonId) async {
    return await _dio.get('/content/lessons/$lessonId/download');
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
    return await _dio.get('/content/vocabulary?lesson_id=$lessonId');
  }

  Future<Response> getVocabularyByLevel(int level) async {
    return await _dio.get('/content/vocabulary?level=$level');
  }

  Future<Response> getVocabularyByIds(List<int> ids) async {
    return await _dio.post(
      '/content/vocabulary/batch',
      data: {'ids': ids},
    );
  }

  Future<Response> getSimilarVocabulary(
      String korean, {double minScore = 0.7}) async {
    return await _dio.get(
      '/content/vocabulary/similar',
      queryParameters: {'korean': korean, 'min_score': minScore},
    );
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  Future<Response> getUserProgress(int userId) async {
    return await _dio.get('/progress/user/$userId');
  }

  Future<Response> completeLesson({
    required int lessonId,
    required int quizScore,
    required int timeSpent,
  }) async {
    return await _dio.post(
      '/progress/complete',
      data: {
        'lesson_id': lessonId,
        'quiz_score': quizScore,
        'time_spent': timeSpent,
      },
    );
  }

  Future<Response> syncProgress(List<Map<String, dynamic>> progressData) async {
    return await _dio.post(
      '/progress/sync',
      data: {'progress': progressData},
    );
  }

  Future<Response> getReviewSchedule(int userId, {int limit = 20}) async {
    return await _dio.get(
      '/progress/review-schedule/$userId',
      queryParameters: {'limit': limit},
    );
  }

  Future<Response> markReviewDone(Map<String, dynamic> data) async {
    return await _dio.post(
      '/progress/review/complete',
      data: data,
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

  _AuthInterceptor(this._storage);

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

          // Retry original request
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await Dio().fetch(opts);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed - logout user
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
    if (AppConstants.enableDebugMode) {
      print('┌─────────────────────────────────────────────────────');
      print('│ [REQUEST] ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) {
        print('│ Data: ${options.data}');
      }
      print('└─────────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConstants.enableDebugMode) {
      print('┌─────────────────────────────────────────────────────');
      print('│ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
      print('│ Data: ${response.data}');
      print('└─────────────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConstants.enableDebugMode) {
      print('┌─────────────────────────────────────────────────────');
      print('│ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('│ Message: ${err.message}');
      print('│ Response: ${err.response?.data}');
      print('└─────────────────────────────────────────────────────');
    }
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
