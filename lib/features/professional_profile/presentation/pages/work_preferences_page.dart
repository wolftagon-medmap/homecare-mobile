import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/care_dna_catalog.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';

/// Chapter 6: coverage and preferences.
///
/// Everything here is captured and displayed but does not yet affect matching —
/// that was deliberately deferred. Stated on-screen so nobody demoing this
/// promises the client filtering that is not wired up.
class WorkPreferencesPage extends StatelessWidget {
  const WorkPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work preferences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<CareDnaProfile>(
        valueListenable: CareDnaStore.instance,
        builder: (context, dna, _) {
          final p = dna.preferences;
          final store = CareDnaStore.instance;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('Capacity'),
              _Stepper(
                label: 'Target hours per week',
                value: p.targetWeeklyHours,
                suffix: 'h',
                step: 5,
                min: 5,
                max: 60,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(targetWeeklyHours: v)),
              ),
              _Stepper(
                label: 'Maximum travel time',
                value: p.maxTravelMinutes,
                suffix: 'min',
                step: 15,
                min: 15,
                max: 120,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(maxTravelMinutes: v)),
              ),
              _Toggle(
                label: 'Night & overnight shifts',
                value: p.nightShift,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(nightShift: v)),
              ),
              _Toggle(
                label: 'Weekends & public holidays',
                value: p.weekendPublicHoliday,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(weekendPublicHoliday: v)),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Types of work'),
              _Toggle(
                label: 'Long-term clients',
                value: p.longTermClient,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(longTermClient: v)),
              ),
              _Toggle(
                label: 'Hospital escort',
                value: p.hospitalEscort,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(hospitalEscort: v)),
              ),
              _Toggle(
                label: 'Emergency replacement',
                value: p.emergencyReplacement,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(emergencyReplacement: v)),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Client & household'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                        child: Text('Client gender',
                            style: TextStyle(fontSize: 14))),
                    DropdownButton<String>(
                      value: p.clientGenderPreference,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final g in CareDnaCatalog.genderPreferences)
                          DropdownMenuItem(
                            value: g,
                            child:
                                Text(g, style: const TextStyle(fontSize: 13)),
                          ),
                      ],
                      onChanged: (v) => v == null
                          ? null
                          : store.setPreferences(
                              p.copyWith(clientGenderPreference: v)),
                    ),
                  ],
                ),
              ),
              _Toggle(
                label: 'Dementia clients',
                value: p.dementiaClients,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(dementiaClients: v)),
              ),
              _Toggle(
                label: 'Palliative clients',
                value: p.palliativeClients,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(palliativeClients: v)),
              ),
              _Toggle(
                label: 'Bedbound clients',
                value: p.bedboundClients,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(bedboundClients: v)),
              ),
              _Toggle(
                label: 'Lift transfer',
                value: p.liftTransfer,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(liftTransfer: v)),
              ),
              _Toggle(
                label: 'Pet-friendly household',
                value: p.petFriendly,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(petFriendly: v)),
              ),
              _Toggle(
                label: 'Smoking household',
                value: p.smokingHousehold,
                onChanged: (v) =>
                    store.setPreferences(p.copyWith(smokingHousehold: v)),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Saved to your profile and shown to patients. These do not filter job '
                        'offers yet.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
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
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle(
      {required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
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

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.suffix,
    required this.step,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String suffix;
  final int step;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          IconButton(
            onPressed: value <= min ? null : () => onChanged(value - step),
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: Const.aqua,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 52,
            child: Text(
              '$value$suffix',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: value >= max ? null : () => onChanged(value + step),
            icon: const Icon(Icons.add_circle_outline, size: 20),
            color: Const.aqua,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
