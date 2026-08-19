import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/work_preferences_cubit.dart';

/// Chapter 6: coverage and preferences.
///
/// Everything here is captured and displayed but does not yet affect matching —
/// that was deliberately deferred. Stated on-screen so nobody demoing this
/// promises the client filtering that is not wired up.
class WorkPreferencesPage extends StatelessWidget {
  const WorkPreferencesPage({super.key});

  static const _genderLabels = {
    ClientGenderPreference.any: 'No preference',
    ClientGenderPreference.female: 'Female clients only',
    ClientGenderPreference.male: 'Male clients only',
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkPreferencesCubit, WorkPreferencesState>(
      listener: (context, state) {
        if (state.saved != null) {
          context
              .read<ProfessionalProfileCubit>()
              .applyWorkPreferences(state.saved!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Work preferences saved')),
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        final p = state.preferences;
        final cubit = context.read<WorkPreferencesCubit>();

        return PopScope(
          canPop: !state.isDirty,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmDiscard(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Work preferences',
                style: ProText.pageTitle,
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _SectionTitle('Capacity'),
                _TargetHours(
                  hours: p.targetWeeklyHours,
                  onChanged: (value) => cubit.update(
                    p.copyWith(
                      targetWeeklyHours: value,
                      clearTargetWeeklyHours: value == null,
                    ),
                  ),
                ),
                _Toggle(
                  label: 'Night & overnight shifts',
                  value: p.nightShift,
                  onChanged: (v) => cubit.update(p.copyWith(nightShift: v)),
                ),
                _Toggle(
                  label: 'Weekends & public holidays',
                  value: p.weekendPublicHoliday,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(weekendPublicHoliday: v)),
                ),
                const SizedBox(height: 16),
                const _SectionTitle('Types of work'),
                _Toggle(
                  label: 'Long-term clients',
                  value: p.longTermClient,
                  onChanged: (v) => cubit.update(p.copyWith(longTermClient: v)),
                ),
                _Toggle(
                  label: 'Hospital escort',
                  value: p.hospitalEscort,
                  onChanged: (v) => cubit.update(p.copyWith(hospitalEscort: v)),
                ),
                _Toggle(
                  label: 'Emergency replacement',
                  value: p.emergencyReplacement,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(emergencyReplacement: v)),
                ),
                const SizedBox(height: 16),
                const _SectionTitle('Client & household'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Client gender', style: ProText.body),
                      ),
                      DropdownButton<String>(
                        value: p.clientGenderPreference,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final entry in _genderLabels.entries)
                            DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value, style: ProText.caption),
                            ),
                        ],
                        onChanged: (v) => v == null
                            ? null
                            : cubit
                                .update(p.copyWith(clientGenderPreference: v)),
                      ),
                    ],
                  ),
                ),
                _Toggle(
                  label: 'Dementia clients',
                  value: p.dementiaClients,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(dementiaClients: v)),
                ),
                _Toggle(
                  label: 'Palliative clients',
                  value: p.palliativeClients,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(palliativeClients: v)),
                ),
                _Toggle(
                  label: 'Bedbound clients',
                  value: p.bedboundClients,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(bedboundClients: v)),
                ),
                _Toggle(
                  label: 'Lift transfer',
                  value: p.liftTransfer,
                  onChanged: (v) => cubit.update(p.copyWith(liftTransfer: v)),
                ),
                _Toggle(
                  label: 'Pet-friendly household',
                  value: p.petFriendly,
                  onChanged: (v) => cubit.update(p.copyWith(petFriendly: v)),
                ),
                _Toggle(
                  label: 'Smoking household',
                  value: p.smokingHousehold,
                  onChanged: (v) =>
                      cubit.update(p.copyWith(smokingHousehold: v)),
                ),
                const SizedBox(height: 24),
                const _Note(
                  'Saved to your profile and shown to patients. These do not '
                  'filter job offers yet.',
                ),
                const SizedBox(height: 40),
              ],
            ),
            bottomNavigationBar: _SaveBar(state: state),
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
        content: const Text('Your work preferences have not been saved.'),
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

class _TargetHours extends StatelessWidget {
  const _TargetHours({required this.hours, required this.onChanged});

  final int? hours;
  final ValueChanged<int?> onChanged;

  static const int _min = 5;
  static const int _max = 60;
  static const int _step = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: Text('Target hours per week', style: ProText.body),
          ),
          if (hours == null)
            TextButton(
              onPressed: () => onChanged(30),
              child: const Text('Set', style: ProText.caption),
            )
          else ...[
            IconButton(
              onPressed: () =>
                  onChanged(hours! <= _min ? null : hours! - _step),
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              color: Const.aqua,
              visualDensity: VisualDensity.compact,
            ),
            SizedBox(
              width: 52,
              child: Text(
                '${hours}h',
                textAlign: TextAlign.center,
                style: ProText.bodyStrong,
              ),
            ),
            IconButton(
              onPressed:
                  hours! >= _max ? null : () => onChanged(hours! + _step),
              icon: const Icon(Icons.add_circle_outline, size: 20),
              color: Const.aqua,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: ProText.sectionTitle,
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: ProText.body)),
          Switch(
            value: value,
            activeThumbColor: Const.aqua,
            onChanged: onChanged,
          ),
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
              style: ProText.hint,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final WorkPreferencesState state;

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
            : () => context.read<WorkPreferencesCubit>().save(),
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
