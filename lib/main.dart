import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/screening_appointment_action_cubit.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/features/auth/data/datasources/google_auth_source.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/chatbot/chatbot_providers.dart';
import 'package:m2health/features/guided_booking/guided_booking_providers.dart';
import 'package:m2health/features/health_profile/health_profile_providers.dart';
import 'package:m2health/features/messaging/messaging_providers.dart';
import 'package:m2health/features/pricing/pricing_providers.dart';
import 'package:m2health/features/medical_record/domain/usecases/delete_medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/get_medical_records.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/delete_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/store_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/certificate_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/l10n/app_localizations.dart';
import 'package:m2health/route/app_router.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'const.dart';
import 'core/presentation/app_shell_metrics.dart';
import 'core/services/app_config_service.dart';
import 'core/presentation/widgets/app_update_dialog.dart';
import 'core/services/fcm_service.dart';
import 'core/utils/version_check.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  } catch (e, st) {
    debugPrint('Firebase init failed: $e\n$st');
  }

  await setupLocator();

  // FCM must not block app startup: on iOS without push entitlements /
  // APNs setup, requestPermission/getToken can hang or throw and leave a
  // blank screen. Treat notifications as best-effort.
  try {
    await sl<FcmService>().init();
  } catch (e, st) {
    debugPrint('FcmService init failed: $e\n$st');
  }

  // Timezone setup
  try {
    tz.initializeTimeZones();
    final String currentTimeZone =
        (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  } catch (e, st) {
    debugPrint('Timezone setup failed: $e\n$st');
  }

  // Google OAuth setup
  try {
    final googleSource = sl<GoogleAuthSource>();
    await googleSource.init();
  } catch (e, st) {
    debugPrint('GoogleAuthSource init failed: $e\n$st');
  }

  final localeCubit = LocaleCubit();
  await localeCubit.loadSavedLocale();

  WidgetsBinding.instance.addPostFrameCallback((_) => _checkForAppUpdate());

  runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      enabled: false,
      tools: [
        ...DevicePreview.defaultTools,
        DevicePreviewScreenshot(
            onScreenshot: screenshotAsFiles(
          // Save screenshots to the 'screenshots' directory in the app's documents directory
          Directory('${Directory.current.path}/screenshots'),
        )),
      ],
      builder: (context) => TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LocaleCubit>.value(
              // App Language
              value: localeCubit,
            ),
          ],
          child: const M2HealthApp(),
        ),
      ),
    ),
  );
}

class M2HealthApp extends StatelessWidget {
  const M2HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<UserRoleCubit>()..loadUserRole()),
        BlocProvider<NutritionFlowBloc>(
          create: (context) => NutritionFlowBloc(
            questionnaireService: sl<QuestionnaireService>(),
            createNutritionAppointment: sl<CreateNutritionAppointment>(),
          ),
        ),
        BlocProvider(create: (context) => AppointmentCubit(sl<Dio>())),
        BlocProvider(create: (context) => ProviderAppointmentCubit(sl<Dio>())),
        BlocProvider(
          create: (context) =>
              ScreeningAppointmentActionCubit(repository: sl()),
        ),
        BlocProvider(
            create: (context) => PatientProfileCubit(
                  getProfilesUseCase: sl<GetProfiles>(),
                  createProfileUseCase: sl<CreateProfile>(),
                  updateProfileUseCase: sl<UpdateProfile>(),
                  deleteProfileUseCase: sl<DeleteProfile>(),
                )),
        BlocProvider(
            create: (context) => ProfessionalProfileCubit(
                  getProfessionalProfileUseCase: sl<GetProfessionalProfile>(),
                  updateProfessionalProfileUseCase:
                      sl<UpdateProfessionalProfile>(),
                  submitProfessionalVerificationUseCase:
                      sl<SubmitProfessionalVerification>(),
                )),
        BlocProvider(
          create: (context) => CertificateCubit(
            createCertificateUseCase: sl<CreateCertificate>(),
            updateCertificateUseCase: sl<UpdateCertificate>(),
            deleteCertificateUseCase: sl<DeleteCertificate>(),
          ),
        ),
        BlocProvider(
          create: (context) => PharmacogenomicsCubit(
            getPharmacogenomics: sl<GetPharmacogenomics>(),
            storePharmacogenomics: sl<StorePharmacogenomics>(),
            deletePharmacogenomic: sl<DeletePharmacogenomic>(),
          ),
        ),
        // Medical Record Module
        BlocProvider(
          create: (context) => MedicalRecordBloc(
            getMedicalRecords: sl<GetMedicalRecords>(),
            deleteMedicalRecord: sl<DeleteMedicalRecord>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              DiabetesFormCubit(sl<Dio>(), sl<QuestionnaireService>()),
        ),
        BlocProvider(create: (context) => sl<SubscriptionCubit>()),

        // === Client-feedback build — feature seams (A0 owns this block) ===
        // App-wide blocs per feature, filled in by that feature's owning agent
        // in lib/features/<slug>/<slug>_providers.dart. Empty lists are no-ops.
        ...GuidedBookingProviders.providers,
        ...MessagingProviders.providers,
        ...PricingProviders.providers,
        ...ChatbotProviders.providers,
        ...HealthProfileProviders.providers,
      ],
      child: BlocBuilder<LocaleCubit, AppLocale>(builder: (context, locale) {
        return MaterialApp.router(
          useInheritedMediaQuery: true,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'm2health',
          locale: locale.flutterLocale,
          theme: ThemeData(
            fontFamily: 'Poppins', // Set Poppins as the default font
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              centerTitle: true,
            ),
            bottomAppBarTheme: const BottomAppBarThemeData(
              color: Colors.white,
              elevation: 8,
              shape: CircularNotchedRectangle(),
            ),
            cardTheme: const CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Const.aqua,
              selectionColor: Const.aqua.withValues(alpha: 0.4),
              selectionHandleColor: Const.aqua,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Const.tosca,
                  width: 1.5,
                ),
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Const.aqua; // Color when selected
                }
                return Colors.grey; // Color when unselected
              }),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontFamily: 'Poppins'),
              displayMedium: TextStyle(fontFamily: 'Poppins'),
              displaySmall: TextStyle(fontFamily: 'Poppins'),
              headlineLarge: TextStyle(fontFamily: 'Poppins'),
              headlineMedium: TextStyle(fontFamily: 'Poppins'),
              headlineSmall: TextStyle(fontFamily: 'Poppins'),
              titleLarge: TextStyle(fontFamily: 'Poppins'),
              titleMedium: TextStyle(fontFamily: 'Poppins'),
              titleSmall: TextStyle(fontFamily: 'Poppins'),
              bodyLarge: TextStyle(fontFamily: 'Poppins'),
              bodyMedium: TextStyle(fontFamily: 'Poppins'),
              bodySmall: TextStyle(fontFamily: 'Poppins'),
              labelLarge: TextStyle(fontFamily: 'Poppins'),
              labelMedium: TextStyle(fontFamily: 'Poppins'),
              labelSmall: TextStyle(fontFamily: 'Poppins'),
            ),
            scaffoldBackgroundColor: Colors.white,
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Const.aqua,
              headerForegroundColor: Colors.white,
              backgroundColor: Colors.white,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Const.aqua;
                }
                return null;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Const.aqua;
                }
                return null;
              }),
              todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Const.aqua),
            useMaterial3: true,
          ),
          builder: DevicePreview.appBuilder,
          // localizationsDelegates: GlobalMaterialLocalizations.delegates,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocaleUtils.supportedLocales,
          routerConfig: router,
        );
      }),
    );
  }
}

