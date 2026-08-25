
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'photo_storage.dart';

PhotoStorage createPhotoStorage() => WebPhotoStorage();

/// Browser: there is no filesystem, so photographs are held as bytes and the
/// handle is a key into that map.
///
/// The camera plugin hands back a `blob:` URL that the browser revokes when
/// the page reloads, so the bytes are read out of it immediately rather than
/// storing the URL. They live for the session only — a reload loses the
/// photographs while the shot records themselves survive in the database. That
/// is a genuine limitation of running this in a tab; the Android build keeps
/// both.
class WebPhotoStorage implements PhotoStorage {
  WebPhotoStorage();

  static const String _scheme = 'memory:';

  final Map<String, Uint8List> _photos = {};

  @override
  bool get hasDeviceGallery => false;

  @override
  Future<String> persist(String capturedPath, {required String setId}) async {
    final bytes = await XFile(capturedPath).readAsBytes();
    final handle =
        '$_scheme${setId}_${DateTime.now().millisecondsSinceEpoch}';
    _photos[handle] = bytes;
    return handle;
  }

  @override
  ImageProvider? imageProvider(String handle) {
    if (handle.startsWith('assets/')) return AssetImage(handle);
    final bytes = _photos[handle];
    if (bytes != null) return MemoryImage(bytes);
    // A photograph straight off the camera, not yet accepted: the plugin hands
    // back a blob: URL, which the browser can load directly. This is what the
    // review screen previews before "Use Photo" persists the bytes.
    if (handle.startsWith('blob:') || handle.startsWith('http')) {
      return NetworkImage(handle);
    }
    return null;
  }

  @override
  Future<Uint8List?> readBytes(String handle) async => _photos[handle];

  @override
  Future<bool> saveToDeviceGallery(String handle) async {
    // A browser tab cannot write to the phone's gallery. Reporting false keeps
    // the "saved to your gallery" claim off the completion screen.
    debugPrint('Device gallery is not available on the web build.');
    return false;
  }
}
