// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tab_home => '主页';

  @override
  String dashboard_greeting(String displayName) {
    return 'Live Longer & Live Healthier, $displayName!';
  }
}
