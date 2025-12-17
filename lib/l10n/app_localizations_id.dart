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
  String dashboard_greeting(String displayName) {
    return 'Live Longer & Live Healthier, $displayName!';
  }
}
