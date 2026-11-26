import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for local privacy preference persistence.
abstract class PrivacyDataLocalDataSource {
  Future<String?> readRawSettings();

  Future<void> writeRawSettings(String encodedJson);
}

/// Persists privacy preferences in [SharedPreferences] with an in-memory
/// fallback when platform channels are unavailable.
class SharedPrefsPrivacyDataLocalDataSource
    implements PrivacyDataLocalDataSource {
  static const _storageKey = 'profile.privacy_settings.v1';

  SharedPreferences? _preferences;
  String? _inMemoryFallback;

  @override
  Future<String?> readRawSettings() async {
    final prefs = await _loadPreferences();
    if (prefs == null) return _inMemoryFallback;
    return prefs.getString(_storageKey) ?? _inMemoryFallback;
  }

  @override
  Future<void> writeRawSettings(String encodedJson) async {
    _inMemoryFallback = encodedJson;
    final prefs = await _loadPreferences();
    await prefs?.setString(_storageKey, encodedJson);
  }

  Future<SharedPreferences?> _loadPreferences() async {
    if (_preferences != null) return _preferences;
    try {
      _preferences = await SharedPreferences.getInstance();
      return _preferences;
    } catch (_) {
      return null;
    }
  }
}
