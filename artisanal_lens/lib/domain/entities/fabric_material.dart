import 'package:equatable/equatable.dart';

/// Fibre the artisan is photographing, chosen before product category.
class FabricMaterial extends Equatable {
  const FabricMaterial({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
  final int sortOrder;

  bool get asksSilkType => id == silkId;

  /// Cotton, Wool and Jute use the type page too, with empty slots until
  /// varieties are documented.
  static const int placeholderTypeCount = 4;

  static const String silkId = 'silk';

  static const silk = FabricMaterial(
    id: silkId,
    name: 'Silk',
    thumbnailAsset: 'assets/images/materials/silk.png',
    sortOrder: 0,
  );

  static const cotton = FabricMaterial(
    id: 'cotton',
    name: 'Cotton',
    thumbnailAsset: 'assets/images/materials/cotton.png',
    sortOrder: 1,
  );

  static const wool = FabricMaterial(
    id: 'wool',
    name: 'Wool',
    thumbnailAsset: 'assets/images/materials/wool.png',
    sortOrder: 2,
  );

  static const jute = FabricMaterial(
    id: 'jute',
    name: 'Jute',
    thumbnailAsset: 'assets/images/materials/jute.png',
    sortOrder: 3,
  );

  static const List<FabricMaterial> all = [silk, cotton, wool, jute];

  static FabricMaterial? byId(String id) {
    for (final material in all) {
      if (material.id == id) return material;
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}

/// Assam / Indian silk variety, asked only after Silk is chosen.
class SilkVariety extends Equatable {
  const SilkVariety({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
  final int sortOrder;

  static const mulberry = SilkVariety(
    id: 'mulberry',
    name: 'Mulberry',
    thumbnailAsset: 'assets/images/silk_types/mulberry.png',
    sortOrder: 0,
  );

  static const eri = SilkVariety(
    id: 'eri',
    name: 'Eri',
    thumbnailAsset: 'assets/images/silk_types/eri.png',
    sortOrder: 1,
  );

  static const tasar = SilkVariety(
    id: 'tasar',
    name: 'Tasar',
    thumbnailAsset: 'assets/images/silk_types/tasar.png',
    sortOrder: 2,
  );

  static const muga = SilkVariety(
    id: 'muga',
    name: 'Muga',
    thumbnailAsset: 'assets/images/silk_types/muga.png',
    sortOrder: 3,
  );

  static const List<SilkVariety> all = [mulberry, eri, tasar, muga];

  static SilkVariety? byId(String id) {
    for (final variety in all) {
      if (variety.id == id) return variety;
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}
