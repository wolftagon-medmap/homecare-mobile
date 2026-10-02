import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_profile_page.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_section_page.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class HealthProfileRoutes {
  static const String entry = AppRoutes.healthProfile;

  static const String section = '/health-profile/section/:code';

  static String sectionFor(String code) => '/health-profile/section/$code';

  static List<RouteBase> routes = [
    GoRoute(
      path: entry,
      builder: (context, state) {
        final profile = _activeProfile(context);
        return BlocProvider(
          create: (_) => HealthProfileCubit(
            getSections: sl(),
            patientProfileId: profile.id,
            isAccountHolder: profile.isAccountHolder,
          ),
          child: const HealthProfilePage(),
        );
      },
    ),
    GoRoute(
      path: section,
      builder: (context, state) => BlocProvider(
        create: (_) => HealthSectionCubit(
          code: state.pathParameters['code'] ?? '',
          patientProfileId: _activeProfile(context).id,
          getSection: sl(),
          saveSection: sl(),
        ),
        child: const HealthSectionPage(),
      ),
    ),
  ];

  // The API reads a missing id as the account holder.
  static ({int? id, bool isAccountHolder}) _activeProfile(
      BuildContext context) {
    final profile = context.read<PatientProfileCubit>().activeProfile;
    if (profile == null || profile.isPrimary) {
      return (id: null, isAccountHolder: true);
    }
    return (id: profile.id, isAccountHolder: false);
  }
}
