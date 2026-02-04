import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/smoking_cessation/presentation/bloc/smoking_cessation_plan_cubit.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_plan_patient_view_page.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_plan_provider_form_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class SmokingCessationRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.smokingCessationPlanForm,
      name: AppRoutes.smokingCessationPlanForm,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final appointment = state.extra as AppointmentEntity;
        return BlocProvider(
          create: (context) =>
              SmokingCessationPlanCubit(sl(), appointment.id!),
          child: SmokingCessationPlanProviderFormPage(appointment: appointment),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.smokingCessationPlanView,
      name: AppRoutes.smokingCessationPlanView,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final appointment = state.extra as AppointmentEntity;
        return BlocProvider(
          create: (context) =>
              SmokingCessationPlanCubit(sl(), appointment.id!),
          child: SmokingCessationPlanPatientViewPage(appointment: appointment),
        );
      },
    ),
  ];
}