import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/_legacy/booking_appointment/pharmacy/const.dart';
import 'package:m2health/features/_legacy/booking_appointment/pharmacy/presentation/bloc/pharmacy_appointment_flow_bloc.dart';
import 'package:m2health/features/_legacy/booking_appointment/pharmacy/presentation/pages/pharmacy_appointment_flow_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class PharmacyRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.pharmacyBookAppointmentFlow,
      name: AppRoutes.pharmacyBookAppointmentFlow,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final topic = PharmacyCoachingTopic.fromCode(state.extra as String?);
        return BlocProvider(
          create: (context) => PharmacyAppointmentFlowBloc(
            createPharmacyAppointment: sl(),
            coachingTopic: topic?.code,
          ),
          child: PharmacyAppointmentFlowPage(coachingTopic: topic),
        );
      },
    ),
  ];
}
