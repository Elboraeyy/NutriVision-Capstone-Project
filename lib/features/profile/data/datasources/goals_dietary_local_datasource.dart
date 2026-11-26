import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for local Goals & Dietary Preferences persistence.
abstract class GoalsDietaryLocalDataSource {
  Future<String?> readRawPreferences();

  Future<void> writeRawPreferences(String encodedJson);
}

/// Persists Goals & Dietary Preferences in [SharedPreferences] with a safe
/// in-memory fallback when platform channels are unavailable.
class SharedPrefsGoalsDietaryLocalDataSource
    implements GoalsDietaryLocalDataSource {
  static const _storageKey = 'profile.goals_dietary_preferences.v1';

  SharedPreferences? _preferences;
  String? _inMemoryFallback;

  @override
  Future<String?> readRawPreferences() async {
    final prefs = await _loadPreferences();
    if (prefs == null) return _inMemoryFallback;
    return prefs.getString(_storageKey) ?? _inMemoryFallback;
  }

  @override
  Future<void> writeRawPreferences(String encodedJson) async {
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
