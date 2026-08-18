import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/care_dna/presentation/pages/care_dna_preview_page.dart';
import 'package:m2health/features/care_dna/presentation/pages/condition_experience_page.dart';
import 'package:m2health/features/care_dna/presentation/pages/languages_style_page.dart';
import 'package:m2health/features/care_dna/presentation/pages/services_expertise_page.dart';
import 'package:m2health/features/care_dna/presentation/pages/where_i_work_page.dart';
import 'package:m2health/features/care_dna/presentation/pages/work_preferences_page.dart';
import 'package:m2health/features/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/manage_services_cubit.dart';
import 'package:m2health/features/profiles/presentation/pages/admin/admin_professionals_page.dart';
import 'package:m2health/features/profiles/presentation/pages/admin/manage_services_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_lifestyle_n_selfcare_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_medical_history_n_risk_factor_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_physical_sign_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_mental_state_page.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/profiles/presentation/bloc/mental_health_state_cubit.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_professional_profile.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_basic_info_page.dart';
import 'package:m2health/features/medical_record/presentation/pages/medical_records_page.dart';
import 'package:m2health/features/profiles/presentation/pages/manage_provided_services_page.dart';
import 'package:m2health/features/profiles/presentation/pages/saved_addresses_page.dart';
import 'package:m2health/features/profiles/presentation/pages/saved_address_form_page.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_cubit.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/pages/verification_hub_page.dart';
import 'package:m2health/features/schedule/presentation/pages/working_schedule_page.dart';
import 'package:m2health/features/wellness_genomics/presentation/pages/wellness_genomics_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class ProfileDetailRoutes {
  static List<GoRoute> routes = [
    // Profile Information
    GoRoute(
      path: AppRoutes.profileBasicInfo,
      name: AppRoutes.profileBasicInfo,
      builder: (context, state) {
        // Set from the switcher's "+ New Profile"; absent means edit the
        // active profile.
        final isCreate = state.extra as bool? ?? false;
        return EditBasicInfoPage(isCreate: isCreate);
      },
    ),
    GoRoute(
      path: AppRoutes.savedAddresses,
      name: AppRoutes.savedAddresses,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SavedAddressesCubit(
            getAddressesUseCase: sl(),
            createAddressUseCase: sl(),
            updateAddressUseCase: sl(),
            deleteAddressUseCase: sl(),
            setDefaultAddressUseCase: sl(),
          ),
          child: const SavedAddressesPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.savedAddressForm,
      name: AppRoutes.savedAddressForm,
      builder: (context, state) {
        // Present when editing; absent means adding a new one.
        final existing = state.extra as Address?;
        return BlocProvider(
          create: (_) => SavedAddressesCubit(
            getAddressesUseCase: sl(),
            createAddressUseCase: sl(),
            updateAddressUseCase: sl(),
            deleteAddressUseCase: sl(),
            setDefaultAddressUseCase: sl(),
          ),
          child: SavedAddressFormPage(existing: existing),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.profileMedicalHistory,
      name: AppRoutes.profileMedicalHistory,
      builder: (context, state) {
        return const EditMedicalHistoryNRiskFactorPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profileLifestyle,
      name: AppRoutes.profileLifestyle,
      builder: (context, state) {
        return const EditLifestyleNSelfcarePage();
      },
    ),
    GoRoute(
      path: AppRoutes.profilePhysicalSigns,
      name: AppRoutes.profilePhysicalSigns,
      builder: (context, state) {
        return const EditPhysicalSignPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profileMentalState,
      name: AppRoutes.profileMentalState,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MentalHealthStateCubit(
            repository: sl(),
            questionnaireService: sl<QuestionnaireService>(),
          ),
          child: const EditMentalStatePage(),
        );
      },
    ),

    // Health Records
    GoRoute(
      path: AppRoutes.medicalRecord,
      builder: (context, state) {
        return const MedicalRecordsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.pharmagenomics,
      builder: (context, state) {
        return const PharmagenomicsProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.wellnessGenomics,
      builder: (context, state) {
        return const WellnessGenomicsProfilePage();
      },
    ),

    // Professional Profile
    GoRoute(
      path: AppRoutes.editProfessionalProfile,
      builder: (context, state) {
        ProfessionalProfile profile = state.extra as ProfessionalProfile;
        return EditProfessionalProfilePage(profile: profile);
      },
    ),
    GoRoute(
      path: AppRoutes.editProfessionalServices,
      name: AppRoutes.editProfessionalServices,
      builder: (context, state) {
        final args = state.extra as ManageServicesArgs;
        return BlocProvider(
            create: (_) => ManageServicesCubit(
                  profileRemoteDatasource: sl(),
                  servicesRepository: sl(),
                  role: args.role,
                )..loadServices(
                    args.currentServices,
                    isHomeScreeningAuthorized: args.isHomeScreeningAuthorized,
                  ),
            child: const ManageProvidedServicesPage());
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

    // Care DNA (prototype)
    GoRoute(
      path: AppRoutes.careDnaServices,
      name: AppRoutes.careDnaServices,
      builder: (context, state) {
        final args = state.extra as ManageServicesArgs;
        return BlocProvider(
          create: (_) => ManageServicesCubit(
            profileRemoteDatasource: sl(),
            servicesRepository: sl(),
            role: args.role,
          )..loadServices(
              args.currentServices,
              isHomeScreeningAuthorized: args.isHomeScreeningAuthorized,
            ),
          child: const ServicesExpertisePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.careDnaConditions,
      name: AppRoutes.careDnaConditions,
      builder: (context, state) => const ConditionExperiencePage(),
    ),
    GoRoute(
      path: AppRoutes.careDnaLanguages,
      name: AppRoutes.careDnaLanguages,
      builder: (context, state) => const LanguagesStylePage(),
    ),
    GoRoute(
      path: AppRoutes.careDnaWhereIWork,
      name: AppRoutes.careDnaWhereIWork,
      builder: (context, state) => const WhereIWorkPage(),
    ),
    GoRoute(
      path: AppRoutes.careDnaPreferences,
      name: AppRoutes.careDnaPreferences,
      builder: (context, state) => const WorkPreferencesPage(),
    ),
    GoRoute(
      path: AppRoutes.careDnaPreview,
      name: AppRoutes.careDnaPreview,
      builder: (context, state) => const CareDnaPreviewPage(),
    ),

    // Admin Panel
    GoRoute(
      path: AppRoutes.manageServices,
      builder: (context, state) {
        return const ManageServicesPage();
      },
    ),
    GoRoute(
      path: AppRoutes.adminProfessionals,
      builder: (context, state) {
        return const AdminProfessionalsPage();
      },
    ),
    // TODO: delete manageHealthScreening route after all navigation call-sites are updated.
    // Redirecting to unified ManageServicesPage with screening pre-selected.
    GoRoute(
      path: AppRoutes.manageHealthScreening,
      builder: (context, state) {
        return const ManageServicesPage();
      },
    ),
  ];
}
