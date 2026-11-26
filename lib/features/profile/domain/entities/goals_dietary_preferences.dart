/// Daily nutrition and hydration targets for a user profile.
///
/// All five targets default to `0` for a new profile without saved targets.
class DailyTargets {
  const DailyTargets({
    this.calories = 0,
    this.protein = 0,
    this.carbohydrates = 0,
    this.fat = 0,
    this.water = 0,
  });

  final int calories;
  final int protein;
  final int carbohydrates;
  final int fat;
  final int water;

  DailyTargets copyWith({
    int? calories,
    int? protein,
    int? carbohydrates,
    int? fat,
    int? water,
  }) {
    return DailyTargets(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fat: fat ?? this.fat,
      water: water ?? this.water,
    );
  }

  /// Validates that all target values are non-negative.
  String? validate() {
    if (calories < 0 ||
        protein < 0 ||
        carbohydrates < 0 ||
        fat < 0 ||
        water < 0) {
      return 'Daily targets cannot be negative.';
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyTargets &&
        other.calories == calories &&
        other.protein == protein &&
        other.carbohydrates == carbohydrates &&
        other.fat == fat &&
        other.water == water;
  }

  @override
  int get hashCode => Object.hash(calories, protein, carbohydrates, fat, water);
}

/// Complete Goals & Dietary Preferences domain entity.
class GoalsDietaryPreferences {
  const GoalsDietaryPreferences({
    this.goal = defaultGoal,
    this.allergies = defaultAllergies,
    this.dailyTargets = const DailyTargets(),
    this.dietaryPattern = defaultDietaryPattern,
    this.excludedIngredients = defaultExcludedIngredients,
    this.likedFoods = defaultLikedFoods,
  });

  static const String defaultGoal = 'Eat Healthier';
  static const String defaultDietaryPattern = 'Flexitarian';
  static const List<String> defaultAllergies = ['Peanuts'];
  static const List<String> defaultExcludedIngredients = ['Alcohol'];
  static const List<String> defaultLikedFoods = ['Oats', 'Berries', 'Salmon'];

  static const List<String> availableGoals = [
    'Eat Healthier',
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle',
  ];

  /// Matches the onboarding dietary pattern options.
  static const List<String> availableDietaryPatterns = [
    'No preference',
    'Flexitarian',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
  ];

  /// Matches the onboarding common allergen options (excluding 'None').
  static const List<String> commonAllergens = [
    'Peanuts',
    'Tree nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
  ];

  static const List<String> commonExcludedIngredients = [
    'Alcohol',
    'Added sugar',
    'Red meat',
    'Dairy',
    'Caffeine',
    'Pork',
    'Gluten',
    'Processed foods',
  ];

  /// Includes the onboarding favorite foods plus common options.
  static const List<String> commonLikedFoods = [
    'Oats',
    'Berries',
    'Salmon',
    'Rice',
    'Lentils',
    'Avocado',
    'Eggs',
    'Chicken',
    'Spinach',
    'Greek yogurt',
  ];

  final String goal;
  final List<String> allergies;
  final DailyTargets dailyTargets;
  final String dietaryPattern;
  final List<String> excludedIngredients;
  final List<String> likedFoods;

  GoalsDietaryPreferences copyWith({
    String? goal,
    List<String>? allergies,
    DailyTargets? dailyTargets,
    String? dietaryPattern,
    List<String>? excludedIngredients,
    List<String>? likedFoods,
  }) {
    return GoalsDietaryPreferences(
      goal: goal ?? this.goal,
      allergies: allergies ?? this.allergies,
      dailyTargets: dailyTargets ?? this.dailyTargets,
      dietaryPattern: dietaryPattern ?? this.dietaryPattern,
      excludedIngredients: excludedIngredients ?? this.excludedIngredients,
      likedFoods: likedFoods ?? this.likedFoods,
    );
  }

  /// Validates the preferences before saving.
  String? validate() {
    if (goal.trim().isEmpty) {
      return 'Please select a primary nutrition goal.';
    }
    if (dietaryPattern.trim().isEmpty) {
      return 'Please select a dietary pattern.';
    }
    return dailyTargets.validate();
  }

  /// Returns true if [food] conflicts with any active allergy restriction.
  bool conflictsWithAllergies(String food) {
    final normalizedFood = food.trim().toLowerCase();
    if (normalizedFood.isEmpty) return false;
    return allergies.any((allergy) {
      final normalizedAllergy = allergy.trim().toLowerCase();
      return normalizedFood == normalizedAllergy ||
          normalizedFood.contains(normalizedAllergy) ||
          normalizedAllergy.contains(normalizedFood);
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoalsDietaryPreferences &&
        other.goal == goal &&
        _listEquals(other.allergies, allergies) &&
        other.dailyTargets == dailyTargets &&
        other.dietaryPattern == dietaryPattern &&
        _listEquals(other.excludedIngredients, excludedIngredients) &&
        _listEquals(other.likedFoods, likedFoods);
  }

  @override
  int get hashCode => Object.hash(
    goal,
    Object.hashAll(allergies),
    dailyTargets,
    dietaryPattern,
    Object.hashAll(excludedIngredients),
    Object.hashAll(likedFoods),
  );
}

bool _listEquals(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Thrown when Goals & Dietary Preferences fail domain validation.
class GoalsDietaryValidationException implements Exception {
  const GoalsDietaryValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
