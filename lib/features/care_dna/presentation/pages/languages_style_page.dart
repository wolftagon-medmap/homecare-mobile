import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/care_dna/data/care_dna_catalog.dart';
import 'package:m2health/features/care_dna/data/care_dna_store.dart';
import 'package:m2health/features/care_dna/domain/care_dna.dart';
import 'package:m2health/features/care_dna/presentation/widgets/select_then_rate.dart';

/// Chapter 4: how the professional communicates. Language is the single most
/// practical filter in a multilingual market — a patient with a Hokkien-speaking
/// parent needs it before anything clinical.
class LanguagesStylePage extends StatelessWidget {
  const LanguagesStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
        body: ValueListenableBuilder<CareDnaProfile>(
          valueListenable: CareDnaStore.instance,
          builder: (context, dna, _) {
            return TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add every language you can hold a care conversation in.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      SelectThenRate(
                        tags: dna.languages,
                        scale: LevelScale.language,
                        onChanged: CareDnaStore.instance.setLanguages,
                        emptyHint: 'No languages added yet.',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pick the qualities that describe how you work. Patients see these on '
                        'your profile.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      TagMultiSelect(
                        options: CareDnaCatalog.styleTraits,
                        selected: dna.styleTraits,
                        onChanged: CareDnaStore.instance.setStyleTraits,
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
                                'Self-declared for now. Later these can be corroborated by '
                                'patient feedback after a visit.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
