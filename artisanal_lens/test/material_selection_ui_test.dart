import 'package:artisanal_lens/app/router.dart';
import 'package:artisanal_lens/features/checklist/presentation/material_selection_page.dart';
import 'package:artisanal_lens/features/checklist/presentation/product_setup_page.dart';
import 'package:artisanal_lens/features/checklist/presentation/silk_type_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
      const ProviderScope(
        child: MaterialApp(home: MaterialSelectionPage()),
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
      const ProviderScope(
        child: MaterialApp(home: SilkTypePage(materialId: 'silk')),
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

  for (final material in ['cotton', 'wool', 'jute']) {
    testWidgets('$material type page shows four empty boxes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: SilkTypePage(materialId: material)),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('What type of $material\nare you using?'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.image_outlined), findsNWidgets(4));
      expect(find.text('Mulberry'), findsNothing);
      expect(find.text('Saree'), findsNothing);
      expect(_continue(tester).onPressed, isNotNull);
    });
  }

  testWidgets('Silk continue opens silk types; Cotton opens empty type boxes',
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
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
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
    expect(find.text('Saree'), findsNothing);
    expect(find.text('Mulberry'), findsNothing);
    expect(find.byIcon(Icons.image_outlined), findsNWidgets(4));
    expect(_continue(tester).onPressed, isNotNull);
  });
}
