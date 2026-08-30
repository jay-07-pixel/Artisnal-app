import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/locale_controller.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_dimens.dart';
import 'app/theme/app_theme.dart';
import 'data/datasources/app_database.dart';
import 'data/services/supabase_initializer.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The design is portrait-only; the capture guidance assumes it.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeSupabase();
  final database = await AppDatabase.open();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const ArtisanalLensApp(),
    ),
  );
}

class ArtisanalLensApp extends ConsumerStatefulWidget {
  const ArtisanalLensApp({super.key});

  @override
  ConsumerState<ArtisanalLensApp> createState() => _ArtisanalLensAppState();
}

class _ArtisanalLensAppState extends ConsumerState<ArtisanalLensApp> {
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(localeProvider);

    return MaterialApp.router(
      key: ValueKey(language.code),
      title: lookupAppLocalizations(language.locale).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: _router,
      builder: (context, child) => _PhoneFrame(child: child),
    );
  }
}

/// Keeps the phone-shaped layout phone-shaped on a desktop browser.
///
/// Every screen here is designed for a portrait handset. Stretched across a
/// 1600px window the ghost frame, the shutter and the checklist all drift
/// apart, so on a wide viewport the app is centred at phone width against a
/// muted backdrop. On an actual phone — and on Android — this does nothing.
class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  static const double _maxWidth = 480;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final content = child ?? const SizedBox.shrink();
    final width = MediaQuery.sizeOf(context).width;
    if (width <= _maxWidth) return content;

    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          child: SizedBox(width: _maxWidth, child: content),
        ),
      ),
    );
  }
}
