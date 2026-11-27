import '../../../profile/domain/entities/goals_dietary_preferences.dart';
import '../../../profile/domain/usecases/get_goals_dietary_preferences.dart';
import '../../../profile/domain/usecases/save_goals_dietary_preferences.dart';
import '../entities/onboarding_profile.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(
    this._repository, {
    required GetGoalsDietaryPreferences getPreferences,
    required SaveGoalsDietaryPreferences savePreferences,
  }) : _getPreferences = getPreferences,
       _savePreferences = savePreferences;

  final OnboardingRepository _repository;
  final GetGoalsDietaryPreferences _getPreferences;
  final SaveGoalsDietaryPreferences _savePreferences;

  Future<void> call(OnboardingProfile profile, {required String userId}) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }

    final existing = await _getPreferences(userId: userId);
    final dietaryPattern = profile.dietaryPreferences.contains('No preference')
        ? 'No preference'
        : profile.dietaryPreferences.isEmpty
        ? 'No preference'
        : profile.dietaryPreferences.first;
    final preferences = GoalsDietaryPreferences(
      goal: profile.goal ?? GoalsDietaryPreferences.defaultGoal,
      allergies: profile.noAllergies ? const [] : profile.allergies.toList(),
      dailyTargets: existing?.dailyTargets ?? const DailyTargets(),
      dietaryPattern: dietaryPattern,
      excludedIngredients: existing?.excludedIngredients ?? const [],
      likedFoods: profile.favoriteFoods.toList(),
    );

    await _savePreferences(preferences, userId: userId);
    await _repository.complete(profile);
  }
}
