import '../entities/goals_dietary_preferences.dart';

/// Contract for loading and saving Goals & Dietary Preferences.
abstract interface class GoalsDietaryRepository {
  /// Returns previously saved preferences, or `null` when none exist yet.
  Future<GoalsDietaryPreferences?> getSavedPreferences();

  /// Persists [preferences] to local/remote storage.
  Future<void> savePreferences(GoalsDietaryPreferences preferences);
}
