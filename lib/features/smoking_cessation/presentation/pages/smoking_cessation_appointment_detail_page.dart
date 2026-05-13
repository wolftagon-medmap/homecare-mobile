import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/care_plan_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/prepare_smoking_cessation_plan_button.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/smoking_habit_assessment_card.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/view_smoking_cessation_plan_button.dart';

class SmokingCessationAppointmentDetailPage extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isProvider;

  const SmokingCessationAppointmentDetailPage({
    super.key,
    required this.appointment,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    final answers = detail is PharmacySmokingCessationDetail
        ? detail.questionnaireAnswers
        : null;
    final smokingCarePlans = appointment.carePlans
        .where((p) => p.type == 'smoking_cessation')
        .toList();
    final isCompleted = appointment.status.toLowerCase() == 'completed';

    return Scaffold(
      appBar: AppBar(title: const Text('Smoking Cessation Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmokingHabitAssessmentCard(intakeDetail: answers),
            const SizedBox(height: 16),
            if (!isProvider) ...[
              ViewSmokingCessationPlanButton(appointment: appointment),
              const SizedBox(height: 16),
            ],
            if (smokingCarePlans.isNotEmpty) ...[
              const Text(
                'Care Plans',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...smokingCarePlans.map((plan) => _CarePlanCard(plan: plan)),
            ],
            if (isProvider && isCompleted && smokingCarePlans.isEmpty)
              PrepareSmokingCessationPlanButton(appointment: appointment),
          ],
        ),
      ),
    );
  }
}

class _CarePlanCard extends StatelessWidget {
  final CarePlanEntity plan;
  const _CarePlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Const.aqua.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    plan.status.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                        color: Const.aqua,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (plan.description != null) ...[
              const SizedBox(height: 6),
              Text(plan.description!,
                  style: const TextStyle(fontSize: 13, height: 1.4)),
            ],
            if (plan.activities.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...plan.activities.map(
                (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 16, color: Const.aqua),
                      const SizedBox(width: 8),
                      Flexible(
                          child: Text(activity.description,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
