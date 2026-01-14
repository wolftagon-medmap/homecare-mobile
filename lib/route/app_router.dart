import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:m2health/features/payment/presentation/pages/payment_page.dart';
import 'package:m2health/features/homecare_elderly/admin/pages/admin_homecare_configuration_page.dart';
import 'package:m2health/features/settings/settings_routes.dart';
import 'package:m2health/route/auth_routes.dart';
import 'package:m2health/route/core_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/go_router_refresh_stream.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/features/profiles/profile_detail_routes.dart';
import 'package:m2health/service_locator.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: rootNavigatorKey,
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),

  redirect: (context, state) {
    final authState = sl<AuthCubit>().state;
    final bool isLoggedIn = authState.status == AuthStatus.authenticated;

    const authRoutes = [
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.forgotPassword,
      AppRoutes.otpVerification,
      AppRoutes.resetPassword,
      AppRoutes.resetPasswordSuccess,
    ];
    const publicRoutes = [
      ...authRoutes,
      AppRoutes.deleteAccountSuccess,
    ];

    final bool inAuthRoute = authRoutes.contains(state.matchedLocation);
    final bool inPublicRoute = publicRoutes.contains(state.matchedLocation);

    log('Current Route: ${state.matchedLocation}, Is Logged In: $isLoggedIn, inAuthRoute: $inAuthRoute, inPublicRoute: $inPublicRoute',
        name: 'AppRouter');

    // Redirect to Login if not logged in and trying to access protected route
    if (!isLoggedIn && !inPublicRoute) {
      return AppRoutes.signIn;
    }

    // Redirect to Dashboard if already logged in and trying to access Login/Signup
    if (isLoggedIn && inAuthRoute) {
      return AppRoutes.dashboard;
    }

    return null; // No redirect needed
  },

  routes: [
    ...CoreRoutes.routes, // NavBar Routes
    ...AuthRoutes.routes,
    ...ProfileDetailRoutes.routes,
    ...SettingsRoutes.routes,

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

    // GoRoute(
    //   path: '/locations',
    //   builder: (context, state) => LocationPage(),
    // ),
  ],
  // errorPageBuilder: (context, state) {
  //   return MaterialPage(child: HomePage());
  // },
);
