/// Nutrition macro values for a meal.
class MealNutrition {
  const MealNutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  MealNutrition copyWith({
    int? calories,
    String? protein,
    String? carbs,
    String? fat,
  }) {
    return MealNutrition(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
