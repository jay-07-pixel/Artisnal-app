import 'package:artisanal_lens/domain/entities/tutorial_catalog_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TutorialCatalogEntry parses Supabase row', () {
    final entry = TutorialCatalogEntry.fromJson({
      'preset_id': 'cushion_flat_lay',
      'category_id': 'cushion_cover',
      'name': 'Flat lay',
      'video_storage_key': 'cushion_flat_lay.mp4',
      'transcript': ['Line one', 'Line two'],
      'step_images': [
        {
          'title': 'Lay it flat',
          'instruction': 'Place flat.',
          'storage_key': 'cushion flat lay/cushion_flat_lay_howto_1.png',
          'bundled_asset': 'assets/images/steps/cushion_flat_lay_1.png',
        },
      ],
    });

    expect(entry.presetId, 'cushion_flat_lay');
    expect(entry.videoStorageKey, 'cushion_flat_lay.mp4');
    expect(entry.transcript, ['Line one', 'Line two']);
    expect(entry.stepImages.length, 1);
    expect(entry.stepImages.first.storageKey,
        'cushion flat lay/cushion_flat_lay_howto_1.png');
  });
}
