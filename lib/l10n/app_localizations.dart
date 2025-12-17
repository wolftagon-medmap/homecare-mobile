import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('zh')
  ];

  /// Label for the home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// Services
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Label for the Allied Health services
  ///
  /// In en, this message translates to:
  /// **'Allied Health'**
  String get allied_services;

  /// Label for the iRX Pharmacist Service
  ///
  /// In en, this message translates to:
  /// **'iRX Pharmacist Service'**
  String get pharmacist_services;

  /// Label for the Home Nursing service
  ///
  /// In en, this message translates to:
  /// **'Home Nursing'**
  String get nursing_service;

  /// Label for the Diabetic Care service
  ///
  /// In en, this message translates to:
  /// **'Diabetic Care'**
  String get diabetic_care_service;

  /// Label for the Home Health Screening service
  ///
  /// In en, this message translates to:
  /// **'Home Health Screening'**
  String get home_screening_service;

  /// Label for the Precision Nutrition service
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition'**
  String get precision_nutrition_service;

  /// Label for the Home Care for Elderly service
  ///
  /// In en, this message translates to:
  /// **'Home Care for Elderly'**
  String get homecare_for_elderly_service;

  /// Label for the Physiotherapy service
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy'**
  String get physiotherapy_service;

  /// Label for the Remote Patient Monitoring service
  ///
  /// In en, this message translates to:
  /// **'Remote Patient Monitoring'**
  String get remote_patient_monitoring_service;

  /// Label for the 2nd Opinion for Medical Image service
  ///
  /// In en, this message translates to:
  /// **'2nd Opinion for Medical Image'**
  String get second_opinion_service;

  /// Label for the Health Risk Assessment service
  ///
  /// In en, this message translates to:
  /// **'Health Risk Assessment'**
  String get health_risk_assessment_service;

  /// Label for the Dietitian Service
  ///
  /// In en, this message translates to:
  /// **'Dietitian Service'**
  String get dietitian_service;

  /// Label for the Sleep & Mental Health service
  ///
  /// In en, this message translates to:
  /// **'Sleep & Mental Health'**
  String get sleep_and_mental_health_service;

  /// Greeting message on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Live Longer & Live Healthier, {displayName}!'**
  String dashboard_greeting(String displayName);

  /// Placeholder text for the AI chat feature on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Chat With AI doctor for all your health questions'**
  String get dashboard_chat_ai_placeholder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
