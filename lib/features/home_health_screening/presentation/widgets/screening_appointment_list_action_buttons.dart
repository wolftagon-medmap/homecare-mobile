import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/screening_appointment_action_cubit.dart';
import 'package:m2health/route/app_routes.dart';

class ScreeningAppointmentListActionButtons extends StatelessWidget {
  final AppointmentEntity appointment;
  const ScreeningAppointmentListActionButtons({
    required this.appointment,
    super.key,
  });

  String get screeningStep => appointment.screeningRequestData!.status;
  int get screeningRequestId => appointment.screeningRequestData!.id;

  @override
  Widget build(BuildContext context) {
    if (screeningStep == 'request_submitted') {
      return _buildForPendingStatus(context);
    } else if (screeningStep == 'request_accepted') {
      return _buildForAcceptedStatus(context);
    } else if (screeningStep == 'sample_collected') {
      return _buildForSampleCollectedStatus(context);
    }
    // screeningStep is 'report_ready' or unknown
    return const SizedBox.shrink();
  }

  Widget _buildForPendingStatus(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () =>
              showDeclineAppointmentDialog(context, appointment.id!),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 36),
          ),
          child: Text(context.l10n.appointment_decline_btn),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            context
                .read<ScreeningAppointmentActionCubit>()
                .acceptScreeningRequest(screeningRequestId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF35C5CF),
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 36),
          ),
          child: Text(context.l10n.appointment_accept_btn),
        ),
      ],
    );
  }

  Widget _buildForAcceptedStatus(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context
            .read<ScreeningAppointmentActionCubit>()
            .confirmSampleCollected(screeningRequestId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Const.aqua,
        foregroundColor: Colors.white,
      ),
      child: Text(context.l10n.appointment_screening_confirm_sample_btn),
    );
  }

  Widget _buildForSampleCollectedStatus(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Navigate to appointment detail page to upload report
        GoRouter.of(context).pushNamed(
          AppRoutes.providerAppointmentDetail,
          extra: appointment.id,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(context.l10n.appointment_screening_upload_report_btn),
    );
  }
}
