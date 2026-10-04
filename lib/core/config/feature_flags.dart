import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature_flags_remote_source.dart';

/// Screen switches the backend controls through `GET /v1/flags`.
enum Feature {
  /// Off sends the home grid back to the legacy per-service booking pages.
  guidedBookingFlow,
}

extension FeatureMeta on Feature {
  /// Storage and wire key. The server contract depends on it.
  String get key => name;
}

/// Resolves a [Feature] from the last server answer, persisted across runs.
/// Until the server has answered once, every flag is on, so a fresh install
/// with no network still shows the current screens.
class AppFlags {
  AppFlags._();

  static const String _serverPrefix = 'flag_server.';

  static SharedPreferences? _prefs;
  static final Map<Feature, bool> _serverFlags = {};

  /// Restores the previous run's server answer. From `setupLocator()`.
  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    _serverFlags.clear();
    for (final feature in Feature.values) {
      final value = prefs.getBool('$_serverPrefix${feature.key}');
      if (value != null) _serverFlags[feature] = value;
    }
  }

  static bool isOn(Feature feature) => _serverFlags[feature] ?? true;

  /// Called unawaited after [init], so a cold start never waits on it. Fails
  /// open, keeping the persisted answer.
  static Future<void> refreshFromServer(FeatureFlagsRemoteSource source) async {
    try {
      await applyServerFlags(await source.fetch());
    } catch (e, st) {
      debugPrint('Feature flag refresh failed, keeping local values: $e\n$st');
    }
  }

  @visibleForTesting
  static Future<void> applyServerFlags(Map<Feature, bool> flags) async {
    _serverFlags
      ..clear()
      ..addAll(flags);
    for (final feature in Feature.values) {
      final key = '$_serverPrefix${feature.key}';
      final value = flags[feature];
      if (value == null) {
        await _prefs?.remove(key);
      } else {
        await _prefs?.setBool(key, value);
      }
    }
  }

  @visibleForTesting
  static void clearServerFlags() => _serverFlags.clear();
}
