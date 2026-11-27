import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for local Goals & Dietary Preferences persistence.
abstract class GoalsDietaryLocalDataSource {
  Future<String?> readRawPreferences({required String userId});

  Future<void> writeRawPreferences({
    required String userId,
    required String encodedJson,
  });
}

/// Persists Goals & Dietary Preferences in [SharedPreferences] with a safe
/// in-memory fallback when platform channels are unavailable.
class SharedPrefsGoalsDietaryLocalDataSource
    implements GoalsDietaryLocalDataSource {
  static const _storageKeyPrefix = 'profile.goals_dietary_preferences.v1.';

  SharedPreferences? _preferences;
  final Map<String, String> _inMemoryFallback = {};

  @override
  Future<String?> readRawPreferences({required String userId}) async {
    final key = _keyFor(userId);
    final prefs = await _loadPreferences();
    if (prefs == null) return _inMemoryFallback[userId];
    return prefs.getString(key) ?? _inMemoryFallback[userId];
  }

  @override
  Future<void> writeRawPreferences({
    required String userId,
    required String encodedJson,
  }) async {
    final key = _keyFor(userId);
    _inMemoryFallback[userId] = encodedJson;
    final prefs = await _loadPreferences();
    await prefs?.setString(key, encodedJson);
  }

  String _keyFor(String userId) {
    final normalizedUserId = userId.trim().toLowerCase();
    if (normalizedUserId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    return '$_storageKeyPrefix$normalizedUserId';
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
