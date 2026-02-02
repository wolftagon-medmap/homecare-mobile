import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/appointment/pages/screening_report_submission_page.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/screening_appointment_action_cubit.dart';

class ScreeningAppointmentDetailActionButtons extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback refreshCallback;
  const ScreeningAppointmentDetailActionButtons({
    super.key,
    required this.appointment,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreeningAppointmentActionCubit,
        ScreeningAppointmentActionState>(
      listener: (context, state) {
        if (state is ScreeningAppointmentActionSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(state.message ?? 'Appointment updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          refreshCallback();
        } else if (state is ScreeningAppointmentActionError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Builder(builder: (context) {
        final screeningData = appointment.screeningRequestData;
        final screeningStep = screeningData?.status;
        final screeningRequestId = screeningData!.id;

        switch (screeningStep) {
          case 'request_submitted':
            return _buildForPendingStatus(context, screeningRequestId);
          case 'request_accepted':
            return _buildForAcceptedStatus(context, screeningRequestId);
          case 'sample_collected':
            return _buildForSampleCollectedStatus(context, screeningRequestId);
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildForPendingStatus(BuildContext context, int screeningRequestId) {
    return BottomAppBar(
      height: 148,
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Const.aqua),
              foregroundColor: Const.aqua,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: Text(context.l10n.appointment_arrange_video_consultation),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDeclineAppointmentDialog(context, appointment.id!);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Color(0xFFED3443)),
                    foregroundColor: const Color(0xFFED3443),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: Text(context.l10n.appointment_decline_btn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9DCEFF),
                        Color(0xFF35C5CF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<ScreeningAppointmentActionCubit>()
                          .acceptScreeningRequest(
                            screeningRequestId,
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(context.l10n.appointment_accept_btn),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildForAcceptedStatus(BuildContext context, int screeningRequestId) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: () {
          context
              .read<ScreeningAppointmentActionCubit>()
              .confirmSampleCollected(screeningRequestId);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text(context.l10n.appointment_screening_confirm_sample_btn),
      ),
    );
  }

  Widget _buildForSampleCollectedStatus(
      BuildContext context, int screeningRequestId) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreeningReportSubmissionPage(
                appointmentId: appointment.id!,
              ),
            ),
          );
          refreshCallback();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text(context.l10n.screening_report_upload_btn),
      ),
    );
  }
}
