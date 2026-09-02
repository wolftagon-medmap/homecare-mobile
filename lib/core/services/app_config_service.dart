import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';

/// Version thresholds returned by `GET /v1/app-config`.
class AppConfig {
  final String minimumVersion;
  final String latestVersion;
  final String updateUrl;
  final String? forceMessage;
  final String? recommendMessage;

  const AppConfig({
    required this.minimumVersion,
    required this.latestVersion,
    required this.updateUrl,
    this.forceMessage,
    this.recommendMessage,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      minimumVersion: json['minimumVersion'] as String,
      latestVersion: json['latestVersion'] as String,
      updateUrl: json['updateUrl'] as String,
      forceMessage: json['forceMessage'] as String?,
      recommendMessage: json['recommendMessage'] as String?,
    );
  }
}

class AppConfigService {
  final Dio _dio;

  AppConfigService(this._dio);

  /// Fetches the platform-specific version config.
  Future<AppConfig> fetch() async {
    final platform = switch (Platform.operatingSystem) {
      'ios' => 'ios',
      'android' => 'android',
      _ => throw UnsupportedError('Unsupported platform for app config'),
    };

    final response = await _dio.get(
      Const.API_APP_CONFIG,
      queryParameters: {'platform': platform},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AppConfig.fromJson(data);
  }
}
