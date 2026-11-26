/// Daily macro and calorie totals for a meal plan.
class PlanNutrition {
  const PlanNutrition({
    required this.calories,
    required this.targetCalories,
    required this.proteinGrams,
    required this.targetProteinGrams,
    required this.carbsGrams,
    required this.targetCarbsGrams,
    required this.fatGrams,
    required this.targetFatGrams,
    this.note =
        'Estimates for planned portions, not consumed food. 205 kcal below your daily target.',
  });

  final int calories;
  final int targetCalories;
  final int proteinGrams;
  final int targetProteinGrams;
  final int carbsGrams;
  final int targetCarbsGrams;
  final int fatGrams;
  final int targetFatGrams;
  final String note;

  double get caloriesRatio =>
      targetCalories > 0 ? (calories / targetCalories).clamp(0.0, 1.0) : 0.0;
  double get proteinRatio => targetProteinGrams > 0
      ? (proteinGrams / targetProteinGrams).clamp(0.0, 1.0)
      : 0.0;
  double get carbsRatio => targetCarbsGrams > 0
      ? (carbsGrams / targetCarbsGrams).clamp(0.0, 1.0)
      : 0.0;
  double get fatRatio =>
      targetFatGrams > 0 ? (fatGrams / targetFatGrams).clamp(0.0, 1.0) : 0.0;
}
