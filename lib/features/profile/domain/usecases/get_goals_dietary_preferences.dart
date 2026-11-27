import '../entities/goals_dietary_preferences.dart';
import '../repositories/goals_dietary_repository.dart';

/// Loads saved Goals & Dietary Preferences if available.
class GetGoalsDietaryPreferences {
  const GetGoalsDietaryPreferences(this._repository);

  final GoalsDietaryRepository _repository;

  Future<GoalsDietaryPreferences?> call({required String userId}) =>
      _repository.getSavedPreferences(userId: userId);
}
