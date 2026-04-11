import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';

void showCompleteAppointmentDialog(BuildContext context, int appointmentId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Complete Appointment'),
        content: const Text('Mark this appointment as completed?'),
        backgroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context
                  .read<ProviderAppointmentCubit>()
                  .completeAppointment(appointmentId);
            },
            child:
                const Text('Complete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void showAcceptAppointmentDialog(BuildContext context, int appointmentId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Accept Appointment'),
        content:
            const Text('Are you sure you want to accept this appointment?'),
        backgroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context
                  .read<ProviderAppointmentCubit>()
                  .acceptAppointment(appointmentId);
            },
            child: const Text('Accept'),
          ),
        ],
      );
    },
  );
}

void showDeclineAppointmentDialog(BuildContext context, int appointmentId) {
  showDialog(
    context: context,
    builder: (BuildContext _) {
      return CancelAppoinmentDialog(
        title: 'Are you sure you want to decline this appointment?',
        subtitle: 'This action cannot be undone.',
        onPressYes: (selection) {
          context.read<ProviderAppointmentCubit>().rejectAppointment(
                appointmentId,
                cancellationReason: selection.cancellationReason,
                otherReason: selection.otherReason,
              );
        },
      );
    },
  );
}
