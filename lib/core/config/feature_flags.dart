import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature_flags_remote_source.dart';

/// One value per data source that can swap between fixtures and the backend.
///
/// This enum is owned by A0. If you need a value that isn't here, ask — do not
/// add it yourself, or two branches will conflict on this file.
enum Feature {
  // A1 — guided booking
  issueCatalogue,
  bookingProfessionals,
  bookingSubmit,
  bookingDraft,
  bookingAddresses,
  guidedBookingFlow,

  // A2 — messaging and counter-propose
  messageThreads,
  messageStream,
  timeProposal,

  // A3 — pricing and estimate
  servicePricing,
  professionalPricing,
  estimateCalculation,
  estimateRevision,

  // A4 — chatbot
  chatbotResponses,

  // A5 — health profile
  healthProfileSections,
  healthProfileFlow,
}

/// Which agent owns a feature. Used to group the debug toggle screen.
enum FeatureOwner {
  guidedBooking('Guided booking'),
  messaging('Messaging'),
  pricing('Pricing'),
  chatbot('Chatbot'),
  healthProfile('Health profile');

  const FeatureOwner(this.label);
  final String label;
}

/// Where a resolved flag value came from. Shown on the debug screen so a wrong
/// value is diagnosable without a debugger.
enum FlagSource { bootstrap, debugOverride, server }

extension FeatureMeta on Feature {
  /// Storage and wire key. Stable — the server contract depends on it.
  String get key => name;

  /// Picks a screen rather than a data source, so it bootstraps ON: a fresh
  /// install with no network must still render the flow.
  bool get isNavigation => switch (this) {
        Feature.guidedBookingFlow || Feature.healthProfileFlow => true,
        _ => false,
      };

  FeatureOwner get owner => switch (this) {
        Feature.issueCatalogue ||
        Feature.bookingProfessionals ||
        Feature.bookingSubmit ||
        Feature.bookingDraft ||
        Feature.bookingAddresses ||
        Feature.guidedBookingFlow =>
          FeatureOwner.guidedBooking,
        Feature.messageThreads ||
        Feature.messageStream ||
        Feature.timeProposal =>
          FeatureOwner.messaging,
        Feature.servicePricing ||
        Feature.professionalPricing ||
        Feature.estimateCalculation ||
        Feature.estimateRevision =>
          FeatureOwner.pricing,
        Feature.chatbotResponses => FeatureOwner.chatbot,
        Feature.healthProfileSections ||
        Feature.healthProfileFlow =>
          FeatureOwner.healthProfile,
      };

  String get label => switch (this) {
        Feature.issueCatalogue => 'Issue catalogue',
        Feature.bookingProfessionals => 'Professional list',
        Feature.bookingSubmit => 'Send booking request',
        Feature.bookingDraft => 'Booking draft state',
        Feature.bookingAddresses => 'Saved visit addresses',
        Feature.guidedBookingFlow => 'Guided booking flow (navigation)',
        Feature.messageThreads => 'Threads and unread counts',
        Feature.messageStream => 'Send and receive messages',
        Feature.timeProposal => 'Time proposal',
        Feature.servicePricing => 'Service floor price',
        Feature.professionalPricing => 'Professional base price',
        Feature.estimateCalculation => 'Estimate calculation',
        Feature.estimateRevision => 'Estimate revision',
        Feature.chatbotResponses => 'Chatbot responses',
        Feature.healthProfileSections => 'Health profile sections',
        Feature.healthProfileFlow => 'Health profile (navigation)',
      };

  /// What the data source does when the flag is off. Shown on the debug screen.
  String get localDescription => switch (this) {
        Feature.chatbotResponses => 'Scripted demo conversation',
        Feature.guidedBookingFlow => 'Legacy per-service pages',
        Feature.healthProfileFlow => 'Existing health profile forms',
        _ => 'Local fixtures',
      };
}

