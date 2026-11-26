import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Validates and persists the user's nutrition goals, daily targets,
/// dietary pattern, allergies, and food preferences.
class UpdateGoalsAndPreferences {
  const UpdateGoalsAndPreferences(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call(UserProfile profile) {
    final targets = profile.dailyTargets;
    if (targets.calories < 800 || targets.calories > 6000) {
      throw ArgumentError(
        'Calories target must be between 800 and 6,000 kcal.',
      );
    }
    if (targets.proteinGrams < 20 || targets.proteinGrams > 400) {
      throw ArgumentError('Protein target must be between 20 and 400 g.');
    }
    if (targets.carbsGrams < 20 || targets.carbsGrams > 700) {
      throw ArgumentError('Carbohydrates target must be between 20 and 700 g.');
    }
    if (targets.fatGrams < 10 || targets.fatGrams > 250) {
      throw ArgumentError('Fat target must be between 10 and 250 g.');
    }
    if (targets.waterMl < 500 || targets.waterMl > 6000) {
      throw ArgumentError('Water target must be between 500 and 6,000 ml.');
    }
    return _repository.updateGoalsAndPreferences(profile);
  }
}
