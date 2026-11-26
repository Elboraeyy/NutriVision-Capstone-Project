import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for local notification settings persistence.
abstract class NotificationSettingsLocalDataSource {
  Future<String?> readRawSettings();

  Future<void> writeRawSettings(String encodedJson);
}

/// Persists notification settings in [SharedPreferences] with a safe in-memory
/// fallback when platform channels are unavailable.
class SharedPrefsNotificationSettingsLocalDataSource
    implements NotificationSettingsLocalDataSource {
  static const _storageKey = 'profile.notification_settings.v1';

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
