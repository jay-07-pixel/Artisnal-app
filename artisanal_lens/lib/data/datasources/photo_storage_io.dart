import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'photo_storage.dart';

PhotoStorage createPhotoStorage() => const IoPhotoStorage();

/// Android and iOS: photographs are files, and the handle is the path.
class IoPhotoStorage implements PhotoStorage {
  const IoPhotoStorage();

  static const String albumName = 'The Artisanal Lens';

  @override
  bool get hasDeviceGallery => true;

  @override
  Future<String> persist(String capturedPath, {required String setId}) async {
    // The camera writes into a cache directory the OS may clear, so the
    // photograph is copied somewhere durable before it is recorded.
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(directory.path, 'photos'));
    if (!photosDir.existsSync()) {
      photosDir.createSync(recursive: true);
    }

    final fileName = '${setId}_${DateTime.now().millisecondsSinceEpoch}'
        '${p.extension(capturedPath)}';
    final destination = p.join(photosDir.path, fileName);
    await File(capturedPath).copy(destination);
    return destination;
  }

  @override
  Future<String> persistBytes(
    Uint8List bytes, {
    required String setId,
    required String shotId,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(directory.path, 'photos'));
    if (!photosDir.existsSync()) {
      photosDir.createSync(recursive: true);
    }

    final destination = p.join(photosDir.path, '${setId}_$shotId.jpg');
    await File(destination).writeAsBytes(bytes, flush: true);
    return destination;
  }

  @override
  ImageProvider? imageProvider(String handle) {
    if (handle.startsWith('assets/')) return AssetImage(handle);
    final file = File(handle);
    return file.existsSync() ? FileImage(file) : null;
  }

  @override
  Future<Uint8List?> readBytes(String handle) async {
    final file = File(handle);
    if (!file.existsSync()) return null;
    return file.readAsBytes();
  }

  @override
  Future<bool> saveToDeviceGallery(String handle) async {
    // Non-fatal by design: the photograph is already in app storage, so a
    // refused gallery permission must not interrupt the shoot.
    try {
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) return false;
      }
      await Gal.putImage(handle, album: albumName);
      return true;
    } catch (error) {
      debugPrint('Could not save to device gallery: $error');
      return false;
    }
  }
}
