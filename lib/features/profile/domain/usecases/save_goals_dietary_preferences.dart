import '../entities/goals_dietary_preferences.dart';
import '../repositories/goals_dietary_repository.dart';

/// Validates and saves Goals & Dietary Preferences.
class SaveGoalsDietaryPreferences {
  const SaveGoalsDietaryPreferences(this._repository);

  final GoalsDietaryRepository _repository;

  Future<GoalsDietaryPreferences> call(
    GoalsDietaryPreferences preferences,
  ) async {
    final normalized = _normalize(preferences);
    final error = normalized.validate();
    if (error != null) {
      throw GoalsDietaryValidationException(error);
    }
    await _repository.savePreferences(normalized);
    return normalized;
  }

  GoalsDietaryPreferences _normalize(GoalsDietaryPreferences prefs) {
    final allergies = _dedupe(prefs.allergies);
    final excluded = _dedupe(prefs.excludedIngredients);
    // Never allow food preferences to override active allergy restrictions.
    final liked = _dedupe(prefs.likedFoods)
        .where(
          (food) => !prefs
              .copyWith(allergies: allergies)
              .conflictsWithAllergies(food),
        )
        .toList();

    return prefs.copyWith(
      goal: prefs.goal.trim(),
      dietaryPattern: prefs.dietaryPattern.trim(),
      allergies: allergies,
      excludedIngredients: excluded,
      likedFoods: liked,
    );
  }

  List<String> _dedupe(List<String> items) {
    final seen = <String>{};
    final result = <String>[];
    for (final raw in items) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (seen.add(trimmed.toLowerCase())) {
        result.add(trimmed);
      }
    }
    return result;
  }
}
