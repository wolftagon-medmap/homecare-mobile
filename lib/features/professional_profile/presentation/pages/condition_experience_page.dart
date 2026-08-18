import 'package:flutter/material.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Condition experience',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<CareDnaProfile>(
        valueListenable: CareDnaStore.instance,
        builder: (context, dna, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Which conditions have you cared for? This is what families '
                  'search on most when they are choosing someone.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                SelectThenRate(
                  tags: dna.conditions,
                  scale: LevelScale.experience,
                  onChanged: CareDnaStore.instance.setConditions,
                  emptyHint:
                      'No conditions added yet — tap one above to start.',
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
