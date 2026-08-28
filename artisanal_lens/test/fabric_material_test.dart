import 'package:artisanal_lens/domain/entities/fabric_material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('four materials match the New Product grid', () {
    expect(
      FabricMaterial.all.map((material) => material.name).toList(),
      ['Silk', 'Cotton', 'Wool', 'Jute'],
    );
  });

  test('silk types are documented', () {
    expect(
      SilkVariety.all.map((variety) => variety.name).toList(),
      ['Mulberry', 'Eri', 'Tasar', 'Muga'],
    );
    expect(SilkVariety.byId('eri')?.name, 'Eri');
    expect(SilkVariety.byId('cotton'), isNull);
  });

  test('cotton wool and jute types are documented', () {
    expect(
      CottonVariety.all.map((variety) => variety.name).toList(),
      ['Khadi', 'Muslin', 'Handloom', 'Jamdani'],
    );
    expect(
      WoolVariety.all.map((variety) => variety.name).toList(),
      ['Pashmina', 'Angora', 'Merino', 'Handspun'],
    );
    expect(
      JuteVariety.all.map((variety) => variety.name).toList(),
      ['Golden', 'Tossa', 'Hessian', 'Blended'],
    );
  });
}
