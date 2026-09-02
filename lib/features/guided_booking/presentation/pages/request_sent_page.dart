import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class RequestSentPage extends StatelessWidget {
  const RequestSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.sent;
    final state = context.watch<GuidedBookingCubit>().state;
    final name =
        state.selectedProfessional?.name ?? state.submitted?.professionalName;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 72,
                color: Const.tosca,
              ),
              const SizedBox(height: 20),
              Text(
                t.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name == null ? t.body_generic : t.body(name: name),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Const.tosca,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: state.submitted == null
                      ? null
                      : () => context.push(
                            GuidedBookingRoutes.status,
                            extra: state.submitted!.id,
                          ),
                  child: Text(t.view_status),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Const.tosca),
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(t.done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
