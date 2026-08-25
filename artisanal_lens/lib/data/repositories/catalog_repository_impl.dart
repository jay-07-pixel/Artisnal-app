import '../../domain/entities/fold_preset.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/entities/shot_type.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/preset_catalog.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._source);

  final CatalogDataSource _source;

  @override
  List<ProductCategory> categories() {
    final all = [..._source.categories()]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return all;
  }

  @override
  ProductCategory? categoryById(String categoryId) {
    for (final category in _source.categories()) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  @override
  List<FoldPreset> presets({required String categoryId, ShotType? shotType}) {
    final forCategory = _source.presetsForCategory(categoryId);
    if (shotType == null) return forCategory;
    return forCategory.where((preset) => preset.supports(shotType)).toList();
  }

  @override
  FoldPreset? presetById(String presetId) => _source.presetById(presetId);
}
