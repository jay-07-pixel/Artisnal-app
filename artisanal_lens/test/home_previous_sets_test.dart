import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:artisanal_lens/features/home/presentation/home_page.dart';
import 'package:artisanal_lens/features/home/shot_sets_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_l10n.dart';

class _SeededShotSets extends ShotSetsController {
  _SeededShotSets(this._sets);

  final List<ShotSet> _sets;

  @override
  Future<List<ShotSet>> build() async => _sets;
}

CapturedShot _shot(ShotType type, int slotIndex) => CapturedShot(
      id: '${type.id}_$slotIndex',
      setId: 'finished',
      shotType: type,
      slotIndex: slotIndex,
      filePath: '',
      capturedAt: DateTime(2025, 1, 22),
    );

ShotSet _pending() => ShotSet(
      id: 'pending',
      productName: 'Pending Shawl',
      categoryId: 'shawl',
      createdAt: DateTime(2025, 1, 15),
    );

ShotSet _finished() {
  final shots = <CapturedShot>[
    for (var i = 0; i < 5; i++) _shot(ShotType.photography, i),
  ];
  return ShotSet(
    id: 'finished',
    productName: 'Finished Saree',
    categoryId: 'cushion_cover',
    createdAt: DateTime(2025, 1, 22),
    shots: shots,
  );
}

Widget _harness(List<ShotSet> sets) {
  return ProviderScope(
    overrides: [
      shotSetsProvider.overrideWith(() => _SeededShotSets(sets)),
    ],
    child: l10nApp(home: const Scaffold(body: HomePage())),
  );
}

void main() {
  testWidgets('Previous sets lists products below New Product', (tester) async {
    await tester.pumpWidget(_harness([_pending(), _finished()]));
    await tester.pumpAndSettle();

    expect(find.text('New Product'), findsOneWidget);
    expect(find.text('Previous sets.'), findsOneWidget);
    expect(find.text('Pending Shawl'), findsOneWidget);
    expect(find.text('Finished Saree'), findsOneWidget);
    expect(find.text('15 Jan, 2025'), findsOneWidget);
    expect(find.text('22 Jan, 2025'), findsOneWidget);
  });

  testWidgets('Finished and Pending chips filter the list', (tester) async {
    await tester.pumpWidget(_harness([_pending(), _finished()]));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finished'));
    await tester.pumpAndSettle();
    expect(find.text('Finished Saree'), findsOneWidget);
    expect(find.text('Pending Shawl'), findsNothing);

    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();
    expect(find.text('Pending Shawl'), findsOneWidget);
    expect(find.text('Finished Saree'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Pending Shawl'), findsOneWidget);
    expect(find.text('Finished Saree'), findsOneWidget);
  });
}
