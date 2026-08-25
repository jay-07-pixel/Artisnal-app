import 'package:artisanal_lens/domain/entities/shot_set.dart';
import 'package:artisanal_lens/domain/entities/shot_type.dart';
import 'package:flutter_test/flutter_test.dart';

ShotSet emptySet() => ShotSet(
      id: 'set_1',
      productName: 'Blue Silk Saree',
      categoryId: 'saree',
      createdAt: DateTime(2026, 8, 24, 10),
    );

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
      expect(set.requiredCount, 7);
      expect(set.completionRatio, 0);
      expect(set.isFinished, isFalse);
      expect(set.slots.length, 7);
      expect(set.slots.every((slot) => !slot.isFilled), isTrue);
    });

    test('counts only the photographs actually taken', () {
      final set = emptySet().copyWith(
        shots: [shot(ShotType.detail, 0), shot(ShotType.detail, 2)],
      );

      expect(set.completedCount, 2);
      expect(set.completedCountFor(ShotType.detail), 2);
      expect(set.completedCountFor(ShotType.process), 0);
      expect(set.completionRatio, closeTo(2 / 7, 0.001));
      expect(set.isFinished, isFalse);
    });

    test('is finished only when all seven slots are filled', () {
      final all = <CapturedShot>[];
      for (final type in ShotType.values) {
        for (var i = 0; i < type.requiredCount; i++) {
          all.add(shot(type, i));
        }
      }
      final set = emptySet().copyWith(shots: all);

      expect(set.completedCount, 7);
      expect(set.isFinished, isTrue);
      expect(set.completionRatio, 1);
      expect(set.nextSlot, isNull);
      expect(set.slots.every((slot) => slot.isFilled), isTrue);
    });
  });

  group('next slot suggestion', () {
    test('a fresh set is steered to the Product hero shot first', () {
      // The setup screen marks PRODUCT as "RECOMMENDED NEXT" on a new set.
      final next = emptySet().nextSlot;

      expect(next, isNotNull);
      expect(next!.shotType, ShotType.product);
      expect(next.index, 0);
      expect(next.label, 'Hero shot');
    });

    test('moves to Detail once the product shot is taken', () {
      final set = emptySet().copyWith(shots: [shot(ShotType.product, 0)]);

      expect(set.nextSlot!.shotType, ShotType.detail);
      expect(set.nextSlot!.label, 'Border');
    });

    test('skips slots already filled within a type', () {
      final set = emptySet().copyWith(
        shots: [
          shot(ShotType.product, 0),
          shot(ShotType.detail, 0),
          shot(ShotType.detail, 1),
        ],
      );

      expect(set.nextSlot!.shotType, ShotType.detail);
      expect(set.nextSlot!.index, 2);
      expect(set.nextSlot!.label, 'Motif');
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
          shot(ShotType.product, 0, minute: 5),
          shot(ShotType.detail, 0, minute: 30),
          shot(ShotType.process, 0, minute: 12),
        ],
      );

      expect(set.coverShot!.shotType, ShotType.detail);
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

  group('gallery filtering', () {
    test('"All" matches every set', () {
      expect(const GalleryFilter.all().matches(emptySet()), isTrue);
    });

    test('a category filter matches only that category', () {
      const filter = GalleryFilter.category('saree');

      expect(filter.matches(emptySet()), isTrue);
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
