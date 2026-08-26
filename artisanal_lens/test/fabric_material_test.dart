import 'package:artisanal_lens/domain/entities/fabric_material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('four materials match the New Product grid', () {
    expect(
      FabricMaterial.all.map((material) => material.name).toList(),
      ['Silk', 'Cotton', 'Wool', 'Jute'],
    );
    expect(FabricMaterial.silk.asksSilkType, isTrue);
    expect(FabricMaterial.cotton.asksSilkType, isFalse);
    expect(FabricMaterial.wool.asksSilkType, isFalse);
    expect(FabricMaterial.jute.asksSilkType, isFalse);
    expect(FabricMaterial.placeholderTypeCount, 4);
  });

  test('silk types are asked only after Silk', () {
    expect(
      SilkVariety.all.map((variety) => variety.name).toList(),
      ['Mulberry', 'Eri', 'Tasar', 'Muga'],
    );
    expect(SilkVariety.byId('eri')?.name, 'Eri');
    expect(SilkVariety.byId('cotton'), isNull);
  });
}
