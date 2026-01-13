import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_appointment_flow_page.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/models/diabetes_options.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/features/booking_appointment/nursing/const.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class DiabetesFormSummaryPage extends StatelessWidget {
  const DiabetesFormSummaryPage({super.key});

  Future<void> _refreshData(BuildContext context) async {
    await context.read<DiabetesFormCubit>().loadForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.diabetes_form_title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DiabetesHistorySection(state: state),
                  const SizedBox(height: 24),
                  _RiskFactorsSection(state: state),
                  const SizedBox(height: 24),
                  _LifestyleSection(state: state),
                  const SizedBox(height: 24),
                  _PhysicalSignsSection(state: state),
                  const SizedBox(height: 32),
                  const _ActionButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _SummaryCard({required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.15),
        border: Border.all(color: backgroundColor, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String? iconPath;
  final IconData? icon;
  final Color? valueColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.iconPath,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.red.shade400, size: 20),
          const SizedBox(width: 8)
        ],
        if (iconPath != null) ...[
          Image.asset(iconPath!, width: 24, height: 24),
          const SizedBox(width: 8)
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _DiabetesHistorySection extends StatelessWidget {
  final DiabetesFormState state;
  const _DiabetesHistorySection({required this.state});

  String _buildTreatmentString(BuildContext context, DiabetesHistory history) {
    List<String> treatments = [];

    if (history.hasTreatmentDiet) {
      treatments.add(context.l10n.treatment_diet_exercise);
    }
    if (history.hasTreatmentOral) {
      treatments.add(
          '${context.l10n.treatment_oral_medications}: ${_getValueText(history.oralMedication)}');
    }
    if (history.hasTreatmentInsulin) {
      treatments.add(
          '${context.l10n.treatment_insulin}: ${_getValueText(history.insulinTypeDose)}');
    }
    return treatments.isEmpty
        ? context.l10n.common_none
        : treatments.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final history = state.diabetesHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.diabetes_history_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFF35C5CF),
          child: Column(
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_diabetes_type.png',
                label: context.l10n.diabetes_type_label,
                value: DiabetesTypeOption.fromValue(history.diabetesType)
                        ?.label(context) ??
                    history.diabetesType ??
                    context.l10n.common_not_specified,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      iconPath: 'assets/icons/ic_calendar.png',
                      label: context.l10n.year_of_diagnosis_label,
                      value: _getValueText(history.yearOfDiagnosis?.toString()),
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      iconPath: 'assets/icons/ic_blood_measurement.png',
                      label: context.l10n.last_hba1c_label,
                      value: history.lastHbA1c != null
                          ? '${history.lastHbA1c}%'
                          : '-',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                iconPath: 'assets/icons/ic_medical_checklist.png',
                label: context.l10n.current_treatment_label,
                value: _buildTreatmentString(context, history),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskFactorsSection extends StatelessWidget {
  final DiabetesFormState state;
  const _RiskFactorsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final factors = state.riskFactors;
    String boolToString(bool? value) => value == true
        ? context.l10n.common_yes
        : (value == false ? context.l10n.common_no : '-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.risk_factors_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFB393FF),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 60,
            ),
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_hypertension.png',
                label: context.l10n.hypertension_label,
                value: boolToString(factors.hasHypertension),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_fat.png',
                label: context.l10n.dyslipidemia_label,
                value: boolToString(factors.hasDyslipidemia),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_cardiovascular.png',
                label: context.l10n.cardiovascular_disease_label,
                value: boolToString(factors.hasCardiovascularDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: context.l10n.eye_disease_label,
                value: boolToString(factors.hasEyeDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_neuropathy.png',
                label: context.l10n.neuropathy_label,
                value: boolToString(factors.hasNeuropathy),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: context.l10n.kidney_disease_label,
                value: boolToString(factors.hasKidneyDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_family.png',
                label: context.l10n.family_history_label,
                value: boolToString(factors.hasFamilyHistory),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_smoking.png',
                label: context.l10n.smoking_label,
                value: _getValueText(
                    SmokingStatus.fromValue(factors.smokingStatus)
                        ?.label(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LifestyleSection extends StatelessWidget {
  final DiabetesFormState state;
  const _LifestyleSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final lifestyle = state.lifestyleSelfCare;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.lifestyle_self_care_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFFF9A9A),
          child: Column(
            children: [
              _SummaryItem(
                icon: Icons.bloodtype,
                label: context.l10n.recent_hypoglycemia_label,
                value: _getValueText(
                    HypoglycemiaLevel.fromValue(lifestyle.recentHypoglycemia)
                        ?.label(context)),
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                icon: Icons.directions_run,
                label: context.l10n.physical_activity_label,
                value: _getValueText(
                    PhysicalActivityLevel.fromValue(lifestyle.physicalActivity)
                        ?.label(context)),
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                icon: Icons.restaurant,
                label: context.l10n.diet_quality_label,
                value: _getValueText(
                    DietQuality.fromValue(lifestyle.dietQuality)
                        ?.label(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhysicalSignsSection extends StatelessWidget {
  final DiabetesFormState state;
  const _PhysicalSignsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final signs = state.physicalSigns;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.physical_signs_title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFF79E1B),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 60,
            ),
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: context.l10n.eyes_last_exam_label,
                value: _getValueText(signs.eyesLastExamDate),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: context.l10n.eyes_findings_label,
                value: _getValueText(signs.eyesFindings),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: context.l10n.kidneys_egfr_label,
                value: _getValueText(signs.kidneysEgfr),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: context.l10n.kidneys_urine_acr_label,
                value: _getValueText(signs.kidneysUrineAcr),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_feet.png',
                label: context.l10n.feet_skin_label,
                value: _getValueText(
                    FeetSkinStatus.fromValue(signs.feetSkinStatus)
                        ?.label(context)),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_feet.png',
                label: context.l10n.feet_deformity_label,
                value: _getValueText(
                    FeetDeformityStatus.fromValue(signs.feetDeformityStatus)
                        ?.label(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        SecondaryButton(
          text: context.l10n.common_edit_information,
          icon: Icons.edit,
          onPressed: () async {
            await GoRouter.of(context).pushNamed(AppRoutes.diabeticProfileForm);

            // Force a refresh to discard any unsaved changes and get the latest data from the server.
            if (!context.mounted) return;
            await context.read<DiabetesFormCubit>().loadForm();
          },
        ),
        PrimaryButton(
          text: context.l10n.common_next,
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => NursingAppointmentFlowBloc(
                    createNursingAppointment: sl(),
                    serviceType: NurseServiceType.specializedNurse,
                  ),
                  child: const NursingAppointmentFlowPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

String _getValueText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '-';
  }
  return value;
}