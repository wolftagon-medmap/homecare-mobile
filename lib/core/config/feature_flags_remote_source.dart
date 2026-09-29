import 'package:dio/dio.dart';
import 'package:m2health/const.dart';

import 'feature_flags.dart';

class FeatureFlagsRemoteSource {
  FeatureFlagsRemoteSource(this._dio);

  static const String path = '${Const.URL_API}/flags';

  final Dio _dio;

  /// Returns only the keys the server sent, so an omitted feature keeps its
  /// default rather than turning off.
  Future<Map<Feature, bool>> fetch() async {
    final response = await _dio.get(path);
    final data = response.data['data'];
    if (data is! Map) return const {};

    final byKey = {for (final f in Feature.values) f.key: f};
    final flags = <Feature, bool>{};
    data.forEach((key, value) {
      final feature = byKey[key];
      if (feature != null && value is bool) flags[feature] = value;
    });
    return flags;
  }
}
