import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/guidance_sheet.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/condition_experience_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/select_then_rate.dart';

/// Who the professional has cared for, as opposed to what they can do.
///
/// This survived the merge into services because it is orthogonal to them: two
/// nurses can both offer wound care and only one of them have spent years with
/// dementia patients.
class ConditionExperiencePage extends StatelessWidget {
  const ConditionExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConditionExperienceCubit, ConditionExperienceState>(
      listener: (context, state) {
        if (state is ConditionExperienceSaved) {
          context
              .read<ProfessionalProfileCubit>()
              .applyConditionExperience(state.entries);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Condition experience saved')),
          );
        }
        if (state is ConditionExperienceReady && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        final ready = state is ConditionExperienceReady ? state : null;

        return PopScope(
          canPop: !(ready?.isDirty ?? false),
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmDiscard(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Condition experience',
                style: ProText.pageTitle,
              ),
              actions: const [
                GuidanceAction(
                  title: 'Condition experience',
                  points: [
                    'Add the conditions you have cared for, then rate how much experience you have with each.',
                    'Families search on this more than anything else when choosing someone.',
                    'Anything you do not add stays off your profile.',
                  ],
                ),
              ],
            ),
            body: switch (state) {
              ConditionExperienceLoading() =>
                const Center(child: CircularProgressIndicator()),
              ConditionExperienceUnavailable(:final message) =>
                _Unavailable(message: message),
              _ => _Editor(entries: ready?.entries ?? const []),
            },
            bottomNavigationBar: ready == null ? null : _SaveBar(state: ready),
          ),
        );
      },
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your condition experience has not been saved.'),
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

class _Editor extends StatelessWidget {
  const _Editor({required this.entries});

  final List<LeveledEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectThenRate(
            entries: entries,
            scale: LevelScale.experience,
            onChanged: context.read<ConditionExperienceCubit>().update,
            emptyHint: 'No conditions added yet — tap one above to start.',
          ),
          const SizedBox(height: 40),
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
              style: ProText.caption,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<ConditionExperienceCubit>().load(
                    _claimedFrom(context),
                  ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  List<LeveledEntry> _claimedFrom(BuildContext context) {
    final state = context.read<ProfessionalProfileCubit>().state;
    return state is ProfessionalProfileLoaded
        ? state.profile.conditionExperience
        : const [];
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final ConditionExperienceReady state;

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
            : () => context.read<ConditionExperienceCubit>().save(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Save'),
      ),
    );
  }
}
