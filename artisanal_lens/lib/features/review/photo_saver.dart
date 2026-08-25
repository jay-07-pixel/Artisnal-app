import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

/// Writes accepted photographs into the phone's own gallery.
///
/// The report specifies that images are saved "both within the app and in the
/// artisan's mobile gallery" so they can be shared straight to WhatsApp or a
/// marketplace listing without going through this app.
abstract final class PhotoSaver {
  static const String albumName = 'The Artisanal Lens';

  /// Returns true when the copy in the device gallery was written.
  ///
  /// A failure here is deliberately non-fatal: the photograph is already in
  /// app storage, so the shoot continues either way.
  static Future<bool> saveToDeviceGallery(String filePath) async {
    try {
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) return false;
      }
      await Gal.putImage(filePath, album: albumName);
      return true;
    } catch (error) {
      debugPrint('Could not save to device gallery: $error');
      return false;
    }
  }
}
