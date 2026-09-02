import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/diabetes/diabetic_care_routes.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_services_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/homecare_elderly_service_page.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/notifications/presentation/pages/notification_inbox_page.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/physiotherapy_page.dart';
import 'package:m2health/features/nutrition/nutrition_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_services_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/precision_nutrition_page.dart';
import 'package:m2health/features/diabetes/diabetic_care.dart';
import 'package:m2health/features/home_health_screening/presentation/pages/home_health_screening.dart';
import 'package:m2health/features/remote_patient_monitoring/pages/remote_patient_monitoring.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/second_opinion.dart';
import 'package:m2health/features/psychologist/presentation/pages/psychologist_services_page.dart';
import 'package:m2health/features/psychologist/presentation/pages/psychologist_booking_flow_page.dart';
import 'package:m2health/features/optometrist/presentation/pages/optometrist_services_page.dart';
import 'package:m2health/features/optometrist/presentation/pages/optometrist_booking_flow_page.dart';
import 'package:m2health/service_locator.dart';
import 'app_routes.dart';

class DashboardRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      // Root navigator: the inbox covers the bottom app bar.
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.notificationInbox,
      name: AppRoutes.notificationInbox,
      builder: (context, state) {
        // The dashboard passes its badge cubit so mark-read updates the bell
        // live; a direct navigation (deep link) gets a self-loading one.
        final shared = state.extra;
        if (shared is NotificationsCubit) {
          return BlocProvider.value(
            value: shared,
            child: const NotificationInboxPage(),
          );
        }
        return BlocProvider(
          create: (_) => NotificationsCubit(sl<Dio>())..load(),
          child: const NotificationInboxPage(),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.pharmaServices,
      builder: (context, state) {
        return const PharmacyServicesPage();
      },
    ),
    GoRoute(
      path: AppRoutes.nursingServices,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const NursingService();
      },
    ),
    GoRoute(
      path: AppRoutes.diabeticCare,
      parentNavigatorKey: rootNavigatorKey,
      routes: DiabeticCareRoutes.routes,
      builder: (context, state) {
        return const DiabeticCare();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.remotePatientMonitoring,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const RemotePatientMonitoring();
      },
    ),
    GoRoute(
      path: AppRoutes.secondOpinionMedical,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const SecondOpinionMedical();
      },
    ),
    GoRoute(
      path: AppRoutes.precisionNutrition,
      parentNavigatorKey: rootNavigatorKey,
      routes: PrecisionNutritionRoutes.routes,
      builder: (context, state) {
        return const PrecisionNutritionPage();
      },
    ),
    GoRoute(
      path: AppRoutes.homecareForElderly,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const HomecareElderlyServicePage();
      },
    ),
    GoRoute(
      path: AppRoutes.physiotherapy,
      name: AppRoutes.physiotherapy,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const PhysiotherapyPage();
      },
    ),
    GoRoute(
      path: AppRoutes.psychologist,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const PsychologistServicesPage();
      },
    ),
    GoRoute(
      path: AppRoutes.psychologistBooking,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const PsychologistBookingFlowPage();
      },
    ),
    GoRoute(
      path: AppRoutes.optometrist,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const OptometristServicesPage();
      },
    ),
    GoRoute(
      path: AppRoutes.optometristBooking,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const OptometristBookingFlowPage();
      },
    ),
  ];
}
