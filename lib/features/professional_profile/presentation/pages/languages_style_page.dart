import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/languages_care_style_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/select_then_rate.dart';

/// Chapter 4: how the professional communicates. Language is the single most
/// practical filter in a multilingual market — a patient with a Hokkien-speaking
/// parent needs it before anything clinical.
class LanguagesStylePage extends StatelessWidget {
  const LanguagesStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguagesCareStyleCubit, LanguagesCareStyleState>(
      listener: _announce,
      builder: (context, state) {
        final ready = state is LanguagesCareStyleReady ? state : null;

        return PopScope(
          canPop: !(ready?.isDirty ?? false),
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmDiscard(context);
          },
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Languages & care style',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                bottom: const TabBar(
                  labelColor: Const.tosca,
                  indicatorColor: Const.aqua,
                  tabs: [
                    Tab(text: 'Languages'),
                    Tab(text: 'Care style'),
                  ],
                ),
              ),
              body: switch (state) {
                LanguagesCareStyleLoading() =>
                  const Center(child: CircularProgressIndicator()),
                LanguagesCareStyleUnavailable(:final message) =>
                  _Unavailable(message: message),
                _ => TabBarView(
                    children: [
                      _LanguagesTab(languages: ready?.languages ?? const []),
                      _CareStyleTab(state: ready),
                    ],
                  ),
              },
              bottomNavigationBar:
                  ready == null ? null : _SaveBar(state: ready),
            ),
          ),
        );
      },
    );
  }

  /// Each endpoint announces itself, so a half that saved is folded into the
  /// profile even when the other half failed.
  void _announce(BuildContext context, LanguagesCareStyleState state) {
    final profileCubit = context.read<ProfessionalProfileCubit>();

    switch (state) {
      case LanguagesSaved(:final languages):
        profileCubit.applyLanguages(languages);
      case CareStyleSaved(:final traits):
        profileCubit.applyCareStyle(traits);
      case LanguagesCareStyleReady(:final error?):
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      default:
        break;
    }
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content:
            const Text('Your languages and care style have not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (discard == true && context.mounted) Navigator.pop(context);
  }
}

class _LanguagesTab extends StatelessWidget {
  const _LanguagesTab({required this.languages});

  final List<LeveledEntry> languages;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add every language you can hold a care conversation in.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          SelectThenRate(
            entries: languages,
            scale: LevelScale.language,
            onChanged: context.read<LanguagesCareStyleCubit>().updateLanguages,
            emptyHint: 'No languages added yet.',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CareStyleTab extends StatelessWidget {
  const _CareStyleTab({required this.state});

  final LanguagesCareStyleReady? state;

  @override
  Widget build(BuildContext context) {
    final traits = state?.traits ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick the qualities that describe how you work. Patients see these '
            'on your profile.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          TagMultiSelect(
            options: [
              for (final t in traits) TagOption(code: t.code, label: t.label),
            ],
            selectedCodes: state?.selectedTraitCodes ?? const {},
            onChanged: context.read<LanguagesCareStyleCubit>().updateTraits,
          ),
          const SizedBox(height: 24),
          const _Note(
            'Self-declared for now. Later these can be corroborated by '
            'patient feedback after a visit.',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _reload(context),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  void _reload(BuildContext context) {
    final state = context.read<ProfessionalProfileCubit>().state;
    final profile = state is ProfessionalProfileLoaded ? state.profile : null;

    context.read<LanguagesCareStyleCubit>().load(
          claimedLanguages: profile?.languages ?? const [],
          claimedTraits: profile?.careStyle ?? const [],
        );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final LanguagesCareStyleReady state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: !state.isDirty || state.isSaving
            ? null
            : () => context.read<LanguagesCareStyleCubit>().save(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text('Save'),
      ),
    );
  }
}
