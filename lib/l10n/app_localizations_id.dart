// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get tab_home => 'Beranda';

  @override
  String get services => 'Layanan Utama';

  @override
  String get allied_services => 'Layanan Kesehatan Penunjang';

  @override
  String get pharmacist_services => 'Layanan Apoteker iRX';

  @override
  String get nursing_service => 'Perawat ke Rumah';

  @override
  String get diabetic_care_service => 'Perawatan Diabetes';

  @override
  String get home_screening_service => 'Skrining Kesehatan di Rumah';

  @override
  String get precision_nutrition_service => 'Nutrisi Presisi';

  @override
  String get homecare_for_elderly_service => 'Perawatan Lansia di Rumah';

  @override
  String get physiotherapy_service => 'Fisioterapi';

  @override
  String get remote_patient_monitoring_service =>
      'Pemantauan Kesehatan Jarak Jauh';

  @override
  String get second_opinion_service => 'Pendapat Kedua Citra Medis';

  @override
  String get health_risk_assessment_service => 'Penilaian Risiko Kesehatan';

  @override
  String get dietitian_service => 'Layanan Ahli Gizi';

  @override
  String get sleep_and_mental_health_service => 'Tidur & Kesehatan Mental';

  @override
  String dashboard_greeting(String displayName) {
    return 'Hidup Lebih Lama & Sehat, $displayName!';
  }

  @override
  String get dashboard_chat_ai_placeholder =>
      'Tanya dokter AI seputar kesehatan Anda';
}