/// Resolves whether a data source reads from the backend or from fixtures.
///
/// Register data sources against it, one flag each (contract C2):
///
/// ```dart
/// sl.registerLazySingleton<IssueDataSource>(
///   () => AppFlags.remote(Feature.issueCatalogue)
///       ? IssueRemoteDataSource(sl())
///       : IssueLocalDataSource(),
/// );
/// ```
///
/// Resolution order, first match wins:
///
/// 1. debug override — the toggle screen, debug builds only
/// 2. server — what `GET /v1/flags` last said, in memory this run or restored
///    from the previous run by [init]
/// 3. bootstrap — [FeatureMeta.isNavigation]. The app carries no flag config of
///    its own; the backend owns the values.
///
/// A flag read at DI time is fixed for the process; a flag read at call time
/// follows the toggle immediately. The debug screen says which is which.
class AppFlags {
  AppFlags._();

  static const String _prefsPrefix = 'feature_flag_override.';
  static const String _serverPrefix = 'flag_server.';

  static SharedPreferences? _prefs;
  static final Map<Feature, bool> _debugOverrides = {};
  static final Map<Feature, bool> _serverFlags = {};

  /// Loads the persisted server answer and any debug overrides, synchronously
  /// enough that a cold start never waits on the network. From `setupLocator()`.
  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    _debugOverrides.clear();
    _serverFlags.clear();
    for (final feature in Feature.values) {
      final value = prefs.getBool('$_serverPrefix${feature.key}');
      if (value != null) _serverFlags[feature] = value;
    }
    if (!kDebugMode) return;
    for (final feature in Feature.values) {
      final value = prefs.getBool('$_prefsPrefix${feature.key}');
      if (value != null) _debugOverrides[feature] = value;
    }
  }

  /// True when this data source should hit the backend.
  static bool remote(Feature feature) => switch (sourceOf(feature)) {
        FlagSource.debugOverride => _debugOverrides[feature]!,
        FlagSource.server => _serverFlags[feature]!,
        FlagSource.bootstrap => bootstrapOf(feature),
      };

  static FlagSource sourceOf(Feature feature) {
    // A debug override outranks the server: a toggle a live server silently
    // undoes is not a toggle.
    if (kDebugMode && _debugOverrides.containsKey(feature)) {
      return FlagSource.debugOverride;
    }
    if (_serverFlags.containsKey(feature)) return FlagSource.server;
    return FlagSource.bootstrap;
  }

  /// The only flag value the app decides for itself, used until the server
  /// answers: a navigation flag is on, everything else falls back to fixtures.
  static bool bootstrapOf(Feature feature) => feature.isNavigation;

  static bool? overrideOf(Feature feature) =>
      kDebugMode ? _debugOverrides[feature] : null;

  /// Sets a debug override, or clears it with null. No-op outside debug builds.
  static Future<void> setOverride(Feature feature, bool? remote) async {
    if (!kDebugMode) return;
    final key = '$_prefsPrefix${feature.key}';
    if (remote == null) {
      _debugOverrides.remove(feature);
      await _prefs?.remove(key);
    } else {
      _debugOverrides[feature] = remote;
      await _prefs?.setBool(key, remote);
    }
  }

  static Future<void> clearOverrides() async {
    if (!kDebugMode) return;
    _debugOverrides.clear();
    for (final feature in Feature.values) {
      await _prefs?.remove('$_prefsPrefix${feature.key}');
    }
  }

  /// Fetches `GET /v1/flags`. Called unawaited after [init], so a cold start
  /// never waits on it. Fails open on anything, keeping the persisted answer.
  static Future<void> refreshFromServer(FeatureFlagsRemoteSource source) async {
    try {
      await applyServerFlags(await source.fetch());
    } catch (e, st) {
      debugPrint('Feature flag refresh failed, keeping local values: $e\n$st');
    }
  }

  /// Stores what the server said and persists it, so the next cold start has an
  /// answer before the network does.
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
