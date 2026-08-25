import '../entities/fold_preset.dart';
import '../entities/product_category.dart';
import '../entities/shot_type.dart';

/// Read access to the category and preset catalogue.
abstract interface class CatalogRepository {
  /// All product categories, in display order.
  List<ProductCategory> categories();

  ProductCategory? categoryById(String categoryId);

  /// Presets for a category, optionally narrowed to those that support a
  /// particular shot type.
  ///
  /// Filtering here is what makes the flow "category-first": everything past
  /// step 1 is scoped to the chosen category.
  List<FoldPreset> presets({required String categoryId, ShotType? shotType});

  FoldPreset? presetById(String presetId);
}
