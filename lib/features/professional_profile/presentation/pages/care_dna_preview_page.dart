import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/care_dna_public_sections.dart';

/// Lets the professional see their own profile through a patient's eyes.
///
/// This is the moment that motivates filling the profile in: the gap between
/// what you have entered and what a patient actually sees is the argument for
/// entering more.
class CareDnaPreviewPage extends StatelessWidget {
  const CareDnaPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview',
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
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined,
                          size: 16, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This is how patients see your profile.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Const.aqua.withValues(alpha: 0.15),
                        child: const Icon(Icons.person,
                            size: 44, color: Const.tosca),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Siti Rahmawati',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(dna.role, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CareDnaStrip(dna: dna),
                const SizedBox(height: 28),
                CareDnaPublicSections(dna: dna),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
