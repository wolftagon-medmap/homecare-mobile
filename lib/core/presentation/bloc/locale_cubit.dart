import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<AppLocale> {
  static const String _key = 'language_code';

  LocaleCubit() : super(LocaleSettings.currentLocale);

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final rawLocale = prefs.getString(_key);

    if (rawLocale != null) {
      final locale = AppLocale.values.firstWhere(
        (l) => l.languageCode == rawLocale,
        orElse: () => AppLocale.en,
      );
      changeLocale(locale);
    }
  }

  Future<void> changeLocale(AppLocale locale) async {
    LocaleSettings.setLocale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);

    emit(locale);
  }
}
