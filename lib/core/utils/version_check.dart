import 'package:m2health/core/services/app_config_service.dart';

enum UpdateDecision { none, recommend, force }

/// Compares two dotted version strings (e.g. "1.2.0").
/// Returns negative if [a] < [b], zero if equal, positive if [a] > [b].
/// The build-number suffix after "+" is ignored.
int compareVersions(String a, String b) {
  List<int> parse(String v) => v
      .split('+')
      .first
      .split('.')
      .map((p) => int.tryParse(p.trim()) ?? 0)
      .toList();

  final pa = parse(a);
  final pb = parse(b);
  final len = pa.length > pb.length ? pa.length : pb.length;

  for (var i = 0; i < len; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va - vb;
  }
  return 0;
}

/// Decides whether to show no popup, a recommended update, or a forced update.
UpdateDecision resolveUpdate(String currentVersion, AppConfig config) {
  if (compareVersions(currentVersion, config.minimumVersion) < 0) {
    return UpdateDecision.force;
  }
  if (compareVersions(currentVersion, config.latestVersion) < 0) {
    return UpdateDecision.recommend;
  }
  return UpdateDecision.none;
}
