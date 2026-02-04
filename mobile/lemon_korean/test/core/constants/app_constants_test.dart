import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_korean/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('App Info', () {
      test('appName should be Lemon Korean', () {
        expect(AppConstants.appName, 'Lemon Korean');
      });

      test('version should follow semver format', () {
        final version = AppConstants.version;
        final semverRegex = RegExp(r'^\d+\.\d+\.\d+$');
        expect(semverRegex.hasMatch(version), true);
      });
    });

    group('Storage Keys', () {
      test('tokenKey should be non-empty', () {
        expect(AppConstants.tokenKey, isNotEmpty);
      });

      test('refreshTokenKey should be non-empty', () {
        expect(AppConstants.refreshTokenKey, isNotEmpty);
      });

      test('userIdKey should be non-empty', () {
        expect(AppConstants.userIdKey, isNotEmpty);
      });

      test('syncQueueKey should be non-empty', () {
        expect(AppConstants.syncQueueKey, isNotEmpty);
      });
    });

    group('Hive Box Names', () {
      test('lessonsBox should be non-empty', () {
        expect(AppConstants.lessonsBox, isNotEmpty);
      });

      test('vocabularyBox should be non-empty', () {
        expect(AppConstants.vocabularyBox, isNotEmpty);
      });

      test('progressBox should be non-empty', () {
        expect(AppConstants.progressBox, isNotEmpty);
      });

      test('syncQueueBox should be non-empty', () {
        expect(AppConstants.syncQueueBox, isNotEmpty);
      });

      test('settingsBox should be non-empty', () {
        expect(AppConstants.settingsBox, isNotEmpty);
      });
    });

    group('Network Configuration', () {
      test('connectTimeout should be reasonable', () {
        expect(AppConstants.connectTimeout.inSeconds, greaterThan(0));
        expect(AppConstants.connectTimeout.inSeconds, lessThanOrEqualTo(60));
      });

      test('receiveTimeout should be reasonable', () {
        expect(AppConstants.receiveTimeout.inSeconds, greaterThan(0));
        expect(AppConstants.receiveTimeout.inSeconds, lessThanOrEqualTo(60));
      });

      test('sendTimeout should be reasonable', () {
        expect(AppConstants.sendTimeout.inSeconds, greaterThan(0));
        expect(AppConstants.sendTimeout.inSeconds, lessThanOrEqualTo(60));
      });
    });

    group('Cache Configuration', () {
      test('imageCacheSize should be positive', () {
        expect(AppConstants.imageCacheSize, greaterThan(0));
      });

      test('cacheExpiry should be positive duration', () {
        expect(AppConstants.cacheExpiry.inDays, greaterThan(0));
      });
    });

    group('Sync Configuration', () {
      test('maxSyncQueueSize should be positive', () {
        expect(AppConstants.maxSyncQueueSize, greaterThan(0));
      });

      test('syncInterval should be positive duration', () {
        expect(AppConstants.syncInterval.inMinutes, greaterThan(0));
      });

      test('syncRetryDelay should be positive duration', () {
        expect(AppConstants.syncRetryDelay.inSeconds, greaterThan(0));
      });
    });

    group('Lesson Configuration', () {
      test('quizPassScore should be between 0 and 100', () {
        expect(AppConstants.quizPassScore, greaterThanOrEqualTo(0));
        expect(AppConstants.quizPassScore, lessThanOrEqualTo(100));
      });

      test('maxLessonProgress should be 100', () {
        expect(AppConstants.maxLessonProgress, 100);
      });
    });

    group('SRS Configuration', () {
      test('initialEaseFactor should be positive', () {
        expect(AppConstants.initialEaseFactor, greaterThan(0));
      });

      test('initialInterval should be positive', () {
        expect(AppConstants.initialInterval, greaterThan(0));
      });

      test('minimumInterval should be positive', () {
        expect(AppConstants.minimumInterval, greaterThan(0));
      });

      test('maximumInterval should be greater than minimumInterval', () {
        expect(AppConstants.maximumInterval, greaterThan(AppConstants.minimumInterval));
      });
    });

    group('Validation', () {
      test('minPasswordLength should be reasonable', () {
        expect(AppConstants.minPasswordLength, greaterThanOrEqualTo(6));
      });

      test('maxPasswordLength should be greater than minPasswordLength', () {
        expect(AppConstants.maxPasswordLength, greaterThan(AppConstants.minPasswordLength));
      });

      test('minUsernameLength should be positive', () {
        expect(AppConstants.minUsernameLength, greaterThan(0));
      });

      test('maxUsernameLength should be greater than minUsernameLength', () {
        expect(AppConstants.maxUsernameLength, greaterThan(AppConstants.minUsernameLength));
      });
    });

    group('Pagination', () {
      test('defaultPageSize should be positive', () {
        expect(AppConstants.defaultPageSize, greaterThan(0));
      });

      test('maxPageSize should be greater than defaultPageSize', () {
        expect(AppConstants.maxPageSize, greaterThanOrEqualTo(AppConstants.defaultPageSize));
      });
    });

    group('Error Messages', () {
      test('networkErrorMessage should be non-empty', () {
        expect(AppConstants.networkErrorMessage, isNotEmpty);
      });

      test('serverErrorMessage should be non-empty', () {
        expect(AppConstants.serverErrorMessage, isNotEmpty);
      });

      test('authErrorMessage should be non-empty', () {
        expect(AppConstants.authErrorMessage, isNotEmpty);
      });

      test('unknownErrorMessage should be non-empty', () {
        expect(AppConstants.unknownErrorMessage, isNotEmpty);
      });
    });

    group('Feature Flags', () {
      test('enableOfflineMode should be boolean', () {
        expect(AppConstants.enableOfflineMode, isA<bool>());
      });

      test('enableAutoSync should be boolean', () {
        expect(AppConstants.enableAutoSync, isA<bool>());
      });

      test('enableAnalytics should be boolean', () {
        expect(AppConstants.enableAnalytics, isA<bool>());
      });

      test('enableDebugMode should be boolean', () {
        expect(AppConstants.enableDebugMode, isA<bool>());
      });
    });
  });
}
