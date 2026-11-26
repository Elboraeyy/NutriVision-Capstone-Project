import '../entities/daily_meal_plan.dart';
import '../entities/planned_meal.dart';

/// Repository interface for fetching, generating, and updating meal plans.
abstract class MealPlanRepository {
  Future<DailyMealPlan> getMealPlanForDate(DateTime date);
  Future<DailyMealPlan> generateAiPlan({
    required String goal,
    required int durationDays,
    required List<String> availableFoods,
    required String mealPattern,
  });
  Future<PlannedMeal> cycleAlternativeMeal(String mealId);
  Future<void> replaceMeal(String mealId, PlannedMeal newMeal);
  Future<void> approvePlan(DailyMealPlan plan);
}
