import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_form.dart';

class SmokingHabitAssessmentCard extends StatelessWidget {
  final SmokingCessationForm smokingForm;
  const SmokingHabitAssessmentCard({
    required this.smokingForm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentHabit = smokingForm.isSmoking
        ? (smokingForm.productTypes != null &&
                smokingForm.productTypes!.isNotEmpty
            ? smokingForm.productTypes!.join(', ')
            : context.l10n.common_none)
        : 'Not currently smoking';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Smoking Habit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(bottom: 16.0),
            child: Column(
              spacing: 12,
              children: [
                _AssessmentItem(
                  icon: Icons.smoking_rooms,
                  label: 'SMOKING?',
                  value: currentHabit,
                ),
                if (smokingForm.isSmoking) ...[
                  _AssessmentItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'INTENSITY',
                    value: '${smokingForm.sticksPerDay ?? 0} sticks / day',
                  ),
                  _AssessmentItem(
                    icon: Icons.history_rounded,
                    label: 'PREVIOUS ATTEMPTS',
                    value: smokingForm.hasTriedQuitting
                        ? 'Has tried to quit before'
                        : 'No previous attempts',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AssessmentItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF35C5CF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A7282),
                  letterSpacing: 0.25,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
