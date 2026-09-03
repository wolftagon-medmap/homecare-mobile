import 'package:dio/dio.dart';
import 'package:m2health/const.dart';

import 'feature_flags.dart';

/// Client seam for `GET /flags`. The endpoint does not exist yet.
///
/// The path lives here rather than in `Const` because `const.dart` carries a
/// local BASE_URL override and is off-limits to this work. Move it there when
/// the backend half lands.
class FeatureFlagsRemoteSource {
  FeatureFlagsRemoteSource(this._dio);

  static const String path = '${Const.URL_API}/flags';

  final Dio _dio;

  /// Returns only the keys the server actually sent, so an unknown or omitted
  /// feature falls through to the compile-time default rather than to false.
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
