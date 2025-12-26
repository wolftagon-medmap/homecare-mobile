import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/route/app_routes.dart';
import '../../bloc/nutrition_assessment_cubit.dart';
import '../../widgets/precision_widgets.dart';

class NutritionAssessmentDetailScreen extends StatelessWidget {
  const NutritionAssessmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NutritionAssessmentCubit>().state;
    final healthProfile = state.healthProfile;
    final lifestyleHabits = state.lifestyleHabits;
    final nutritionHabits = state.nutritionHabits;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_my_assessment_details),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(context.l10n.precision_basic_info_title),
            if (healthProfile != null) _BasicInfoCard(profile: healthProfile),
            const SizedBox(height: 24),
            _SectionTitle(context.l10n.precision_lifestyle_habits_title),
            if (lifestyleHabits != null)
              _LifestyleHabitsCard(habits: lifestyleHabits),
            const SizedBox(height: 24),
            _SectionTitle(context.l10n.precision_nutrition_habits_title),
            if (nutritionHabits != null)
              _NutritionHabitsCard(habits: nutritionHabits),
            const SizedBox(height: 24),
            _SectionTitle(context.l10n.precision_self_rated_health_title),
            _SelfRatedHealthCard(rating: state.selfRatedHealth),
            const SizedBox(height: 24),
            _SectionTitle(context.l10n.precision_biomarker_upload_title),
            _BiomarkerUploadCard(uploadedFiles: state.fileUrls),
            const SizedBox(height: 32),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _DetailItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24, color: iconColor ?? const Color(0xFF00B4D8)),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  final HealthProfile profile;
  const _BasicInfoCard({required this.profile});

  final primaryColor = const Color(0xFF9AE1FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  label: context.l10n.precision_age_label,
                  value: context.l10n.age_years_old(profile.age),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: context.l10n.precision_gender_label,
                  value: profile.gender,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Consideration',
                  value: profile.specialConsiderations.join(', ').isEmpty
                      ? '-'
                      : profile.specialConsiderations.join(', '),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: context.l10n.precision_known_condition_label,
                  value: profile.knownCondition ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  label: context.l10n.precision_medication_history_label,
                  value: profile.medicationHistory ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: context.l10n.precision_family_history_label,
                  value: profile.familyHistory ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LifestyleHabitsCard extends StatelessWidget {
  final LifestyleHabits habits;
  const _LifestyleHabitsCard({required this.habits});

  final Color primaryColor = const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.nightlight_round,
                  iconColor: primaryColor,
                  label: 'Sleep',
                  value: context.l10n
                      .precision_hours_per_day(habits.sleepHours.toStringAsFixed(1)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.fitness_center,
                  iconColor: primaryColor,
                  label: 'Exercise',
                  value: habits.exerciseFrequency,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.watch_later_outlined,
                  iconColor: primaryColor,
                  label: 'Activity',
                  value: habits.activityLevel,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.sentiment_very_dissatisfied,
                  iconColor: primaryColor,
                  label: 'Stress Levels',
                  value: habits.stressLevel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.smoking_rooms,
            iconColor: primaryColor,
            label: context.l10n.precision_smoking_alcohol_label,
            value: habits.smokingAlcoholHabits,
          ),
        ],
      ),
    );
  }
}

class _NutritionHabitsCard extends StatelessWidget {
  final NutritionHabits habits;
  const _NutritionHabitsCard({required this.habits});

  final Color primaryColor = const Color(0xFFB393FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.fastfood,
                  iconColor: primaryColor,
                  label: 'Meal Frequency',
                  value: habits.mealFrequency,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.no_food,
                  iconColor: primaryColor,
                  label: 'Allergies',
                  value: habits.foodSensitivities,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.favorite_border,
                  iconColor: primaryColor,
                  label: 'Favorite Foods',
                  value: habits.favoriteFoods,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.do_not_disturb_on_outlined,
                  iconColor: primaryColor,
                  label: 'Avoided Foods',
                  value: habits.avoidedFoods,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.water_drop_outlined,
                  iconColor: primaryColor,
                  label: 'Water Intake',
                  value: habits.waterIntake,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.history,
                  iconColor: primaryColor,
                  label: 'Past Diets',
                  value: habits.pastDiets,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelfRatedHealthCard extends StatelessWidget {
  final double rating;
  const _SelfRatedHealthCard({required this.rating});

  final Color primaryColor = const Color(0xFFF79E1B);

  String _getEmoji(double rating) {
    if (rating <= 1.5) return '😰';
    if (rating <= 2.5) return '😕';
    if (rating <= 3.5) return '😐';
    if (rating <= 4.5) return '🙂';
    return '😊';
  }

  String _getHealthRatingText(BuildContext context, double rating) {
    if (rating <= 1.5) return context.l10n.precision_its_terrible;
    if (rating <= 2.5) return context.l10n.precision_its_bad;
    if (rating <= 3.5) return context.l10n.precision_neutral;
    if (rating <= 4.5) return context.l10n.precision_its_good;
    return context.l10n.precision_its_very_good;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _DetailItem(
              label: context.l10n.common_status,
              value: _getHealthRatingText(context, rating),
            ),
          ),
          Text(
            _getEmoji(rating),
            style: const TextStyle(fontSize: 40),
          ),
        ],
      ),
    );
  }
}

class _BiomarkerUploadCard extends StatelessWidget {
  final List<String> uploadedFiles;
  const _BiomarkerUploadCard({required this.uploadedFiles});

  final Color primaryColor = const Color(0xFFFF9A9A);

  @override
  Widget build(BuildContext context) {
    final fileNames =
        uploadedFiles.map((url) => url.split('/').last).join(", ");
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _DetailItem(
            icon: Icons.description_outlined,
            iconColor: primaryColor,
            label: context.l10n.medical_record_title,
            value: uploadedFiles.isNotEmpty
                ? 'Uploaded ($fileNames)'
                : 'Not Uploaded',
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.watch,
            iconColor: primaryColor,
            label: 'Connected Device',
            value: 'No',
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SecondaryButton(
          text: context.l10n.precision_edit_information,
          icon: Icons.edit,
          onPressed: () {
            GoRouter.of(context)
                .goNamed(AppRoutes.precisionNutritionAssessmentForm);
          },
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          text: context.l10n.precision_download_pdf,
          icon: Icons.download,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloading PDF file...')),
            );
          },
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: context.l10n.precision_back_to_page,
          onPressed: () {
            GoRouter.of(context).go(AppRoutes.precisionNutrition);
          },
        ),
      ],
    );
  }
}
