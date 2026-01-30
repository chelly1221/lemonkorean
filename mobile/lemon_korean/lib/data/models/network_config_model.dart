import '../../core/config/environment_config.dart';

class NetworkConfigModel {
  final String mode;
  final String baseUrl;
  final String contentUrl;
  final String progressUrl;
  final String mediaUrl;
  final bool useGateway;

  NetworkConfigModel({
    required this.mode,
    required this.baseUrl,
    required this.contentUrl,
    required this.progressUrl,
    required this.mediaUrl,
    required this.useGateway,
  });

  factory NetworkConfigModel.fromJson(Map<String, dynamic> json) {
    // Use EnvironmentConfig as fallback instead of hardcoded URLs
    return NetworkConfigModel(
      mode: json['mode'] ?? EnvironmentConfig.envMode,
      baseUrl: json['baseUrl'] ?? EnvironmentConfig.baseUrl,
      contentUrl: json['contentUrl'] ?? EnvironmentConfig.contentUrl,
      progressUrl: json['progressUrl'] ?? EnvironmentConfig.progressUrl,
      mediaUrl: json['mediaUrl'] ?? EnvironmentConfig.mediaUrl,
      useGateway: json['useGateway'] ?? true,
    );
  }

  // Fallback to environment config if API fails
  factory NetworkConfigModel.defaultConfig() {
    return NetworkConfigModel(
      mode: EnvironmentConfig.envMode,
      baseUrl: EnvironmentConfig.baseUrl,
      contentUrl: EnvironmentConfig.contentUrl,
      progressUrl: EnvironmentConfig.progressUrl,
      mediaUrl: EnvironmentConfig.mediaUrl,
      useGateway: true,
    );
  }

  @override
  String toString() {
    return 'NetworkConfig(mode: $mode, baseUrl: $baseUrl, contentUrl: $contentUrl, useGateway: $useGateway)';
  }
}
