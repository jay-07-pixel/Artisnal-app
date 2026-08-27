import 'package:artisanal_lens/app/router.dart';
import 'package:artisanal_lens/data/datasources/preset_catalog.dart';
import 'package:artisanal_lens/domain/entities/shot_guidance.dart';
import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/features/capture/capture_session_controller.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:artisanal_lens/features/instruction/presentation/lighting_setup_page.dart';
import 'package:artisanal_lens/features/shot_type/presentation/shot_and_style_page.dart';
import 'package:artisanal_lens/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'support/test_l10n.dart';

class _SeededSession extends CaptureSessionController {
  _SeededSession(this._seed);

  final CaptureSession _seed;

  @override
  CaptureSession build() => _seed;
}

ShotSet _set({
  required String id,
  required String categoryId,
  required String productName,
}) =>
    ShotSet(
      id: id,
      productName: productName,
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 26),
    );

Widget _harness({
  required CaptureSession session,
  required String categoryId,
  required String productName,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      captureSessionProvider.overrideWith(() => _SeededSession(session)),
      shotSetProvider.overrideWith((ref, id) {
        return _set(id: id, categoryId: categoryId, productName: productName);
      }),
    ],
    child: l10nApp(home: child),
  );
}

Widget _sareePage({CaptureSession? session}) {
  return _harness(
    session: session ??
        const CaptureSession(
          setId: 'saree_1',
          shotType: ShotType.product,
          slotIndex: 0,
        ),
    categoryId: BundledCatalogDataSource.saree,
    productName: 'Test Saree',
    child: const ShotAndStylePage(setId: 'saree_1'),
  );
}

FilledButton _continueButton(WidgetTester tester) {
  return tester.widget<FilledButton>(
    find.widgetWithText(FilledButton, 'Continue'),
  );
}