/// Checks the installed version against server thresholds on startup and
/// shows a forced/recommended update popup.
Future<void> _checkForAppUpdate() async {
  try {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final config = await sl<AppConfigService>().fetch();
    final decision = resolveUpdate(currentVersion, config);
    if (decision == UpdateDecision.none) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final forced = decision == UpdateDecision.force;
    await showAppUpdateDialog(
      context,
      forced: forced,
      updateUrl: config.updateUrl,
      currentVersion: currentVersion,
      latestVersion: config.latestVersion,
      message: forced ? config.forceMessage : config.recommendMessage,
    );
  } catch (_) {
    // fail-open
  }
}

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: AppShellMetrics.shellBottomPadding),
            child: navigationShell,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFloatingNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    return BlocBuilder<UserRoleCubit, UserRoleState>(
      builder: (context, roleState) {
        // Professionals get their own destinations. Branch 2 (store) and 3
        // (favourites) have nothing to offer someone who delivers care.
        // Patients are untouched.
        final destinations = roleState.isProvider
            ? const [
                _NavDestination(
                    branch: 0, icon: Icons.home_rounded, label: 'Home'),
                _NavDestination(
                    branch: 1,
                    icon: Icons.calendar_month_outlined,
                    label: 'Appointments'),
                _NavDestination(
                    branch: 4, icon: Icons.person_outline, label: 'Profile'),
              ]
            : const [
                _NavDestination(
                    branch: 0, icon: Icons.home_rounded, label: 'Home'),
                _NavDestination(
                    branch: 1,
                    icon: Icons.calendar_month_outlined,
                    label: 'Appointments'),
                _NavDestination(
                    branch: 2,
                    icon: Icons.add_shopping_cart_outlined,
                    label: 'Store'),
                _NavDestination(
                    branch: 3,
                    icon: Icons.favorite_border_outlined,
                    label: 'Favourites'),
                _NavDestination(
                    branch: 4, icon: Icons.person_outline, label: 'Profile'),
              ];

        return Container(
          height: AppShellMetrics.navBarHeight,
          margin: const EdgeInsets.only(
            bottom: AppShellMetrics.navBarBottomMargin,
            left: AppShellMetrics.navBarSideMargin,
            right: AppShellMetrics.navBarSideMargin,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF232F55).withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final d in destinations)
                _NavButton(
                  destination: d,
                  selected: navigationShell.currentIndex == d.branch,
                  showLabel: true,
                  onTap: () => navigationShell.goBranch(d.branch),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.branch,
    required this.icon,
    required this.label,
  });

  final int branch;
  final IconData icon;
  final String label;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.destination,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;

  static const _active = Color(0xFF12B3C7);
  static const _inactive = Color(0xFF97A2BC);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _active : _inactive;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.icon, size: showLabel ? 23 : 27, color: color),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  height: 1.1,
                  letterSpacing: -0.2,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
