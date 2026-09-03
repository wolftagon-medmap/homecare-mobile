import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_profile_page.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_section_page.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class HealthSectionArgs {
  final String code;
  final int? patientProfileId;

  const HealthSectionArgs(this.code, this.patientProfileId);
}

class HealthProfileRoutes {
  static const String entry = AppRoutes.healthProfile;

  static const String section = '/health-profile/section/:code';

  static String sectionFor(String code) => '/health-profile/section/$code';

  static List<RouteBase> routes = [
    GoRoute(
      path: entry,
      builder: (context, state) => BlocProvider<HealthProfileCubit>(
        create: (_) => sl<HealthProfileCubit>(),
        child: const HealthProfilePage(),
      ),
    ),
    GoRoute(
      path: section,
      builder: (context, state) => BlocProvider<HealthSectionCubit>(
        create: (_) => sl<HealthSectionCubit>(
          param1: HealthSectionArgs(
            state.pathParameters['code'] ?? '',
            _activeProfileId(context),
          ),
        ),
        child: const HealthSectionPage(),
      ),
    ),
  ];

  /// A deep link carries no profile, so the section falls back to whichever
  /// family member the app is currently acting for.
  static int? _activeProfileId(BuildContext context) {
    try {
      return context.read<PatientProfileCubit>().activeProfile?.id;
    } catch (_) {
      return null;
    }
  }
}
