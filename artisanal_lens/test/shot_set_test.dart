import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:flutter_test/flutter_test.dart';

ShotSet emptySet({String categoryId = 'cushion_cover'}) => ShotSet(
      id: 'set_1',
      productName: 'Blue Silk Saree',
      categoryId: categoryId,
      createdAt: DateTime(2026, 8, 24, 10),
    );

ShotSet emptySareeSet() => emptySet(categoryId: 'saree');

CapturedShot shot(ShotType type, int slotIndex, {int minute = 0}) =>
    CapturedShot(
      id: '${type.id}_$slotIndex',
      setId: 'set_1',
      shotType: type,
      slotIndex: slotIndex,
      filePath: '/photos/${type.id}_$slotIndex.jpg',
      capturedAt: DateTime(2026, 8, 24, 10, minute),
    );

void main() {
  group('ShotType structure matches the Figma checklist', () {
    test('a complete set is seven photographs', () {
      expect(ShotType.totalRequired, 7);
    });

    test('each type requires the count shown on the setup screen', () {
      expect(ShotType.process.requiredCount, 2);
      expect(ShotType.product.requiredCount, 1);
      expect(ShotType.detail.requiredCount, 3);
      expect(ShotType.lifestyle.requiredCount, 1);
    });

    test('slots carry the captions used in the gallery', () {
      expect(ShotType.process.slotLabels, ['Loom setup', 'Dyeing']);
      expect(ShotType.detail.slotLabels, ['Border', 'Weave', 'Motif']);
    });
  });

  group('ShotSet progress', () {
    test('a new set is empty and unfinished', () {
      final set = emptySet();

      expect(set.completedCount, 0);
      expect(set.requiredCount, 5);
      expect(set.completionRatio, 0);
      expect(set.isFinished, isFalse);
      expect(set.slots.length, 5);
      expect(set.slots.every((slot) => !slot.isFilled), isTrue);
    });

    test('counts only the photographs actually taken', () {
      final set = emptySet().copyWith(
        shots: [
          shot(ShotType.photography, 0),
          shot(ShotType.photography, 2),
        ],
      );

      expect(set.completedCount, 2);
      expect(set.completedCountFor(ShotType.photography), 2);
      expect(set.completedCountFor(ShotType.process), 0);
      expect(set.completionRatio, closeTo(2 / 5, 0.001));
      expect(set.isFinished, isFalse);
    });

    test('is finished only when all five template slots are filled', () {
      final all = <CapturedShot>[
        for (var i = 0; i < 5; i++) shot(ShotType.photography, i),
      ];
      final set = emptySet().copyWith(shots: all);

      expect(set.completedCount, 5);
      expect(set.isFinished, isTrue);
      expect(set.completionRatio, 1);
      expect(set.nextSlot, isNull);
      expect(set.slots.every((slot) => slot.isFilled), isTrue);
    });
  });

  group('next slot suggestion', () {
    test('a fresh set is steered to the first photography template', () {
      final next = emptySet().nextSlot;

      expect(next, isNotNull);
      expect(next!.shotType, ShotType.photography);
      expect(next.index, 0);
      expect(next.label, 'Full Cover Display');
    });

    test('moves to the next template once the first is taken', () {
      final set = emptySet().copyWith(shots: [shot(ShotType.photography, 0)]);

      expect(set.nextSlot!.shotType, ShotType.photography);
      expect(set.nextSlot!.label, 'Texture & Weave');
    });

    test('skips slots already filled within a type', () {
      final set = emptySet().copyWith(
        shots: [
          shot(ShotType.photography, 0),
          shot(ShotType.photography, 1),
        ],
      );

      expect(set.nextSlot!.shotType, ShotType.photography);
      expect(set.nextSlot!.index, 2);
      expect(set.nextSlot!.label, 'Stacked Pair / Thickness');
    });

    test('nextSlotFor targets a specific type regardless of order', () {
      final set = emptySet().copyWith(shots: [shot(ShotType.process, 0)]);

      final next = set.nextSlotFor(ShotType.process);

      expect(next!.index, 1);
      expect(next.label, 'Dyeing');
    });

    test('nextSlotFor returns null when that type is complete', () {
      final set = emptySet().copyWith(shots: [shot(ShotType.lifestyle, 0)]);

      expect(set.nextSlotFor(ShotType.lifestyle), isNull);
    });
  });

  group('cover shot', () {
    test('is the most recently captured photograph', () {
      final set = emptySet().copyWith(
        shots: [
          shot(ShotType.photography, 0, minute: 5),
          shot(ShotType.photography, 1, minute: 30),
          shot(ShotType.photography, 2, minute: 12),
        ],
      );

      expect(set.coverShot!.shotType, ShotType.photography);
      expect(set.coverShot!.slotIndex, 1);
    });

    test('is null for an empty set', () {
      expect(emptySet().coverShot, isNull);
    });
  });

  group('slot labelling', () {
    test('a captured shot reports the caption for its slot', () {
      expect(shot(ShotType.detail, 1).slotLabel, 'Weave');
      expect(shot(ShotType.process, 0).slotLabel, 'Loom setup');
    });
  });

  group('Saree photography templates replace the seven-shot list', () {
    test('Saree requires exactly five BTP templates', () {
      final set = emptySareeSet();
      expect(set.requiredCount, 5);
      expect(set.slots.length, 5);
      expect(
        set.slots.map((slot) => slot.label).toList(),
        [
          'Full Saree Display',
          'Texture & Weave',
          'Draped Look',
          'Embroidery & Border Details',
          'Folded Stack / Saree Stack',
        ],
      );
      expect(
        set.slots.map((slot) => slot.label),
        isNot(contains('Hero shot')),
      );
      expect(
        set.slots.map((slot) => slot.label),
        isNot(contains('Loom setup')),
      );
    });

    test('Saree progress is 0/5 through 5/5', () {
      var set = emptySareeSet();
      expect(set.completedCount, 0);
      expect('${set.completedCount}/${set.requiredCount}', '0/5');

      for (var i = 0; i < 5; i++) {
        set = set.copyWith(
          shots: [
            ...set.shots,
            shot(ShotType.sareePhotography, i, minute: i),
          ],
        );
        expect('${set.completedCount}/${set.requiredCount}', '${i + 1}/5');
      }
      expect(set.isFinished, isTrue);
      expect(set.nextSlot, isNull);
    });

    test('replacing a Saree template slot does not add a duplicate', () {
      final first = shot(ShotType.sareePhotography, 0, minute: 1);
      final retake = CapturedShot(
        id: 'retake_full_display',
        setId: 'set_1',
        shotType: ShotType.sareePhotography,
        slotIndex: 0,
        filePath: '/photos/retake.jpg',
        capturedAt: DateTime(2026, 8, 24, 10, 20),
      );
      final set = emptySareeSet().copyWith(shots: [first, retake]);

      expect(set.slots, hasLength(5));
      expect(set.completedCount, 1);
      expect(set.slots.first.shot!.filePath, first.filePath);
    });
  });

  group('previous sets progress filter', () {
    ShotSet finishedSet() {
      final all = <CapturedShot>[
        for (var i = 0; i < 5; i++) shot(ShotType.photography, i),
      ];
      return emptySet().copyWith(shots: all);
    }

    test('All keeps finished and pending sets', () {
      final pending = emptySet();
      final finished = finishedSet();

      expect(
        PreviousSetsFilter.all.apply([pending, finished]),
        [pending, finished],
      );
    });

    test('Finished keeps only completed sets', () {
      final pending = emptySet();
      final finished = finishedSet();

      expect(PreviousSetsFilter.finished.matches(pending), isFalse);
      expect(PreviousSetsFilter.finished.matches(finished), isTrue);
      expect(PreviousSetsFilter.finished.apply([pending, finished]), [finished]);
    });

    test('Pending keeps only unfinished sets', () {
      final pending = emptySet();
      final finished = finishedSet();

      expect(PreviousSetsFilter.pending.matches(pending), isTrue);
      expect(PreviousSetsFilter.pending.matches(finished), isFalse);
      expect(PreviousSetsFilter.pending.apply([pending, finished]), [pending]);
    });

    test('formats the BTP card date', () {
      expect(formatPreviousSetDate(DateTime(2025, 1, 22)), '22 Jan, 2025');
      expect(formatPreviousSetDate(DateTime(2025, 1, 2)), '02 Jan, 2025');
    });
  });

  group('gallery filtering', () {
    test('"All" matches every set', () {
      expect(const GalleryFilter.all().matches(emptySet()), isTrue);
    });

    test('a category filter matches only that category', () {
      const filter = GalleryFilter.category('saree');

      expect(filter.matches(emptySareeSet()), isTrue);
      expect(filter.matches(emptySet()), isFalse);
      expect(
        filter.matches(
          ShotSet(
            id: 'set_2',
            productName: 'Cotton Stole',
            categoryId: 'stole',
            createdAt: DateTime(2026, 8, 24),
          ),
        ),
        isFalse,
      );
    });
  });
}
