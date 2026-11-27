import '../entities/goals_dietary_preferences.dart';

/// Contract for loading and saving Goals & Dietary Preferences.
abstract interface class GoalsDietaryRepository {
  /// Returns previously saved preferences, or `null` when none exist yet.
  Future<GoalsDietaryPreferences?> getSavedPreferences({
    required String userId,
  });

  /// Persists [preferences] to local/remote storage.
  Future<void> savePreferences({
    required String userId,
    required GoalsDietaryPreferences preferences,
  });
}
