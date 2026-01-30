import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_korean/core/config/environment_config.dart';

void main() {
  group('EnvironmentConfig', () {
    group('default values', () {
      test('baseUrl should return non-empty string', () {
        // Act
        final baseUrl = EnvironmentConfig.baseUrl;

        // Assert
        expect(baseUrl, isNotNull);
        expect(baseUrl, isNotEmpty);
      });

      test('adminUrl should return non-empty string', () {
        // Act
        final adminUrl = EnvironmentConfig.adminUrl;

        // Assert
        expect(adminUrl, isNotNull);
        expect(adminUrl, isNotEmpty);
      });

      test('contentUrl should return non-empty string', () {
        // Act
        final contentUrl = EnvironmentConfig.contentUrl;

        // Assert
        expect(contentUrl, isNotNull);
        expect(contentUrl, isNotEmpty);
      });

      test('progressUrl should return non-empty string', () {
        // Act
        final progressUrl = EnvironmentConfig.progressUrl;

        // Assert
        expect(progressUrl, isNotNull);
        expect(progressUrl, isNotEmpty);
      });

      test('mediaUrl should return non-empty string', () {
        // Act
        final mediaUrl = EnvironmentConfig.mediaUrl;

        // Assert
        expect(mediaUrl, isNotNull);
        expect(mediaUrl, isNotEmpty);
      });
    });

    group('environment mode', () {
      test('envMode should return valid mode string', () {
        // Act
        final mode = EnvironmentConfig.envMode;

        // Assert
        expect(mode, isNotNull);
        // Default is 'production' when not initialized
        expect(mode, isNotEmpty);
      });

      test('isDevelopment should return boolean', () {
        // Act
        final isDev = EnvironmentConfig.isDevelopment;

        // Assert
        expect(isDev, isA<bool>());
      });

      test('isProduction should return boolean', () {
        // Act
        final isProd = EnvironmentConfig.isProduction;

        // Assert
        expect(isProd, isA<bool>());
      });

      test('isDevelopment and isProduction should be mutually exclusive', () {
        // Act
        final isDev = EnvironmentConfig.isDevelopment;
        final isProd = EnvironmentConfig.isProduction;

        // Assert
        // At least one should be false (they can't both be true)
        // But both can be false if envMode is something else
        expect(isDev && isProd, false);
      });
    });

    group('debug settings', () {
      test('enableDebugMode should return boolean', () {
        // Act
        final debugMode = EnvironmentConfig.enableDebugMode;

        // Assert
        expect(debugMode, isA<bool>());
      });
    });

    group('allConfig', () {
      test('should return map with all configuration keys', () {
        // Act
        final config = EnvironmentConfig.allConfig;

        // Assert
        expect(config, isA<Map<String, String>>());
        expect(config.containsKey('baseUrl'), true);
        expect(config.containsKey('adminUrl'), true);
        expect(config.containsKey('contentUrl'), true);
        expect(config.containsKey('progressUrl'), true);
        expect(config.containsKey('mediaUrl'), true);
        expect(config.containsKey('envMode'), true);
        expect(config.containsKey('enableDebugMode'), true);
      });
    });
  });
}
