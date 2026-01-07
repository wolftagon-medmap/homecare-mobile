import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/route/app_routes.dart';

class DiabeticCare extends StatelessWidget {
  const DiabeticCare({super.key});

  void _onDiabeticCareMenuTap(BuildContext context) async {
    final bool hasForm = await context.read<DiabetesFormCubit>().loadForm();
    if (!context.mounted) return;
    if (hasForm) {
      GoRouter.of(context).goNamed(AppRoutes.diabeticProfileSummary);
    } else {
      GoRouter.of(context).goNamed(AppRoutes.diabeticProfileForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.diabetic_care_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: ListView(
          children: [
            ServiceSelectionCard(
              title: context.l10n.diabetic_retinal_photography,
              description: context.l10n.diabetic_retinal_photography_desc,
              imagePath: 'assets/images/ilu_diabet_retina.png',
              backgroundColor: const Color(0xFF9AE1FF).withValues(alpha: 0.33),
              onTap: () async {
                _onDiabeticCareMenuTap(context);
              },
            ),
            ServiceSelectionCard(
              title: context.l10n.diabetic_foot_screening,
              description: context.l10n.diabetic_foot_screening_desc,
              imagePath: 'assets/images/ilu_diabet_foot.png',
              backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
              onTap: () async {
                _onDiabeticCareMenuTap(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
