import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/screening_appointment_action_cubit.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/features/auth/data/datasources/google_auth_source.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/medical_record/domain/usecases/delete_medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/get_medical_records.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/delete_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/store_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/features/precision/bloc/nutrition_assessment_cubit.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/presentation/bloc/certificate_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_cubit.dart';
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
import 'package:device_preview/device_preview.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';

import 'const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  // Timezone setup
  tz.initializeTimeZones();
  final String currentTimeZone =
      (await FlutterTimezone.getLocalTimezone()).identifier;
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  // Google OAuth setup
  final googleSource = sl<GoogleAuthSource>();
  await googleSource.init();

  final localeCubit = LocaleCubit();
  await localeCubit.loadSavedLocale();

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
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider<NutritionAssessmentCubit>(
          create: (context) => NutritionAssessmentCubit(sl<Dio>()),
        ),
        BlocProvider(create: (context) => AppointmentCubit(sl<Dio>())),
        BlocProvider(create: (context) => ProviderAppointmentCubit(sl<Dio>())),
        BlocProvider(
          create: (context) =>
              ScreeningAppointmentActionCubit(repository: sl()),
        ),
        BlocProvider(
            create: (context) => ProfileCubit(
                  getProfileUseCase: sl<GetProfile>(),
                  updateProfileUseCase: sl<UpdateProfile>(),
                  getProfessionalProfileUseCase: sl<GetProfessionalProfile>(),
                  updateProfessionalProfileUseCase:
                      sl<UpdateProfessionalProfile>(),
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
        BlocProvider(create: (context) => DiabetesFormCubit(sl<Dio>())),
        BlocProvider(create: (context) => sl<SubscriptionCubit>()),
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

// class AppSetting extends ChangeNotifier {
//   bool isDarkMode;
//   Color themeSeed = Colors.blue;

//   AppSetting({this.isDarkMode = false});

//   void changeThemeSeed(Color color) {
//     themeSeed = color;
//     notifyListeners();
//   }

//   void toggleTheme() {
//     isDarkMode = !isDarkMode;
//     notifyListeners();
//   }
// }

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
            padding: const EdgeInsets.only(bottom: 32),
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
    final currentIndex = navigationShell.currentIndex;

    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => navigationShell.goBranch(0),
            icon: const Icon(Icons.home_outlined),
            iconSize: 28,
            color: currentIndex == 0
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(1),
            icon: const Icon(Icons.calendar_month_outlined),
            iconSize: 28,
            color: currentIndex == 1
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(2),
            icon: const Icon(Icons.add_shopping_cart_outlined),
            iconSize: 28,
            color: currentIndex == 2
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(3),
            icon: const Icon(Icons.favorite_border_outlined),
            iconSize: 28,
            color: currentIndex == 3
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(4),
            icon: const Icon(Icons.person_outline),
            iconSize: 28,
            color: currentIndex == 4
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
        ],
      ),
    );
  }
}
