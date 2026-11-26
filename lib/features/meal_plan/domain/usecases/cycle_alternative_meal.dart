import '../entities/planned_meal.dart';
import '../repositories/meal_plan_repository.dart';

/// Cycles and replaces a specific meal with an AI-generated alternative.
class CycleAlternativeMeal {
  const CycleAlternativeMeal(this.repository);

  final MealPlanRepository repository;

  Future<PlannedMeal> call(String mealId) =>
      repository.cycleAlternativeMeal(mealId);
}