void main() {
  const catalog = BundledCatalogDataSource();

  testWidgets('preset list displays the four Saree folds with catalog copy',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();

    expect(find.text('How should it look?'), findsOneWidget);
    expect(find.text('Pallu drape (hanger)', skipOffstage: false), findsOneWidget);
    expect(find.text('Box / flat fold', skipOffstage: false), findsOneWidget);
    expect(find.text('Worn drape (model)', skipOffstage: false), findsOneWidget);
    expect(find.text('Roll display', skipOffstage: false), findsOneWidget);
    final pallu = catalog.presetById('saree_pallu_drape')!;
    expect(find.text(pallu.purpose, skipOffstage: false), findsOneWidget);
    expect(
      find.text('Content: ${pallu.contentLabel}', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('Needs: ${pallu.needsLabel}', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Full Saree Display'), findsNothing);
    expect(find.text('Draped Look'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Continue stays disabled until a preset is selected',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();

    expect(_continueButton(tester).onPressed, isNull);

    await tester.tap(find.text('Pallu drape (hanger)'));
    await tester.pumpAndSettle();

    expect(_continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('tapping a card selects it and enables Continue', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_checked), findsNothing);

    await tester.tap(find.text('Box / flat fold'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(_continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('Saree fold cards show catalog copy without a details toggle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();

    final pallu = catalog.presetById('saree_pallu_drape')!;
    final card = find.byKey(const ValueKey('saree_pallu_drape'));
    expect(find.text('View photography details'), findsNothing);
    expect(find.descendant(of: card, matching: find.text(pallu.purpose)), findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text('Content: ${pallu.contentLabel}')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Needs: ${pallu.needsLabel}')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card,
        matching: find.text('Placement: ${pallu.setupSteps.first.instruction}'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card,
        matching: find.text('Lighting: ${pallu.technique.lighting.label}'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card,
        matching: find.text('Grid: ${pallu.technique.composition.label}'),
      ),
      findsOneWidget,
    );
    expect(_continueButton(tester).onPressed, isNull);
  });

  testWidgets('Cushion Shawl and Stole lists stay isolated', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const cases = <({
      String setId,
      String categoryId,
      String productName,
      List<String> names,
      List<String> absent,
    })>[
      (
        setId: 'cushion_ui',
        categoryId: BundledCatalogDataSource.cushionCover,
        productName: 'Test Cushion',
        names: [
          'Flat lay',
          'Stacked pair',
          'Propped on seating',
          'Corner tuck close-up',
        ],
        absent: ['Pallu drape (hanger)', 'Draped on shoulder', 'Neck wrap (worn)'],
      ),
      (
        setId: 'shawl_ui',
        categoryId: BundledCatalogDataSource.shawl,
        productName: 'Test Shawl',
        names: [
          'Draped on shoulder',
          'Folded stack',
          'Hung / pinned flat',
          'Corner tuck close-up',
        ],
        absent: ['Flat lay', 'Pallu drape (hanger)', 'Neck wrap (worn)'],
      ),
      (
        setId: 'stole_ui',
        categoryId: BundledCatalogDataSource.stole,
        productName: 'Test Stole',
        names: [
          'Neck wrap (worn)',
          'Flat spread',
          'Loose knot',
          'Rolled coil',
        ],
        absent: ['Pallu drape (hanger)', 'Flat lay', 'Draped on shoulder'],
      ),
    ];

    for (final item in cases) {
      await tester.pumpWidget(
        _harness(
          session: CaptureSession(
            setId: item.setId,
            shotType: ShotType.product,
            slotIndex: 0,
          ),
          categoryId: item.categoryId,
          productName: item.productName,
          child: ShotAndStylePage(setId: item.setId),
        ),
      );
      await tester.pumpAndSettle();

      for (final name in item.names) {
        expect(find.text(name, skipOffstage: false), findsOneWidget, reason: name);
      }
      for (final name in item.absent) {
        expect(find.text(name), findsNothing, reason: name);
      }
      expect(find.text('How should it look?'), findsOneWidget);
    }
  });

  testWidgets('fold cards do not overflow on a small phone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('How should it look?'), findsOneWidget);
    expect(find.text('Pallu drape (hanger)'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
  });

  testWidgets('Continue stays fixed and reachable at the bottom',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_sareePage());
    await tester.pumpAndSettle();

    final continueFinder = find.widgetWithText(FilledButton, 'Continue');
    expect(continueFinder, findsOneWidget);
    final buttonRect = tester.getRect(continueFinder);
    final scaffoldRect = tester.getRect(find.byType(Scaffold));
    expect(buttonRect.bottom, lessThanOrEqualTo(scaffoldRect.bottom + 0.5));
    expect(buttonRect.top, greaterThan(scaffoldRect.height / 2));

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(tester.getRect(continueFinder).top, buttonRect.top);
  });

  testWidgets('Continue still opens Lighting and setup', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/product/saree_1/shot',
      routes: [
        GoRoute(
          path: '/product/:setId/shot',
          name: AppRoute.shotAndStyle,
          builder: (context, state) => ShotAndStylePage(
            setId: state.pathParameters['setId']!,
          ),
        ),
        GoRoute(
          path: '/product/:setId/lighting',
          name: AppRoute.lightingSetup,
          builder: (context, state) => LightingSetupPage(
            setId: state.pathParameters['setId']!,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          captureSessionProvider.overrideWith(
            () => _SeededSession(
              const CaptureSession(
                setId: 'saree_1',
                shotType: ShotType.product,
                slotIndex: 0,
              ),
            ),
          ),
          shotSetProvider.overrideWith((ref, id) {
            return _set(
              id: id,
              categoryId: BundledCatalogDataSource.saree,
              productName: 'Test Saree',
            );
          }),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pallu = catalog.presetById('saree_pallu_drape')!;

    await tester.tap(find.text('Pallu drape (hanger)'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Lighting and setup'), findsOneWidget);
    expect(find.text('How should it look?'), findsNothing);
    expect(find.text(pallu.contentLabel, skipOffstage: false), findsOneWidget);
    expect(find.text(pallu.needsLabel!, skipOffstage: false), findsOneWidget);
    expect(
      find.text(pallu.setupSteps.first.instruction, skipOffstage: false),
      findsOneWidget,
    );
  });

  test('every fold preset carries source-backed content into session guidance',
      () {
    for (final category in catalog.categories()) {
      for (final preset in catalog.presetsForCategory(category.id)) {
        expect(preset.name, isNotEmpty, reason: preset.id);
        expect(preset.purpose, isNotEmpty, reason: preset.id);
        expect(preset.contentLabel, isNotEmpty, reason: preset.id);
        expect(preset.setupSteps, isNotEmpty, reason: preset.id);
        expect(preset.referenceImageAsset, startsWith('assets/images/presets/'));
        expect(
          preset.referenceImageAsset,
          contains('/${category.id.split('_').first}'),
        );

        final guidance = ShotGuidance.fromPreset(preset);
        expect(guidance.content, preset.contentLabel, reason: preset.id);
        expect(guidance.needs, preset.needsLabel, reason: preset.id);
        expect(
          guidance.placement,
          preset.setupSteps.first.instruction,
          reason: preset.id,
        );
        expect(guidance.technique, same(preset.technique), reason: preset.id);
        expect(
          catalog.presetById(preset.id)?.id,
          preset.id,
          reason: '${preset.id} must resolve from the catalog by id',
        );
      }
    }
  });

  testWidgets('every category card shows that catalog copy when expanded',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final category in catalog.categories()) {
      await tester.pumpWidget(
        _harness(
          session: CaptureSession(
            setId: '${category.id}_link',
            shotType: ShotType.product,
            slotIndex: 0,
          ),
          categoryId: category.id,
          productName: 'Test ${category.name}',
          child: ShotAndStylePage(setId: '${category.id}_link'),
        ),
      );
      await tester.pumpAndSettle();

      final presets = catalog.presetsForCategory(category.id);
      expect(presets, hasLength(4), reason: category.id);

      for (final preset in presets) {
        final card = find.byKey(ValueKey(preset.id));
        expect(card, findsOneWidget, reason: preset.id);
        expect(
          find.descendant(of: card, matching: find.text(preset.name)),
          findsOneWidget,
          reason: preset.id,
        );
        expect(
          find.descendant(of: card, matching: find.text(preset.purpose)),
          findsOneWidget,
          reason: preset.id,
        );
        expect(
          find.descendant(
            of: card,
            matching: find.text('Content: ${preset.contentLabel}'),
          ),
          findsOneWidget,
          reason: '${preset.id} content',
        );
        if (preset.needsLabel != null) {
          expect(
            find.descendant(
              of: card,
              matching: find.text('Needs: ${preset.needsLabel}'),
            ),
            findsOneWidget,
            reason: '${preset.id} needs',
          );
        }
        expect(
          find.descendant(
            of: card,
            matching: find.text('Placement: ${preset.setupSteps.first.instruction}'),
          ),
          findsOneWidget,
          reason: '${preset.id} placement',
        );
        expect(
          find.descendant(
            of: card,
            matching: find.text('Lighting: ${preset.technique.lighting.label}'),
          ),
          findsOneWidget,
          reason: '${preset.id} lighting',
        );
        expect(
          find.descendant(
            of: card,
            matching: find.text('Grid: ${preset.technique.composition.label}'),
          ),
          findsOneWidget,
          reason: '${preset.id} grid',
        );
      }
    }
  });
}
