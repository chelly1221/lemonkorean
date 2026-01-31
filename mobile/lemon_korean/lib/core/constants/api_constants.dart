/// API Configuration Constants
class ApiConstants {
  // Base URL - Single domain for all services
  static const String baseUrl = 'https://lemon.3chan.kr';
  static const String apiVersion = 'v1';

  // API Endpoints - Using Nginx API Gateway (no port-specific URLs)
  static const String authBaseUrl = '$baseUrl/api/auth';
  static const String contentBaseUrl = '$baseUrl/api/content';
  static const String progressBaseUrl = '$baseUrl/api/progress';
  static const String mediaBaseUrl = '$baseUrl/media';
  static const String analyticsBaseUrl = '$baseUrl/api/analytics';
  static const String adminBaseUrl = '$baseUrl/api/admin';

  // Auth Endpoints
  static const String loginEndpoint = '$authBaseUrl/login';
  static const String registerEndpoint = '$authBaseUrl/register';
  static const String refreshEndpoint = '$authBaseUrl/refresh';
  static const String logoutEndpoint = '$authBaseUrl/logout';
  static const String verifyEndpoint = '$authBaseUrl/verify';

  // Content Endpoints
  static const String lessonsEndpoint = '$contentBaseUrl/lessons';
  static const String vocabularyEndpoint = '$contentBaseUrl/vocabulary';
  static const String grammarEndpoint = '$contentBaseUrl/grammar';
  static const String checkUpdatesEndpoint = '$contentBaseUrl/check-updates';

  // Progress Endpoints
  static const String userProgressEndpoint = '$progressBaseUrl/user';
  static const String completeEndpoint = '$progressBaseUrl/complete';
  static const String syncEndpoint = '$progressBaseUrl/sync';
  static const String reviewScheduleEndpoint = '$progressBaseUrl/review-schedule';

  // Media Endpoints
  static const String imagesEndpoint = '$mediaBaseUrl/images';
  static const String audioEndpoint = '$mediaBaseUrl/audio';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);

  ApiConstants._();
}
