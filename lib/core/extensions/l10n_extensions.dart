import 'package:flutter/widgets.dart';
import 'package:m2health/l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}