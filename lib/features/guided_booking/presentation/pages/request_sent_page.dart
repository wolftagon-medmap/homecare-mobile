import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/appointment_routes.dart';

/// The end of the guided flow. It shares its layout with the other success
/// screens in the app so a completed journey always looks the same.
class RequestSentPage extends StatelessWidget {
  const RequestSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.sent;
    final state = context.watch<GuidedBookingCubit>().state;
    final name =
        state.selectedProfessional?.name ?? state.submitted?.professionalName;

    // The submitted id is the care task, so the booking has a detail page of
    // its own from the moment it is sent.
    final careTaskId = state.submitted?.id;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/ic_checklist.png',
                  width: 142,
                  height: 142,
                ),
                const SizedBox(height: 20),
                Text(
                  t.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Const.aqua,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name == null ? t.body_generic : t.body(name: name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: careTaskId == null
                        ? null
                        : () => context.go(
                              AppointmentRoutes.careTaskDetailPath(careTaskId),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Const.aqua,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      t.view_status,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    style: TextButton.styleFrom(
                      foregroundColor: Const.aqua,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      t.done,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
