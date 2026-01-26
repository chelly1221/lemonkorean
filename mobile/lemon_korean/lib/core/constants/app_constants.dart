import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Lemon Korean';
  static const String appNameChinese = '柠檬韩语';
  static const String version = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'http://3chan.kr:3001'; // Auth service
  static const String apiUrl = '$baseUrl/api';
  static const String mediaUrl = 'http://3chan.kr:3004/media';

  // Endpoints
  static const String authEndpoint = '$apiUrl/auth';
  static const String contentEndpoint = '$apiUrl/content';
  static const String progressEndpoint = '$apiUrl/progress';
  static const String analyticsEndpoint = '$apiUrl/analytics';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String syncQueueKey = 'sync_queue';

  // Hive Box Names
  static const String lessonsBox = 'lessons';
  static const String vocabularyBox = 'vocabulary';
  static const String progressBox = 'progress';
  static const String syncQueueBox = 'sync_queue';
  static const String settingsBox = 'settings';

  // SQLite Tables
  static const String mediaTable = 'media_files';
  static const String downloadQueueTable = 'download_queue';

  // Colors
  static const Color primaryColor = Color(0xFFFFC107); // Lemon Yellow
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF303030);
  static const Color cardBackground = Colors.white;

  // Lesson Stage Colors
  static const Color stage1Color = Color(0xFF2196F3); // Intro - Blue
  static const Color stage2Color = Color(0xFF4CAF50); // Vocabulary - Green
  static const Color stage3Color = Color(0xFFFF9800); // Grammar - Orange
  static const Color stage4Color = Color(0xFF9C27B0); // Practice - Purple
  static const Color stage5Color = Color(0xFFE91E63); // Dialogue - Pink
  static const Color stage6Color = Color(0xFFF44336); // Quiz - Red
  static const Color stage7Color = Color(0xFF607D8B); // Summary - Grey

  // Sizes
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeNormal = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Network
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const int imageCacheSize = 50 * 1024 * 1024; // 50 MB
  static const Duration cacheExpiry = Duration(days: 7);

  // Sync
  static const int maxSyncQueueSize = 100;
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration syncRetryDelay = Duration(seconds: 30);

  // Download
  static const int maxConcurrentDownloads = 3;
  static const Duration downloadTimeout = Duration(minutes: 10);

  // Lesson
  static const int maxLessonProgress = 100;
  static const int quizPassScore = 80;

  // SRS (Spaced Repetition)
  static const double initialEaseFactor = 2.5;
  static const int initialInterval = 1;
  static const int minimumInterval = 1;
  static const int maximumInterval = 365;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Error Messages
  static const String networkErrorMessage = '网络连接失败，请检查您的网络设置';
  static const String serverErrorMessage = '服务器错误，请稍后重试';
  static const String authErrorMessage = '认证失败，请重新登录';
  static const String unknownErrorMessage = '未知错误，请稍后重试';

  // Success Messages
  static const String loginSuccessMessage = '登录成功';
  static const String registerSuccessMessage = '注册成功';
  static const String syncSuccessMessage = '同步成功';
  static const String downloadSuccessMessage = '下载成功';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAutoSync = true;
  static const bool enableAnalytics = true;
  static const bool enableDebugMode = false; // Set to false in production
}
