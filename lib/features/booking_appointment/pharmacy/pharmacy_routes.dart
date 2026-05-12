import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/bloc/pharmacy_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_appointment_flow_page.dart';
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
        return BlocProvider(
          create: (context) => PharmacyAppointmentFlowBloc(
            createPharmacyAppointment: sl(),
            questionnaireService: sl<QuestionnaireService>(),
          ),
          child: const PharmacyAppointmentFlowPage(),
        );
      },
    ),
  ];
}
