import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/health_profile/domain/entities/health_profile_subject.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_profile_page.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_section_page.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
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
        create: (_) => sl<HealthProfileCubit>(param1: _subject(context)),
        child: const HealthProfilePage(),
      ),
    ),
    GoRoute(
      path: section,
      builder: (context, state) => BlocProvider<HealthSectionCubit>(
        create: (_) => sl<HealthSectionCubit>(
          param1: HealthSectionArgs(
            state.pathParameters['code'] ?? '',
            _subject(context).patientProfileId,
          ),
        ),
        child: const HealthSectionPage(),
      ),
    ),
  ];

  // The API treats a missing id as the account holder, so only a family
  // member's profile sends one.
  static HealthProfileSubject _subject(BuildContext context) {
    final profile = context.read<PatientProfileCubit>().activeProfile;
    final isAccountHolder = profile == null || profile.isPrimary;
    return HealthProfileSubject(
      patientProfileId: isAccountHolder ? null : profile.id,
      isAccountHolder: isAccountHolder,
    );
  }
}
