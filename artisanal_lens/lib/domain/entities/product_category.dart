import 'package:equatable/equatable.dart';

/// A product type the artisan can photograph — the first choice in the flow.
///
/// Source: "The Artisanal Lens" deck § Step 1 — Category Selection. Modelled as
/// data rather than an enum so that new categories (dupattas, bedsheets, …) can
/// be added to the catalogue without reworking the app, which the deck calls
/// out explicitly under "Presets can be product-specific".
class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.thumbnailAsset,
    required this.sortOrder,
  });

  /// Stable identifier used to key presets and persisted shot sets.
  final String id;

  /// Display name, e.g. "Saree". Localised at the presentation layer.
  final String name;

  /// Illustrative thumbnail shown on the category card.
  final String thumbnailAsset;

  final int sortOrder;

  @override
  List<Object?> get props => [id, name, thumbnailAsset, sortOrder];
}
