import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/patient_health_profile/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/features/profiles/presentation/pages/admin/manage_services_page.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/pages/edit_lifestyle_n_selfcare_page.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/pages/edit_medical_history_n_risk_factor_page.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/pages/edit_physical_sign_page.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/pages/edit_mental_state_page.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/bloc/mental_health_state_cubit.dart';
import 'package:m2health/features/patient_health_profile/etc/presentation/pages/edit_basic_info_page.dart';
import 'package:m2health/features/patient_health_profile/medical_record/presentation/pages/medical_records_page.dart';
import 'package:m2health/features/profiles/presentation/pages/saved_addresses_page.dart';
import 'package:m2health/features/profiles/presentation/pages/saved_address_form_page.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_cubit.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/patient_health_profile/wellness_genomics/presentation/pages/wellness_genomics_page.dart';
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

    // Admin Panel
    GoRoute(
      path: AppRoutes.manageServices,
      builder: (context, state) {
        return const ManageServicesPage();
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
