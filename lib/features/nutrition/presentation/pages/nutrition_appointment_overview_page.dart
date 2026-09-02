import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/nutrition/presentation/pages/assessment/nutrition_assessment_detail_screen.dart';
import 'package:m2health/features/nutrition/presentation/pages/plan/nutrition_plan_form_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class NutritionAppointmentOverviewPage extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isProvider;

  const NutritionAppointmentOverviewPage({
    super.key,
    required this.appointment,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrition Overview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // View Assessment button
            _OverviewCard(
              icon: Icons.assignment_outlined,
              title: 'Assessment',
              subtitle: 'View the nutrition intake assessment',
              color: Const.aqua,
              onTap: () => _openAssessment(context),
            ),
            const SizedBox(height: 16),

            // View Nutrition Plan
            _OverviewCard(
              icon: Icons.restaurant_menu_rounded,
              title: 'Nutrition Plan',
              subtitle: 'View the personalised nutrition plan',
              color: const Color(0xFF56AB2F),
              onTap: () => _openPlanPage(context),
            ),

            if (isProvider) ...[
              const SizedBox(height: 16),
              _OverviewCard(
                icon: Icons.edit_note_rounded,
                title: 'Submit Nutrition Plan',
                subtitle: 'Create or update the patient\'s nutrition plan',
                color: const Color(0xFFF79E1B),
                onTap: () => _openPlanForm(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openAssessment(BuildContext context) async {
    final detail = appointment.serviceRequest?.detail as NutritionDetail?;
    final responseId = detail!.questionnaireResponseId!;

    if (context.mounted) {
      context.push(
        AppRoutes.nutritionReview,
        extra: NutritionAssessmentDetailPageParams(
          questionnaireResponseId: responseId,
          asProvider: isProvider,
        ),
      );
    }
  }

  void _openPlanPage(BuildContext context) {
    context.push(AppRoutes.precisionNutritionPlan, extra: appointment.id);
  }

  void _openPlanForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<NutritionPlanCubit>(),
          child: NutritionPlanFormPage(appointmentId: appointment.id!),
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _OverviewCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A7282),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
