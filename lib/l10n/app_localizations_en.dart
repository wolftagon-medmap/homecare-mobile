// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tab_home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get allied_services => 'Allied Health';

  @override
  String get pharmacist_services => 'iRX Pharmacist Service';

  @override
  String get nursing_service => 'Home Nursing';

  @override
  String get diabetic_care_service => 'Diabetic Care';

  @override
  String get home_screening_service => 'Home Health Screening';

  @override
  String get precision_nutrition_service => 'Precision Nutrition';

  @override
  String get homecare_for_elderly_service => 'Home Care for Elderly';

  @override
  String get physiotherapy_service => 'Physiotherapy';

  @override
  String get remote_patient_monitoring_service => 'Remote Patient Monitoring';

  @override
  String get second_opinion_service => '2nd Opinion for Medical Image';

  @override
  String get health_risk_assessment_service => 'Health Risk Assessment';

  @override
  String get dietitian_service => 'Dietitian Service';

  @override
  String get sleep_and_mental_health_service => 'Sleep & Mental Health';

  @override
  String dashboard_greeting(String displayName) {
    return 'Live Longer & Live Healthier, $displayName!';
  }

  @override
  String get dashboard_chat_ai_placeholder =>
      'Chat With AI doctor for all your health questions';
}
