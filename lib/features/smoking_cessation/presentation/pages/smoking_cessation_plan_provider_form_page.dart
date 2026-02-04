import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/smoking_cessation/presentation/bloc/smoking_cessation_plan_cubit.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/smoking_habit_assessment_card.dart';

class SmokingCessationPlanProviderFormPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const SmokingCessationPlanProviderFormPage({
    super.key,
    required this.appointment,
  });

  @override
  State<SmokingCessationPlanProviderFormPage> createState() =>
      _SmokingCessationPlanProviderFormPageState();
}

class _SmokingCessationPlanProviderFormPageState
    extends State<SmokingCessationPlanProviderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _medicationNameController = TextEditingController();
  final _medicationInstructionsController = TextEditingController();
  final _adviceNoteController = TextEditingController();
  final _targetQuitDateController = TextEditingController();
  final _followUpDateController = TextEditingController();
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    context.read<SmokingCessationPlanCubit>().fetchPlan();
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _medicationInstructionsController.dispose();
    _adviceNoteController.dispose();
    _targetQuitDateController.dispose();
    _followUpDateController.dispose();
    super.dispose();
  }

  void _updateCubit() {
    final cubit = context.read<SmokingCessationPlanCubit>();
    final plan = cubit.state.plan.copyWith(
      medicationName: _medicationNameController.text,
      medicationInstructions: _medicationInstructionsController.text,
      adviceNote: _adviceNoteController.text,
    );
    cubit.updatePlan(plan);
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isTargetDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      final cubit = context.read<SmokingCessationPlanCubit>();
      if (isTargetDate) {
        cubit.updatePlan(cubit.state.plan.copyWith(targetQuitDate: picked));
      } else {
        cubit.updatePlan(cubit.state.plan.copyWith(followUpDate: picked));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmokingCessationPlanCubit, SmokingCessationPlanState>(
      listener: (context, state) {
        if (state.fetchStatus == SmokingCessationPlanStatus.success &&
            !_isPopulated) {
          _medicationNameController.text = state.plan.medicationName ?? '';
          _medicationInstructionsController.text =
              state.plan.medicationInstructions ?? '';
          _adviceNoteController.text = state.plan.adviceNote ?? '';
          if (state.plan.targetQuitDate != null) {
            _targetQuitDateController.text =
                DateFormat('yyyy-MM-dd').format(state.plan.targetQuitDate!);
          }
          if (state.plan.followUpDate != null) {
            _followUpDateController.text =
                DateFormat('yyyy-MM-dd').format(state.plan.followUpDate!);
          }
          _isPopulated = true;
        }

        if (state.submitStatus == SmokingCessationPlanStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Plan submitted successfully'),
                backgroundColor: Colors.green),
          );
          GoRouter.of(context).pop();
        } else if (state.submitStatus == SmokingCessationPlanStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.errorMessage ?? 'Failed to submit plan'),
                backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            title: const Text('Smoking Cessation Plan'),
          ),
          body: state.fetchStatus == SmokingCessationPlanStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PatientHeader(appointment: widget.appointment),
                        const SizedBox(height: 24),
                        SmokingHabitAssessmentCard(
                          smokingForm: widget
                              .appointment.pharmacyCase!.smokingCessationForm!,
                        ),
                        const SizedBox(height: 24),
                        _PrescribeMedicationSection(
                          prescribeMedication: state.prescribeMedication,
                          medicationNameController: _medicationNameController,
                          medicationInstructionsController:
                              _medicationInstructionsController,
                          onToggle: (val) => context
                              .read<SmokingCessationPlanCubit>()
                              .togglePrescribeMedication(val),
                          onChanged: (_) => _updateCubit(),
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Target Quit Date', isRequired: true),
                        const SizedBox(height: 8),
                        _buildDatePickerField(
                            _targetQuitDateController,
                            () => _selectDate(
                                context, _targetQuitDateController, true)),
                        const SizedBox(height: 16),
                        _buildLabel('Follow-up Date (Optional)'),
                        const SizedBox(height: 8),
                        _buildDatePickerField(
                            _followUpDateController,
                            () => _selectDate(
                                context, _followUpDateController, false)),
                        const SizedBox(height: 24),
                        _buildLabel('Pharmacist Advice / Plan',
                            isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _adviceNoteController,
                          maxLines: 8,
                          onChanged: (_) => _updateCubit(),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText:
                                'Enter brief advice and quit plans (e.g. Avoid coffee, chew gum when urged)...',
                            hintStyle: const TextStyle(
                                color: Color(0xFF99A1AF), fontSize: 14),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB))),
                          ),
                          validator: (val) => (val == null || val.isEmpty)
                              ? 'Please enter advice'
                              : null,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: state.submitStatus == SmokingCessationPlanStatus.loading ||
                    state.fetchStatus == SmokingCessationPlanStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    text: 'Submit Plan',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SmokingCessationPlanCubit>().submitPlan();
                      }
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins'),
        children: [
          if (isRequired)
            const TextSpan(
                text: ' *', style: TextStyle(color: Color(0xFFFB2C36))),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(
      TextEditingController controller, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'YYYY-MM-DD',
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      ),
      validator: (val) {
        if (controller == _targetQuitDateController &&
            (val == null || val.isEmpty)) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }
}

class _PatientHeader extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PatientHeader({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final patient = appointment.patientProfile!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                (patient.avatar != null) ? NetworkImage(patient.avatar!) : null,
            child: (patient.avatar == null)
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(patient.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A1A1A))),
                    _StatusBadge(status: appointment.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Age: ${patient.age} • ${patient.gender?.toTitleCase()}',
                    style: const TextStyle(
                        color: Color(0xFF6A7282), fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 12, color: Color(0xFF99A1AF)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        patient.homeAddress ?? 'Singapore',
                        style: const TextStyle(
                            color: Color(0xFF99A1AF), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
            color: Color(0xFF008236),
            fontWeight: FontWeight.bold,
            fontSize: 10),
      ),
    );
  }
}

class _PrescribeMedicationSection extends StatelessWidget {
  final bool prescribeMedication;
  final TextEditingController medicationNameController;
  final TextEditingController medicationInstructionsController;
  final Function(bool) onToggle;
  final Function(String) onChanged;

  const _PrescribeMedicationSection({
    required this.prescribeMedication,
    required this.medicationNameController,
    required this.medicationInstructionsController,
    required this.onToggle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescribe Medication?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text('Enable if prescribing NRT or other meds',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF6A7282))),
                  ],
                ),
              ),
              Switch(
                value: prescribeMedication,
                onChanged: onToggle,
                activeThumbColor: const Color(0xFF35C5CF),
              ),
            ],
          ),
          if (prescribeMedication) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Color(0xFFF3F4F6)),
            ),
            _buildLabel('Prescription Medication', isRequired: true),
            const SizedBox(height: 8),
            TextFormField(
              controller: medicationNameController,
              onChanged: onChanged,
              maxLength: 100,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g., Varenicline, Nicotine Patch',
                hintStyle: TextStyle(color: Color(0xFF99A1AF), fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14),
              validator: (val) =>
                  prescribeMedication && (val == null || val.isEmpty)
                      ? 'Required'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildLabel('Instructions'),
            const SizedBox(height: 8),
            TextFormField(
              controller: medicationInstructionsController,
              onChanged: onChanged,
              maxLines: 8,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Dosage and usage instructions...',
                hintStyle: TextStyle(color: Color(0xFF99A1AF), fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins'),
        children: [
          if (isRequired)
            const TextSpan(
                text: ' *', style: TextStyle(color: Color(0xFFFB2C36))),
        ],
      ),
    );
  }
}
