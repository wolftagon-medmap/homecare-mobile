import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class ViewSmokingCessationPlanButton extends StatefulWidget {
  final AppointmentEntity appointment;

  const ViewSmokingCessationPlanButton({
    super.key,
    required this.appointment,
  });

  @override
  State<ViewSmokingCessationPlanButton> createState() =>
      _ViewSmokingCessationPlanButtonState();
}

class _ViewSmokingCessationPlanButtonState
    extends State<ViewSmokingCessationPlanButton> {
  bool _planExists = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPlan();
  }

  Future<void> _checkPlan() async {
    final result = await sl<SmokingCessationRepository>()
        .getSmokingCessationPlan(widget.appointment.id!);

    if (mounted) {
      setState(() {
        _planExists = result.fold((_) => false, (plan) => plan != null);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (!_planExists) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_medical_checklist.png',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Smoking Quit Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: "View Care Plan",
              icon: Icons.file_open,
              onPressed: () {
                GoRouter.of(context).pushNamed(
                  AppRoutes.smokingCessationPlanView,
                  extra: widget.appointment,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
