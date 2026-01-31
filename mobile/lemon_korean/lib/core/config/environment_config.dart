import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration manager
/// Loads and provides access to environment-specific settings
class EnvironmentConfig {
  static bool _initialized = false;
  static String _currentEnvFile = '';  // Track which file was loaded

  /// Initialize environment configuration
  /// Should be called before runApp()
  ///
  /// [envFile] - Explicit file name to load (e.g., '.env.development')
  /// [mode] - Mode override from server ('development' or 'production')
  ///          Takes precedence over build mode
  static Future<void> init({String? envFile, String? mode}) async {
    if (_initialized) return;

    String fileName;
    if (envFile != null) {
      // Explicit file name provided
      fileName = envFile;
    } else if (mode != null) {
      // Mode override from server - converts mode to file name
      fileName = mode == 'development' ? '.env.development' : '.env.production';
      print('[EnvironmentConfig] Using mode override from server: $mode');
    } else {
      // Default: use build mode
      fileName = _getEnvFileName();
    }

    try {
      await dotenv.load(fileName: fileName);
      _initialized = true;
      _currentEnvFile = fileName;
      print('[EnvironmentConfig] Loaded environment from: $fileName');
      print('[EnvironmentConfig] ENV_MODE: ${envMode}');
    } catch (e) {
      print('[EnvironmentConfig] Failed to load $fileName: $e');
      print('[EnvironmentConfig] Using default values');
      _initialized = true;
      _currentEnvFile = 'none (defaults)';
    }
  }

  /// Get environment file name based on build mode
  static String _getEnvFileName() {
    // Check if running in debug mode
    const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
    return isDebug ? '.env.development' : '.env.production';
  }

  /// Check if environment is initialized
  static bool get isInitialized => _initialized;

  /// Get the name of the loaded environment file
  static String get loadedEnvFile => _currentEnvFile;

  /// Safe getter for dotenv values - returns null if not initialized
  static String? _getEnvValue(String key) {
    try {
      return dotenv.env[key];
    } catch (e) {
      // dotenv not initialized - return null to use default
      return null;
    }
  }

  // ================================================================
  // URL Configuration
  // ================================================================

  /// Base URL for API gateway
  static String get baseUrl =>
      _getEnvValue('BASE_URL') ?? _defaultBaseUrl;

  /// Admin service URL
  static String get adminUrl =>
      _getEnvValue('ADMIN_URL') ?? '$_defaultBaseUrl:3006';

  /// Content service URL
  static String get contentUrl =>
      _getEnvValue('CONTENT_URL') ?? _defaultBaseUrl;

  /// Progress service URL
  static String get progressUrl =>
      _getEnvValue('PROGRESS_URL') ?? _defaultBaseUrl;

  /// Media service URL
  static String get mediaUrl =>
      _getEnvValue('MEDIA_URL') ?? _defaultBaseUrl;

  // ================================================================
  // Environment Mode
  // ================================================================

  /// Current environment mode (development / production)
  static String get envMode =>
      _getEnvValue('ENV_MODE') ?? 'production';

  /// Check if running in development mode
  static bool get isDevelopment => envMode == 'development';

  /// Check if running in production mode
  static bool get isProduction => envMode == 'production';

  // ================================================================
  // Debug Settings
  // ================================================================

  /// Enable debug mode for logging
  static bool get enableDebugMode =>
      _getEnvValue('ENABLE_DEBUG_MODE')?.toLowerCase() == 'true';

  // ================================================================
  // Default Values (Fallback)
  // ================================================================

  /// Default base URL used when environment variable is not set
  /// This is the fallback URL - actual URL should come from .env files
  static const String _defaultBaseUrl = 'http://localhost';

  /// Get all configuration as a map (for debugging)
  static Map<String, String> get allConfig => {
    'baseUrl': baseUrl,
    'adminUrl': adminUrl,
    'contentUrl': contentUrl,
    'progressUrl': progressUrl,
    'mediaUrl': mediaUrl,
    'envMode': envMode,
    'enableDebugMode': enableDebugMode.toString(),
  };

  /// Print current configuration (for debugging)
  static void printConfig() {
    print('[EnvironmentConfig] Current configuration:');
    allConfig.forEach((key, value) {
      print('  $key: $value');
    });
  }
}
