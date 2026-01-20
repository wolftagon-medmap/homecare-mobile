import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/models/diabetes_options.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';

class LifestyleSelfCareFormPage extends StatefulWidget {
  final LifestyleSelfCare initialData;
  final ValueChanged<LifestyleSelfCare> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const LifestyleSelfCareFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<LifestyleSelfCareFormPage> createState() =>
      LifestyleSelfCarePageState();
}

class LifestyleSelfCarePageState extends State<LifestyleSelfCareFormPage> {
  late LifestyleSelfCare _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
  }

  String? validate() {
    if (_currentData.recentHypoglycemia == null ||
        _currentData.physicalActivity == null ||
        _currentData.dietQuality == null) {
      return context.l10n.answer_all_questions_error;
    }
    return null;
  }

  void updateState(LifestyleSelfCare updatedData) {
    setState(() {
      _currentData = updatedData;
    });
    widget.onChange(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.lifestyle_self_care_title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onPressBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSectionHeader(context.l10n.lifestyle_self_care_title),
            FormRadioGroup(
              icon: Icons.bloodtype,
              title: context.l10n.recent_hypoglycemia_question,
              options: HypoglycemiaLevel.values.map((e) => e.label(context)).toList(),
              groupValue: HypoglycemiaLevel.fromValue(_currentData.recentHypoglycemia)
                  ?.label(context),
              onChanged: (label) {
                final option = HypoglycemiaLevel.values
                    .firstWhere((e) => e.label(context) == label);
                updateState(
                    _currentData.copyWith(recentHypoglycemia: option.value));
              },
            ),
            FormRadioGroup(
              icon: Icons.directions_run,
              title: context.l10n.physical_activity_question,
              options: PhysicalActivityLevel.values
                  .map((e) => e.label(context))
                  .toList(),
              groupValue:
                  PhysicalActivityLevel.fromValue(_currentData.physicalActivity)
                      ?.label(context),
              onChanged: (label) {
                final option = PhysicalActivityLevel.values
                    .firstWhere((e) => e.label(context) == label);
                updateState(
                    _currentData.copyWith(physicalActivity: option.value));
              },
            ),
            FormRadioGroup(
              icon: Icons.restaurant,
              title: context.l10n.diet_quality_question,
              options: DietQuality.values.map((e) => e.label(context)).toList(),
              groupValue:
                  DietQuality.fromValue(_currentData.dietQuality)?.label(context),
              onChanged: (label) {
                final option = DietQuality.values
                    .firstWhere((e) => e.label(context) == label);
                updateState(_currentData.copyWith(dietQuality: option.value));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: widget.saveButtonText,
          onPressed: () {
            final validationError = validate();
            if (validationError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(validationError),
                    backgroundColor: Colors.red),
              );
              return;
            }
            widget.onSave();
          },
        ),
      ),
    );
  }
}
