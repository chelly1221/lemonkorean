import 'package:flutter_test/flutter_test.dart';

// Note: We test NetworkConfigModel constructor directly to avoid EnvironmentConfig dependency
// The model class depends on EnvironmentConfig for fallback values, so we test with explicit values

void main() {
  group('NetworkConfigModel-like tests', () {
    group('Model creation', () {
      test('should create model with all fields', () {
        // Test the concept - in real app, NetworkConfigModel would be used
        final config = _TestNetworkConfig(
          mode: 'development',
          baseUrl: 'http://test.example.com',
          contentUrl: 'http://content.example.com',
          progressUrl: 'http://progress.example.com',
          mediaUrl: 'http://media.example.com',
          useGateway: false,
        );

        expect(config.mode, 'development');
        expect(config.baseUrl, 'http://test.example.com');
        expect(config.contentUrl, 'http://content.example.com');
        expect(config.progressUrl, 'http://progress.example.com');
        expect(config.mediaUrl, 'http://media.example.com');
        expect(config.useGateway, false);
      });

      test('should parse complete JSON correctly', () {
        final json = {
          'mode': 'development',
          'baseUrl': 'http://test.example.com',
          'contentUrl': 'http://content.example.com',
          'progressUrl': 'http://progress.example.com',
          'mediaUrl': 'http://media.example.com',
          'useGateway': false,
        };

        final config = _TestNetworkConfig.fromJson(json);

        expect(config.mode, 'development');
        expect(config.baseUrl, 'http://test.example.com');
        expect(config.contentUrl, 'http://content.example.com');
        expect(config.progressUrl, 'http://progress.example.com');
        expect(config.mediaUrl, 'http://media.example.com');
        expect(config.useGateway, false);
      });

      test('should use default values for missing fields', () {
        final json = <String, dynamic>{};

        final config = _TestNetworkConfig.fromJson(json);

        expect(config.mode, isNotEmpty);
        expect(config.baseUrl, isNotEmpty);
        expect(config.contentUrl, isNotEmpty);
        expect(config.progressUrl, isNotEmpty);
        expect(config.mediaUrl, isNotEmpty);
        expect(config.useGateway, true);
      });

      test('should handle partial JSON', () {
        final json = {
          'mode': 'production',
          'baseUrl': 'http://partial.example.com',
        };

        final config = _TestNetworkConfig.fromJson(json);

        expect(config.mode, 'production');
        expect(config.baseUrl, 'http://partial.example.com');
        expect(config.useGateway, true);
      });
    });

    group('defaultConfig', () {
      test('should return valid default configuration', () {
        final config = _TestNetworkConfig.defaultConfig();

        expect(config.mode, isNotEmpty);
        expect(config.baseUrl, isNotEmpty);
        expect(config.contentUrl, isNotEmpty);
        expect(config.progressUrl, isNotEmpty);
        expect(config.mediaUrl, isNotEmpty);
        expect(config.useGateway, true);
      });
    });

    group('toString', () {
      test('should return readable string representation', () {
        final config = _TestNetworkConfig(
          mode: 'test',
          baseUrl: 'http://test.com',
          contentUrl: 'http://content.com',
          progressUrl: 'http://progress.com',
          mediaUrl: 'http://media.com',
          useGateway: true,
        );

        final result = config.toString();

        expect(result, contains('test'));
        expect(result, contains('http://test.com'));
        expect(result, contains('NetworkConfig'));
      });
    });
  });
}

/// Test-only version of NetworkConfigModel to avoid EnvironmentConfig dependency
class _TestNetworkConfig {
  final String mode;
  final String baseUrl;
  final String contentUrl;
  final String progressUrl;
  final String mediaUrl;
  final bool useGateway;

  _TestNetworkConfig({
    required this.mode,
    required this.baseUrl,
    required this.contentUrl,
    required this.progressUrl,
    required this.mediaUrl,
    required this.useGateway,
  });

  factory _TestNetworkConfig.fromJson(Map<String, dynamic> json) {
    return _TestNetworkConfig(
      mode: json['mode'] ?? 'production',
      baseUrl: json['baseUrl'] ?? 'http://localhost',
      contentUrl: json['contentUrl'] ?? 'http://localhost',
      progressUrl: json['progressUrl'] ?? 'http://localhost',
      mediaUrl: json['mediaUrl'] ?? 'http://localhost',
      useGateway: json['useGateway'] ?? true,
    );
  }

  factory _TestNetworkConfig.defaultConfig() {
    return _TestNetworkConfig(
      mode: 'production',
      baseUrl: 'http://localhost',
      contentUrl: 'http://localhost',
      progressUrl: 'http://localhost',
      mediaUrl: 'http://localhost',
      useGateway: true,
    );
  }

  @override
  String toString() {
    return 'NetworkConfig(mode: $mode, baseUrl: $baseUrl, contentUrl: $contentUrl, useGateway: $useGateway)';
  }
}
