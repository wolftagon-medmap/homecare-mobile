import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/musculoskeletal_physiotherapy_page.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/neurological_physiotherapy_page.dart';

class PhysiotherapyPage extends StatelessWidget {
  const PhysiotherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.physiotherapy_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                ServiceSelectionCard(
                  title: context.l10n.physiotherapy_musculoskeletal_title,
                  description: context.l10n.physiotherapy_musculoskeletal_desc,
                  imagePath:
                      'assets/illustration/physiotherapy_musculoskeletal.png',
                  backgroundColor: const Color.fromRGBO(247, 158, 27, 0.1),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const MusculoskeletalPhysiotherapyPage(),
                      ),
                    );
                  },
                ),
                ServiceSelectionCard(
                  title: context.l10n.physiotherapy_neurological_title,
                  description: context.l10n.physiotherapy_neurological_desc,
                  imagePath:
                      'assets/illustration/physiotherapy_neurological.png',
                  backgroundColor: const Color.fromRGBO(178, 140, 255, 0.2),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const NeurologicalPhysiotherapyPage(),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
