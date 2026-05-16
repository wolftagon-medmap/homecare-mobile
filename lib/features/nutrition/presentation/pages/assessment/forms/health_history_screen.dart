import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/features/nutrition/presentation/widgets/precision_widgets.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _conditionController = TextEditingController();
  final _medicationController = TextEditingController();
  final _familyHistoryController = TextEditingController();

  /// See Questionnaire definition with code 'nutrition-abcd' in backend.
  static const Map<String, String> _specialConsiderationOptions = {
    'liver_disease': 'Liver Disease',
    'lung_disease': 'Lung Disease',
    'children': 'Children',
    'kidney_disease': 'Kidney Disease',
    'aging_adult': 'Aging Adult',
    'pregnant': 'Pregnant',
  };

  final Map<String, bool> _selectedConsiderations = {
    for (final key in _specialConsiderationOptions.keys) key: false,
  };

  @override
  void initState() {
    super.initState();

    final healthProfile =
        context.read<NutritionFlowBloc>().state.assessment.healthProfile;
    if (healthProfile == null) return;

    _conditionController.text = healthProfile.knownCondition ?? '';
    _medicationController.text = healthProfile.medicationHistory ?? '';
    _familyHistoryController.text = healthProfile.familyHistory ?? '';

    for (final value in healthProfile.specialConsiderations) {
      if (_selectedConsiderations.containsKey(value)) {
        _selectedConsiderations[value] = true;
      }
    }
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _medicationController.dispose();
    _familyHistoryController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      final healthProfile = HealthProfile(
        knownCondition: _conditionController.text.isEmpty
            ? null
            : _conditionController.text,
        specialConsiderations: _selectedConsiderations.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        medicationHistory: _medicationController.text.isEmpty
            ? null
            : _medicationController.text,
        familyHistory: _familyHistoryController.text.isEmpty
            ? null
            : _familyHistoryController.text,
      );

      context
          .read<NutritionFlowBloc>()
          .add(NutritionFlowHealthProfileUpdated(healthProfile));
      context
          .read<NutritionFlowBloc>()
          .add(const NutritionFlowAssessmentStepAdvanced());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_basic_info_title),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Known Condition Section
                      Text(
                        context.l10n.precision_known_condition_label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: context.l10n.precision_known_condition_label,
                        hintText: context.l10n.precision_known_condition_hint,
                        controller: _conditionController,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 24),

                      // Special Considerations Section
                      Text(
                        context.l10n.precision_special_consideration_title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _specialConsiderationOptions.length,
                        itemBuilder: (context, index) {
                          final key = _specialConsiderationOptions.keys
                              .elementAt(index);
                          final label = _specialConsiderationOptions[key]!;
                          return CustomCheckbox(
                            label: label,
                            value: _selectedConsiderations[key] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _selectedConsiderations[key] = value ?? false;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Medication History Section
                      Text(
                        context.l10n.precision_medication_history_label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: context.l10n.precision_medication_history_label,
                        hintText:
                            context.l10n.precision_medication_history_hint,
                        controller: _medicationController,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 24),

                      // Family Health History Section
                      Text(
                        context.l10n.precision_family_history_label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: context.l10n.precision_family_history_label,
                        hintText: context.l10n.precision_family_history_hint,
                        controller: _familyHistoryController,
                        maxLines: 3,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 10) {
                            return context.l10n.precision_family_history_error;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Next Button
              PrimaryButton(
                text: context.l10n.common_next,
                onPressed: _onNextPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
