import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';

class PhysicalSignsFormPage extends StatefulWidget {
  final PhysicalSigns initialData;
  final ValueChanged<PhysicalSigns> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const PhysicalSignsFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<PhysicalSignsFormPage> createState() => PhysicalSignsPageState();
}

class PhysicalSignsPageState extends State<PhysicalSignsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _eyesExamDateController = TextEditingController();
  final _eyesFindingsController = TextEditingController();
  final _kidneyEgfrController = TextEditingController();
  final _kidneyAcrController = TextEditingController();

  late PhysicalSigns _currentData;

  bool validate() {
    return _formKey.currentState?.validate() ?? true;
  }

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
    _initializeControllers();
  }

  void _initializeControllers() {
    _eyesExamDateController.text = _currentData.eyesLastExamDate ?? '';
    _eyesFindingsController.text = _currentData.eyesFindings ?? '';
    _kidneyEgfrController.text = _currentData.kidneysEgfr ?? '';
    _kidneyAcrController.text = _currentData.kidneysUrineAcr ?? '';
    // Radio buttons (feetSkinStatus, feetDeformityStatus) are handled directly in _currentData
  }

  @override
  void dispose() {
    _eyesExamDateController.dispose();
    _eyesFindingsController.dispose();
    _kidneyEgfrController.dispose();
    _kidneyAcrController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      _currentData = _currentData.copyWith(
        eyesLastExamDate: _eyesExamDateController.text,
        eyesFindings: _eyesFindingsController.text,
        kidneysEgfr: _kidneyEgfrController.text,
        kidneysUrineAcr: _kidneyAcrController.text,
      );
    });
    widget.onChange(_currentData);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate =
          DateFormat('yyyy-MM-dd').parse(_eyesExamDateController.text);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _eyesExamDateController.text = formattedDate;
      _updateState();
    }
  }

  // --- Mappings ---
  String? _getSkinUiValue(String? englishValue) {
    if (englishValue == 'Normal') return context.l10n.skin_normal;
    if (englishValue == 'Dry') return context.l10n.skin_dry;
    if (englishValue == 'Ulcer') return context.l10n.skin_ulcer;
    if (englishValue == 'Infection') return context.l10n.skin_infection;
    return englishValue;
  }

  String? _getSkinEnglishValue(String? uiValue) {
    if (uiValue == context.l10n.skin_normal) return 'Normal';
    if (uiValue == context.l10n.skin_dry) return 'Dry';
    if (uiValue == context.l10n.skin_ulcer) return 'Ulcer';
    if (uiValue == context.l10n.skin_infection) return 'Infection';
    return uiValue;
  }

  String? _getDeformityUiValue(String? englishValue) {
    if (englishValue == 'None') return context.l10n.deformity_none;
    if (englishValue == 'Bunions') return context.l10n.deformity_bunions;
    if (englishValue == 'Claw toes') return context.l10n.deformity_claw_toes;
    return englishValue;
  }

  String? _getDeformityEnglishValue(String? uiValue) {
    if (uiValue == context.l10n.deformity_none) return 'None';
    if (uiValue == context.l10n.deformity_bunions) return 'Bunions';
    if (uiValue == context.l10n.deformity_claw_toes) return 'Claw toes';
    return uiValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.physical_signs_title,
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionHeader(context.l10n.physical_signs_if_have_title),
              FormSubHeader(context.l10n.eyes_label,
                  iconPath: "assets/icons/ic_eyes.png"),
              TextFormField(
                controller: _eyesExamDateController,
                onChanged: (_) => _updateState(),
                decoration: const FormInputDecoration().copyWith(
                  labelText: context.l10n.last_exam_date_label,
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // This field is optional
                  }

                  // Check YYYY-MM-DD format
                  final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegex.hasMatch(value)) {
                    return context.l10n.invalid_date_format_error;
                  }

                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(value);
                    return null;
                  } catch (e) {
                    return context.l10n.invalid_date_error;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _eyesFindingsController,
                onChanged: (_) => _updateState(),
                decoration: const FormInputDecoration()
                    .copyWith(labelText: context.l10n.findings_label),
              ),
              const SizedBox(height: 24),
              FormSubHeader(context.l10n.kidneys_label,
                  iconPath: "assets/icons/ic_kidney.png"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyEgfrController,
                      onChanged: (_) => _updateState(),
                      decoration: const FormInputDecoration()
                          .copyWith(labelText: 'eGFR', hintText: 'E.g 90'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyAcrController,
                      onChanged: (_) => _updateState(),
                      decoration: const FormInputDecoration().copyWith(
                          labelText: 'Urine ACR', hintText: 'E.g 30 mg/g'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSubHeader(context.l10n.feet_label,
                  iconPath: "assets/icons/ic_feet.png"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FeetSection(
                      title: context.l10n.skin_label,
                      options: [
                        context.l10n.skin_normal,
                        context.l10n.skin_dry,
                        context.l10n.skin_ulcer,
                        context.l10n.skin_infection
                      ],
                      groupValue: _getSkinUiValue(_currentData.feetSkinStatus),
                      onChanged: (v) {
                        final newData = _currentData.copyWith(
                            feetSkinStatus: _getSkinEnglishValue(v));
                        setState(() => _currentData = newData);
                        widget.onChange(newData);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FeetSection(
                      title: context.l10n.deformity_label,
                      options: [
                        context.l10n.deformity_none,
                        context.l10n.deformity_bunions,
                        context.l10n.deformity_claw_toes
                      ],
                      groupValue: _getDeformityUiValue(
                          _currentData.feetDeformityStatus),
                      onChanged: (v) {
                        final newData = _currentData.copyWith(
                            feetDeformityStatus: _getDeformityEnglishValue(v));
                        setState(() => _currentData = newData);
                        widget.onChange(newData);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: widget.saveButtonText,
          onPressed: () {
            if (validate()) {
              // Optional fields don't block saving
              widget.onSave();
            }
          },
        ),
      ),
    );
  }
}

/// A specialized widget for the "Feet" section with radio buttons.
class _FeetSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _FeetSection({
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSubHeader(title),
        ...options.map((option) {
          return Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
              Expanded(child: Text(option)),
            ],
          );
        }),
      ],
    );
  }
}
