import '../../app/supabase_config.dart';
import '../../domain/entities/tutorial_catalog_entry.dart';
import 'supabase_initializer.dart';

/// Reads tutorial names, transcripts, and image keys from Supabase.
class TutorialCatalogService {
  static const _table = 'tutorial_videos';

  Future<TutorialCatalogEntry?> fetchByPresetId(String presetId) async {
    final client = supabaseClient;
    if (client == null) return null;

    final row = await client
        .from(_table)
        .select()
        .eq('preset_id', presetId)
        .maybeSingle();
    if (row == null) return null;
    return TutorialCatalogEntry.fromJson(row);
  }

  Future<List<TutorialCatalogEntry>> fetchAll() async {
    final client = supabaseClient;
    if (client == null) return const [];

    final rows = await client
        .from(_table)
        .select()
        .order('sort_order', ascending: true);
    return rows
        .map((row) => TutorialCatalogEntry.fromJson(row))
        .toList(growable: false);
  }

  /// Public URL for a step image or thumbnail in the `tutorial-images` bucket.
  String? publicImageUrl(String? storageKey) {
    final key = storageKey?.trim();
    if (key == null || key.isEmpty || !SupabaseConfig.isConfigured) {
      return null;
    }
    return '${SupabaseConfig.url}/storage/v1/object/public/'
        '${SupabaseConfig.tutorialImagesBucket}/$key';
  }
}
