import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class PrepareSmokingCessationPlanButton extends StatefulWidget {
  final AppointmentEntity appointment;

  const PrepareSmokingCessationPlanButton({
    super.key,
    required this.appointment,
  });

  @override
  State<PrepareSmokingCessationPlanButton> createState() =>
      _PrepareSmokingCessationPlanButtonState();
}

class _PrepareSmokingCessationPlanButtonState
    extends State<PrepareSmokingCessationPlanButton> {
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
      return Container(
        height: 50,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return ElevatedButton(
      onPressed: () async {
        await GoRouter.of(context).pushNamed(
          AppRoutes.smokingCessationPlanForm,
          extra: widget.appointment,
        );
        // Refresh check after returning from form
        _checkPlan();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Const.aqua,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      child: Text(
        _planExists
            ? 'Edit Smoking Cessation Plan'
            : 'Prepare Smoking Cessation Plan',
      ),
    );
  }
}