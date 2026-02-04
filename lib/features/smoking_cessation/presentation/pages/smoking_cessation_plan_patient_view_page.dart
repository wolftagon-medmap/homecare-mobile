import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/smoking_cessation/presentation/bloc/smoking_cessation_plan_cubit.dart';

class SmokingCessationPlanPatientViewPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const SmokingCessationPlanPatientViewPage({
    super.key,
    required this.appointment,
  });

  @override
  State<SmokingCessationPlanPatientViewPage> createState() =>
      _SmokingCessationPlanPatientViewPageState();
}

class _SmokingCessationPlanPatientViewPageState
    extends State<SmokingCessationPlanPatientViewPage> {
  @override
  void initState() {
    super.initState();
    context.read<SmokingCessationPlanCubit>().fetchPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Care Plan'),
      ),
      body: BlocBuilder<SmokingCessationPlanCubit, SmokingCessationPlanState>(
        builder: (context, state) {
          if (state.fetchStatus == SmokingCessationPlanStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.fetchStatus == SmokingCessationPlanStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Failed to load care plan'),
            );
          }

          final plan = state.plan;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Target Quit Date Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF35C5CF), Color(0xFF209BA3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCEFAFE).withValues(alpha: 0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xFFECFEFF), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'TARGET QUIT DATE',
                            style: TextStyle(
                              color: const Color(0xFFECFEFF)
                                  .withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.targetQuitDate != null
                            ? DateFormat('MMMM dd, yyyy')
                                .format(plan.targetQuitDate!)
                            : '-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Mark your calendar! Your journey to a smoke-free life begins here.',
                        style: TextStyle(
                          color: Color(0xFFCEFAFE),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Next Follow-up Section
                if (plan.followUpDate != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFEDD4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEDD4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.event_repeat_rounded,
                            color: Color(0xFFF79E1B),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Next Follow-up',
                              style: TextStyle(
                                color: Color(0xFF6A7282),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              DateFormat('MMMM dd, yyyy')
                                  .format(plan.followUpDate!),
                              style: const TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                _buildSectionHeader(
                  icon: Icons.format_quote_rounded,
                  title: "Pharmacist's Advice",
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        '"${plan.adviceNote ?? ""}"',
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                (widget.appointment.provider?.avatar != null)
                                    ? NetworkImage(
                                        widget.appointment.provider!.avatar!)
                                    : null,
                            child: (widget.appointment.provider?.avatar == null)
                                ? const Icon(Icons.person,
                                    size: 20, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                widget.appointment.provider?.name ??
                                    'Pharmacist',
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Pharmacist',
                                style: TextStyle(
                                  color: Color(0xFF99A1AF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Prescribed Treatment Section
                if (plan.medicationName != null) ...[
                  _buildSectionHeader(
                    icon: Icons.medication_outlined,
                    title: "Prescribed Treatment",
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SelectableText(
                                plan.medicationName!,
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const SelectableText(
                                'Rx',
                                style: TextStyle(
                                  color: Color(0xFF155DFC),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          plan.medicationInstructions ??
                              "No instructions provided.",
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: Const.aqua, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
