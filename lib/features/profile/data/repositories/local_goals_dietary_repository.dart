import '../../domain/entities/goals_dietary_preferences.dart';
import '../../domain/repositories/goals_dietary_repository.dart';
import '../datasources/goals_dietary_local_datasource.dart';
import '../models/goals_dietary_preferences_model.dart';

/// Local persistence repository for Goals & Dietary Preferences.
class LocalGoalsDietaryRepository implements GoalsDietaryRepository {
  LocalGoalsDietaryRepository({GoalsDietaryLocalDataSource? localDataSource})
    : _localDataSource =
          localDataSource ?? SharedPrefsGoalsDietaryLocalDataSource();

  final GoalsDietaryLocalDataSource _localDataSource;

  @override
  Future<GoalsDietaryPreferences?> getSavedPreferences({
    required String userId,
  }) async {
    final raw = await _localDataSource.readRawPreferences(userId: userId);
    return GoalsDietaryPreferencesModel.tryDecode(raw);
  }

  @override
  Future<void> savePreferences({
    required String userId,
    required GoalsDietaryPreferences preferences,
  }) async {
    final encoded = GoalsDietaryPreferencesModel(
      preferences: preferences,
    ).encode();
    await _localDataSource.writeRawPreferences(
      userId: userId,
      encodedJson: encoded,
    );
  }
}
