import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/dna_chip.dart';
import 'package:m2health/route/app_routes.dart';

/// The professional-facing hero. Renders the PRD's Care DNA summary line as
/// chips and shows how much of the profile is filled in.
///
/// The progress here is not verification progress. Verification asks whether
/// someone may work at all; this asks whether their profile is compelling
/// enough to get chosen. A fully licensed nurse can sit at 2 of 6 here.
class CareDnaCard extends StatelessWidget {
  const CareDnaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CareDnaProfile>(
      valueListenable: CareDnaStore.instance,
      builder: (context, dna, _) {
        final chips = dna.summaryChips();
        final progress = dna.completedChapters / CareDnaProfile.totalChapters;

        return Card(
          elevation: 4,
          shadowColor: Colors.grey.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Const.aqua.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fingerprint,
                          color: Const.aqua, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Care DNA',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'How patients see your strengths',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.push(AppRoutes.professionalPreview),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child:
                          const Text('Preview', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in chips)
                      DnaChip(label: c, filled: true, dense: true),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(Const.aqua),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dna.completedChapters} of ${CareDnaProfile.totalChapters} profile areas filled in',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
