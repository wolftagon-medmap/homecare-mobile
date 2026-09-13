import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/features/_legacy/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/_legacy/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/features/appointment/pages/provider_appointment_detail_page.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

/// Appointment detail routes. Every screen here is reachable from a push
/// notification or a deep link, so the id travels in the path and the page
/// resolves the rest from it. `AppRoutes` carries only the entry constants;
/// callers build a destination with the helpers below.
class AppointmentRoutes {
  static String detailPath(int appointmentId) =>
      '${AppRoutes.appointmentDetail}/$appointmentId';

  static String careTaskDetailPath(int careTaskId) =>
      '${AppRoutes.careTaskDetail}/$careTaskId';

  static String providerDetailPath(int appointmentId) =>
      '${AppRoutes.providerAppointmentDetail}/$appointmentId';

  static List<GoRoute> routes = [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'detail/:appointmentId',
      name: AppRoutes.appointmentDetail,
      builder: (context, state) {
        final appointmentId =
            int.tryParse(state.pathParameters['appointmentId'] ?? '');
        if (appointmentId == null) return const _UnknownAppointment();
        return DetailAppointmentPage(
          appointmentId: appointmentId,
          key: ValueKey(appointmentId),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'care-task-detail/:careTaskId',
      name: AppRoutes.careTaskDetail,
      builder: (context, state) {
        final careTaskId =
            int.tryParse(state.pathParameters['careTaskId'] ?? '');
        if (careTaskId == null) return const _UnknownAppointment();
        return CareTaskDetailPage(
          careTaskId: careTaskId,
          key: ValueKey(careTaskId),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'provider-detail/:appointmentId',
      name: AppRoutes.providerAppointmentDetail,
      builder: (context, state) {
        final appointmentId =
            int.tryParse(state.pathParameters['appointmentId'] ?? '');
        if (appointmentId == null) return const _UnknownAppointment();
        return ProviderAppointmentDetailPage(
          appointmentId: appointmentId,
          key: ValueKey(appointmentId),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'schedule-appointment',
      name: AppRoutes.scheduleAppoointment,
      builder: (context, state) {
        final data = state.extra;
        if (data is! ScheduleAppointmentPageData) {
          return const _UnknownAppointment();
        }
        return BlocProvider(
          create: (context) => ScheduleAppointmentCubit(
            getAvailableTimeSlots: sl(),
            rescheduleAppointment: sl(),
          ),
          child: ScheduleAppointmentPage(data: data),
        );
      },
    ),
  ];
}

class _UnknownAppointment extends StatelessWidget {
  const _UnknownAppointment();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: const Center(
        child: Text('That booking is no longer available.'),
      ),
    );
  }
}
