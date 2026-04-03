import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/second_opinion_imaging_flow_page.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/bloc/second_opinion_imaging_flow_bloc.dart';
import 'package:m2health/service_locator.dart';

class SecondOpinionMedical extends StatefulWidget {
  const SecondOpinionMedical({super.key});

  @override
  State<SecondOpinionMedical> createState() => _SecondOpinionMedicalState();
}

class _SecondOpinionMedicalState extends State<SecondOpinionMedical> {
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
                    builder: (context) => BlocProvider(
                      create: (context) => SecondOpinionImagingFlowBloc(
                        repository: sl(),
                      ),
                      child: const SecondOpinionImagingFlowPage(),
                    ),
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
                // Not implemented yet
              },
            ),
          ],
        ),
      ),
    );
  }
}
