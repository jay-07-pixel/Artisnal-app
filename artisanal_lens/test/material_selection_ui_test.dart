import 'package:artisanal_lens/app/router.dart';
import 'package:artisanal_lens/features/checklist/presentation/material_selection_page.dart';
import 'package:artisanal_lens/features/checklist/presentation/product_setup_page.dart';
import 'package:artisanal_lens/features/checklist/presentation/silk_type_page.dart';
import 'package:artisanal_lens/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'support/test_l10n.dart';

FilledButton _continue(WidgetTester tester) {
  return tester.widget<FilledButton>(
    find.widgetWithText(FilledButton, 'Continue'),
  );
}

void main() {
  testWidgets('material page lists Silk Cotton Wool Jute', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(home: MaterialSelectionPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What material are\nyou working with?'), findsOneWidget);
    expect(find.text('Silk'), findsOneWidget);
    expect(find.text('Cotton'), findsOneWidget);
    expect(find.text('Wool'), findsOneWidget);
    expect(find.text('Jute'), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);
  });

  testWidgets('silk type page lists Mulberry Eri Tasar Muga', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(home: SilkTypePage(materialId: 'silk')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What type of silk\nare you using?'), findsOneWidget);
    expect(find.text('Mulberry'), findsOneWidget);
    expect(find.text('Eri'), findsOneWidget);
    expect(find.text('Tasar'), findsOneWidget);
    expect(find.text('Muga'), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);

    await tester.tap(find.text('Muga'));
    await tester.pumpAndSettle();
    expect(_continue(tester).onPressed, isNotNull);
  });

  testWidgets('cotton type page lists Khadi Muslin Handloom Jamdani',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(home: SilkTypePage(materialId: 'cotton')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What type of cotton\nare you using?'), findsOneWidget);
    expect(find.text('Khadi'), findsOneWidget);
    expect(find.text('Muslin'), findsOneWidget);
    expect(find.text('Handloom'), findsOneWidget);
    expect(find.text('Jamdani'), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);

    await tester.tap(find.text('Handloom'));
    await tester.pumpAndSettle();
    expect(_continue(tester).onPressed, isNotNull);
  });

  testWidgets('wool type page lists Pashmina Angora Merino Handspun',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(home: SilkTypePage(materialId: 'wool')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What type of wool\nare you using?'), findsOneWidget);
    expect(find.text('Pashmina'), findsOneWidget);
    expect(find.text('Angora'), findsOneWidget);
    expect(find.text('Merino'), findsOneWidget);
    expect(find.text('Handspun'), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);
  });

  testWidgets('jute type page lists Golden Tossa Hessian Blended',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(home: SilkTypePage(materialId: 'jute')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What type of jute\nare you using?'), findsOneWidget);
    expect(find.text('Golden'), findsOneWidget);
    expect(find.text('Tossa'), findsOneWidget);
    expect(find.text('Hessian'), findsOneWidget);
    expect(find.text('Blended'), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);
  });

  testWidgets('Silk continue opens silk types; Cotton opens cotton types',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/product/material',
      routes: [
        GoRoute(
          path: '/product/material',
          name: AppRoute.material,
          builder: (context, state) => const MaterialSelectionPage(),
        ),
        GoRoute(
          path: '/product/silk-type',
          name: AppRoute.silkType,
          builder: (context, state) => SilkTypePage(
            materialId: state.uri.queryParameters['material'],
          ),
        ),
        GoRoute(
          path: '/product/setup',
          name: AppRoute.productSetup,
          builder: (context, state) => ProductSetupPage(
            materialId: state.uri.queryParameters['material'],
            silkTypeId: state.uri.queryParameters['silkType'],
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Silk'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What type of silk\nare you using?'), findsOneWidget);
    expect(find.text('Mulberry'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cotton'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What type of cotton\nare you using?'), findsOneWidget);
    expect(find.text('Khadi'), findsOneWidget);
    expect(find.text('Saree'), findsNothing);
    expect(find.text('Mulberry'), findsNothing);
    expect(_continue(tester).onPressed, isNull);
  });
}
