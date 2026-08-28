import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers the artisan's display name on this device.
class UserProfileController extends Notifier<String?> {
  static const String _prefsKey = 'artisan_display_name';

  SharedPreferences? _prefs;

  @override
  String? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getString(_prefsKey)?.trim();
    if (stored != null && stored.isNotEmpty) {
      state = stored;
    }
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      await clearName();
      return;
    }
    state = trimmed;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_prefsKey, trimmed);
  }

  Future<void> clearName() async {
    state = null;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_prefsKey);
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileController, String?>(UserProfileController.new);
