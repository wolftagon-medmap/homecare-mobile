import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:m2health/features/payment/presentation/pages/payment_page.dart';
import 'package:m2health/features/homecare_elderly/admin/pages/admin_homecare_configuration_page.dart';
import 'package:m2health/features/remote_patient_monitoring/remote_patient_monitoring_routes.dart';
import 'package:m2health/features/settings/settings_routes.dart';
import 'package:m2health/features/smoking_cessation/smoking_cessation_routes.dart';
import 'package:m2health/route/auth_routes.dart';
import 'package:m2health/route/core_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/go_router_refresh_stream.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/features/profiles/profile_detail_routes.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/core/presentation/views/splashscreen.dart';
import 'package:m2health/core/presentation/views/medical_disclaimer.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: rootNavigatorKey,
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),

  redirect: (context, state) async {
    final authState = sl<AuthCubit>().state;
    final bool isLoggedIn = authState.status == AuthStatus.authenticated;
    final bool isOnboardingCompleted =
        await Utils.getSpBool(Const.ONBOARDING_COMPLETED) ?? false;

    const authRoutes = [
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.forgotPassword,
      AppRoutes.otpVerification,
      AppRoutes.resetPassword,
      AppRoutes.resetPasswordSuccess,
    ];
    const onboardingRoutes = [
      AppRoutes.splash,
      AppRoutes.medicalDisclaimer,
    ];
    const publicRoutes = [
      ...authRoutes,
      ...onboardingRoutes,
      AppRoutes.deleteAccountSuccess,
    ];

    final bool inAuthRoute = authRoutes.contains(state.matchedLocation);
    final bool inPublicRoute = publicRoutes.contains(state.matchedLocation);
    final bool inOnBoardingRoute =
        onboardingRoutes.contains(state.matchedLocation);

    log('Current Route: ${state.matchedLocation}, Is Logged In: $isLoggedIn, Onboarding Completed: $isOnboardingCompleted, inAuthRoute: $inAuthRoute, inPublicRoute: $inPublicRoute',
        name: 'AppRouter');

    // Redirect to Dashboard if already logged in
    if (isLoggedIn) {
      if (inAuthRoute || inOnBoardingRoute) {
        return AppRoutes.dashboard;
      }
      return null;
    }

    // === Not Logged In ===
    // Redirect to Sign In if trying to access protected routes
    if (!inPublicRoute) {
      return AppRoutes.signIn;
    }
    // Skip onboarding if already completed
    if (isOnboardingCompleted && inOnBoardingRoute) {
      return AppRoutes.signIn;
    }
    // Show onboarding if not completed
    if (!isOnboardingCompleted && !inOnBoardingRoute) {
      return AppRoutes.splash;
    }

    return null; // No redirect needed
  },

  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.medicalDisclaimer,
      name: AppRoutes.medicalDisclaimer,
      builder: (context, state) => const MedicalDisclaimerPage(),
    ),
    ...CoreRoutes.routes, // NavBar Routes
    ...AuthRoutes.routes,
    ...ProfileDetailRoutes.routes,
    ...SettingsRoutes.routes,
    ...RemotePatientMonitoringRoutes.routes,
    ...SmokingCessationRoutes.routes,

    GoRoute(
      path: AppRoutes.payment,
      name: AppRoutes.payment,
      builder: (context, state) {
        final appointment = state.extra as AppointmentEntity;

        return BlocProvider(
          create: (context) => PaymentCubit(createPaymentUseCase: sl()),
          child: PaymentPage(appointment: appointment),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.adminHomecareConfig,
      name: AppRoutes.adminHomecareConfig,
      builder: (context, state) => const AdminHomecareConfigurationPage(),
    ),
  ],
  // errorPageBuilder: (context, state) {
  //   return MaterialPage(child: HomePage());
  // },
);
