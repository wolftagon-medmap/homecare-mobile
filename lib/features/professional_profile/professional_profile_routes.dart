import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/condition_experience_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/coverage_area_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/languages_care_style_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/personal_details_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/work_preferences_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/manage_services_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/pages/admin/admin_professionals_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/profile_preview_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/condition_experience_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/edit_professional_profile.dart';
import 'package:m2health/features/professional_profile/presentation/pages/languages_style_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/services_expertise_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/verification_hub_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/where_i_work_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/work_preferences_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/working_schedule_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class ProfessionalProfileRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.editProfessionalProfile,
      builder: (context, state) {
        final profile = state.extra as ProfessionalProfile;
        return BlocProvider(
          create: (_) => PersonalDetailsCubit(repository: sl()),
          child: EditProfessionalProfilePage(profile: profile),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workingSchedule,
      name: AppRoutes.workingSchedule,
      builder: (context, state) {
        return const WorkingSchedulePage();
      },
    ),
    GoRoute(
      path: AppRoutes.verificationHub,
      name: AppRoutes.verificationHub,
      builder: (context, state) {
        return const VerificationHubPage();
      },
    ),
    GoRoute(
      path: AppRoutes.professionalServices,
      name: AppRoutes.professionalServices,
      builder: (context, state) {
        final args = state.extra as ManageServicesArgs;
        return BlocProvider(
          create: (_) => ManageServicesCubit(
            professionalProfileRemoteDatasource: sl(),
            servicesRepository: sl(),
            role: args.role,
          )..loadServices(
              args.currentServices,
              proficiency: args.proficiency,
              isHomeScreeningAuthorized: args.isHomeScreeningAuthorized,
            ),
          child: const ServicesExpertisePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.professionalConditions,
      name: AppRoutes.professionalConditions,
      builder: (context, state) {
        final profile = context.read<ProfessionalProfileCubit>().state;
        return BlocProvider(
          create: (_) => ConditionExperienceCubit(repository: sl())
            ..load(profile is ProfessionalProfileLoaded
                ? profile.profile.conditionExperience
                : const []),
          child: const ConditionExperiencePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.professionalLanguages,
      name: AppRoutes.professionalLanguages,
      builder: (context, state) {
        final loaded = context.read<ProfessionalProfileCubit>().state;
        final profile =
            loaded is ProfessionalProfileLoaded ? loaded.profile : null;
        return BlocProvider(
          create: (_) => LanguagesCareStyleCubit(repository: sl())
            ..load(
              claimedLanguages: profile?.languages ?? const [],
              claimedTraits: profile?.careStyle ?? const [],
            ),
          child: const LanguagesStylePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.professionalCoverage,
      name: AppRoutes.professionalCoverage,
      builder: (context, state) {
        final loaded = context.read<ProfessionalProfileCubit>().state;
        final profile =
            loaded is ProfessionalProfileLoaded ? loaded.profile : null;
        return BlocProvider(
          create: (_) =>
              CoverageAreaCubit(repository: sl(), updateProfile: sl())
                ..load(
                  countryCode: profile?.countryCode,
                  selected: profile?.serviceAreas ?? const [],
                  radiusKm: profile?.serviceRadiusPreference,
                ),
          child: const WhereIWorkPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.professionalPreferences,
      name: AppRoutes.professionalPreferences,
      builder: (context, state) {
        final loaded = context.read<ProfessionalProfileCubit>().state;
        final profile =
            loaded is ProfessionalProfileLoaded ? loaded.profile : null;
        return BlocProvider(
          create: (_) => WorkPreferencesCubit(
            repository: sl(),
            initial: profile?.workPreferences ?? const WorkPreferences(),
          ),
          child: const WorkPreferencesPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.professionalPreview,
      name: AppRoutes.professionalPreview,
      builder: (context, state) {
        final loaded = context.read<ProfessionalProfileCubit>().state;
        final profile =
            loaded is ProfessionalProfileLoaded ? loaded.profile : null;
        return BlocProvider(
          create: (_) {
            final cubit = ProfessionalDetailCubit(getProfessionalDetail: sl());
            if (profile != null) cubit.fetchProfessionalDetail(profile.id);
            return cubit;
          },
          child: const ProfilePreviewPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.adminProfessionals,
      builder: (context, state) {
        return const AdminProfessionalsPage();
      },
    ),
  ];
}
