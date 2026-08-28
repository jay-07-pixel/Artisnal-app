import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/supabase_config.dart';

/// Resolves catalog tutorial video keys to Supabase Storage URLs and optional
/// on-device cache files after the first successful stream.
class TutorialVideoService {
  /// Storage object name, e.g. `cushion_propped.mp4`.
  ///
  /// Accepts legacy bundled paths like `assets/videos/cushion_propped.mp4`.
  static String? normalizeKey(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    if (trimmed.contains('/')) return trimmed.split('/').last;
    return trimmed;
  }

  /// Public HTTPS URL for streaming when Supabase is configured.
  Uri? publicUrlForKey(String? rawKey) {
    final key = normalizeKey(rawKey);
    if (key == null || !SupabaseConfig.isConfigured) return null;
    return Uri.parse(
      '${SupabaseConfig.url}/storage/v1/object/public/'
      '${SupabaseConfig.tutorialVideosBucket}/$key',
    );
  }

  Future<File> _cacheFile(String key) async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'tutorial_videos', key));
  }

  Future<File?> cachedFile(String? rawKey) async {
    final key = normalizeKey(rawKey);
    if (key == null) return null;
    final file = await _cacheFile(key);
    if (await file.exists()) return file;
    return null;
  }

  /// Saves the video locally after a successful stream for faster replays.
  Future<void> cacheFromUrl(String? rawKey, Uri url) async {
    final key = normalizeKey(rawKey);
    if (key == null) return;

    final file = await _cacheFile(key);
    if (await file.exists()) return;

    final client = HttpClient();
    try {
      final request = await client.getUrl(url);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) return;

      await file.parent.create(recursive: true);
      final sink = file.openWrite();
      await response.pipe(sink);
      await sink.close();
    } catch (_) {
      if (await file.exists()) {
        await file.delete();
      }
    } finally {
      client.close();
    }
  }
}
