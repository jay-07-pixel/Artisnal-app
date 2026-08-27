import 'package:artisanal_lens/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// MaterialApp wrapper that loads generated localizations.
///
/// Widget tests default to English so existing `find.text` assertions stay
/// valid. Hindi and Assamese are exercised in `locale_switch_test.dart`.
Widget l10nApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}
