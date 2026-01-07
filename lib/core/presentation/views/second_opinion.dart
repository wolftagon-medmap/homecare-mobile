import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/core/presentation/views/teleradiology.dart';

class OpinionMedical extends StatefulWidget {
  const OpinionMedical({super.key});

  @override
  State<OpinionMedical> createState() => _OpinionMedicalState();
}

class _OpinionMedicalState extends State<OpinionMedical> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.second_opinion_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: ListView(
          children: [
            ServiceSelectionCard(
              title: context.l10n.second_opinion_teleradiology_title,
              description: context.l10n.second_opinion_teleradiology_desc,
              imagePath: 'assets/images/ilu_teleradiology.png',
              backgroundColor: const Color(0xFF9AE1FF).withValues(alpha: 0.33),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeleradiologyDetail(),
                  ),
                );
              },
            ),
            ServiceSelectionCard(
              title: context.l10n.second_opinion_telepathology_title,
              description: context.l10n.second_opinion_telepathology_desc,
              imagePath: 'assets/images/ilu_telepathology.png',
              backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
