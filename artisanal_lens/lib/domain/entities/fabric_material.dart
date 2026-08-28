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

  static const String silkId = 'silk';
  static const String cottonId = 'cotton';
  static const String woolId = 'wool';
  static const String juteId = 'jute';

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

/// Handloom cotton variety.
class CottonVariety extends Equatable {
  const CottonVariety({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
  final int sortOrder;

  static const khadi = CottonVariety(
    id: 'khadi',
    name: 'Khadi',
    thumbnailAsset: 'assets/images/cotton_types/khadi.png',
    sortOrder: 0,
  );

  static const muslin = CottonVariety(
    id: 'muslin',
    name: 'Muslin',
    thumbnailAsset: 'assets/images/cotton_types/muslin.png',
    sortOrder: 1,
  );

  static const handloom = CottonVariety(
    id: 'handloom',
    name: 'Handloom',
    thumbnailAsset: 'assets/images/cotton_types/handloom.png',
    sortOrder: 2,
  );

  static const jamdani = CottonVariety(
    id: 'jamdani',
    name: 'Jamdani',
    thumbnailAsset: 'assets/images/cotton_types/jamdani.png',
    sortOrder: 3,
  );

  static const List<CottonVariety> all = [khadi, muslin, handloom, jamdani];

  static CottonVariety? byId(String id) {
    for (final variety in all) {
      if (variety.id == id) return variety;
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}

/// Wool variety common in Northeast handloom products.
class WoolVariety extends Equatable {
  const WoolVariety({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
  final int sortOrder;

  static const pashmina = WoolVariety(
    id: 'pashmina',
    name: 'Pashmina',
    thumbnailAsset: 'assets/images/wool_types/pashmina.png',
    sortOrder: 0,
  );

  static const angora = WoolVariety(
    id: 'angora',
    name: 'Angora',
    thumbnailAsset: 'assets/images/wool_types/angora.png',
    sortOrder: 1,
  );

  static const merino = WoolVariety(
    id: 'merino',
    name: 'Merino',
    thumbnailAsset: 'assets/images/wool_types/merino.png',
    sortOrder: 2,
  );

  static const handspun = WoolVariety(
    id: 'handspun',
    name: 'Handspun',
    thumbnailAsset: 'assets/images/wool_types/handspun.png',
    sortOrder: 3,
  );

  static const List<WoolVariety> all = [pashmina, angora, merino, handspun];

  static WoolVariety? byId(String id) {
    for (final variety in all) {
      if (variety.id == id) return variety;
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}

/// Jute variety for bags, mats and blended textiles.
class JuteVariety extends Equatable {
  const JuteVariety({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String thumbnailAsset;
  final int sortOrder;

  static const golden = JuteVariety(
    id: 'golden',
    name: 'Golden',
    thumbnailAsset: 'assets/images/jute_types/golden.png',
    sortOrder: 0,
  );

  static const tossa = JuteVariety(
    id: 'tossa',
    name: 'Tossa',
    thumbnailAsset: 'assets/images/jute_types/tossa.png',
    sortOrder: 1,
  );

  static const hessian = JuteVariety(
    id: 'hessian',
    name: 'Hessian',
    thumbnailAsset: 'assets/images/jute_types/hessian.png',
    sortOrder: 2,
  );

  static const blended = JuteVariety(
    id: 'blended',
    name: 'Blended',
    thumbnailAsset: 'assets/images/jute_types/blended.png',
    sortOrder: 3,
  );

  static const List<JuteVariety> all = [golden, tossa, hessian, blended];

  static JuteVariety? byId(String id) {
    for (final variety in all) {
      if (variety.id == id) return variety;
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}
