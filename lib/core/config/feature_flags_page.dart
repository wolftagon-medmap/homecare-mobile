import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

import 'feature_flags.dart';

/// Debug-only screen for flipping data sources between fixtures and the
/// backend. Reachable from the settings card in debug builds, or directly at
/// [AppRoutes.debugFeatureFlags].
///
/// Overrides persist in SharedPreferences and survive a restart. They do
/// nothing in a release build.
class FeatureFlagsPage extends StatefulWidget {
  const FeatureFlagsPage({super.key});

  @override
  State<FeatureFlagsPage> createState() => _FeatureFlagsPageState();
}

class _FeatureFlagsPageState extends State<FeatureFlagsPage> {
  @override
  Widget build(BuildContext context) {
    final byOwner = <FeatureOwner, List<Feature>>{};
    for (final feature in Feature.values) {
      byOwner.putIfAbsent(feature.owner, () => []).add(feature);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature flags'),
        actions: [
          TextButton(
            onPressed: _resetAll,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const _Explainer(),
          for (final entry in byOwner.entries) ...[
            _SectionHeader(entry.key.label),
            for (final feature in entry.value) _FlagTile(feature, _onChanged),
          ],
        ],
      ),
    );
  }

  void _onChanged(Feature feature, bool? remote) async {
    await AppFlags.setOverride(feature, remote);
    if (mounted) setState(() {});
  }

  void _resetAll() async {
    await AppFlags.clearOverrides();
    if (mounted) setState(() {});
  }
}

class _Explainer extends StatelessWidget {
  const _Explainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Const.surfaceMuted,
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Off = fixtures, on = backend. Everything ships off.\n\n'
        'Data sources resolved at startup only pick this up after a restart. '
        'Anything read at call time changes straight away.',
        style: TextStyle(fontSize: 13, color: Const.contentTextColor),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Const.contentTextColor,
        ),
      ),
    );
  }
}

class _FlagTile extends StatelessWidget {
  const _FlagTile(this.feature, this.onChanged);

  final Feature feature;
  final void Function(Feature, bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    final isRemote = AppFlags.remote(feature);
    final source = AppFlags.sourceOf(feature);
    final overridden = AppFlags.overrideOf(feature) != null;

    return SwitchListTile(
      value: isRemote,
      onChanged: (value) => onChanged(
        feature,
        value == AppFlags.defaultOf(feature) ? null : value,
      ),
      activeThumbColor: Const.aqua,
      title: Text(
        feature.label,
        style: const TextStyle(fontSize: 15, color: Colors.black),
      ),
      subtitle: Text(
        '${isRemote ? 'Backend' : feature.localDescription}'
        ' · ${_sourceLabel(source)}',
        style: const TextStyle(fontSize: 12, color: Const.contentTextColor),
      ),
      secondary: overridden
          ? const Icon(Icons.edit_outlined, size: 18, color: Const.aqua)
          : const SizedBox(width: 18),
    );
  }

  String _sourceLabel(FlagSource source) => switch (source) {
        FlagSource.compileTimeDefault => 'default',
        FlagSource.debugOverride => 'overridden here',
        FlagSource.server => 'set by server',
      };
}
