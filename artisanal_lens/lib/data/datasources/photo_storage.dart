import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'photo_storage_io.dart'
    if (dart.library.js_interop) 'photo_storage_web.dart' as impl;

/// Where accepted photographs live once the artisan keeps them.
///
/// The two platforms have nothing in common here: Android copies the file out
/// of the camera's temp directory into app storage and hands the path around,
/// while the browser has no filesystem at all and must keep the bytes. Every
/// screen that shows or exports a photograph goes through this interface so
/// neither of them leaks into the UI.
abstract interface class PhotoStorage {
  /// Moves a freshly captured photograph into permanent storage and returns
  /// the handle the rest of the app stores and passes around.
  Future<String> persist(String capturedPath, {required String setId});

  /// Writes downloaded cloud bytes into app storage.
  Future<String> persistBytes(
    Uint8List bytes, {
    required String setId,
    required String shotId,
  });

  /// The image to render for [handle], or null when it can no longer be read.
  ImageProvider? imageProvider(String handle);

  /// Raw bytes, for sharing. Null when the photograph is gone.
  Future<Uint8List?> readBytes(String handle);

  /// Copies the photograph into the device's own gallery.
  ///
  /// The BTP report asks for photographs to be saved "both within the app and
  /// in the artisan's mobile gallery" so they can be sent to WhatsApp without
  /// going through this app. There is no equivalent in a browser, so the web
  /// implementation reports false rather than pretending.
  Future<bool> saveToDeviceGallery(String handle);

  /// True when this platform can write to a device gallery at all, so the UI
  /// can word itself honestly.
  bool get hasDeviceGallery;
}

/// The implementation for the platform this build targets.
PhotoStorage createPhotoStorage() => impl.createPhotoStorage();
