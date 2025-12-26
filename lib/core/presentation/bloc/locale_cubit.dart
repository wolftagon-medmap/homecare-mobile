import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences prefs;
  static const String _key = 'language_code';

  // Load saved language or default to 'en'
  LocaleCubit(this.prefs) : super(Locale(prefs.getString(_key) ?? 'en'));

  Future<void> changeLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      log('Unsupported locale: ${locale.languageCode}',
          name: 'LocaleCubit', level: 900);
      return;
    }
    await prefs.setString(_key, locale.languageCode);
    emit(locale);
  }
}
