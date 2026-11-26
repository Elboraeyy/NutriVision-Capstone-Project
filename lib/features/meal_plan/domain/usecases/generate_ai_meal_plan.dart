import '../entities/daily_meal_plan.dart';
import '../repositories/meal_plan_repository.dart';

/// Generates a personalized AI meal plan based on goals and restrictions.
class GenerateAiMealPlan {
  const GenerateAiMealPlan(this.repository);

  final MealPlanRepository repository;

  Future<DailyMealPlan> call({
    required String goal,
    required int durationDays,
    required List<String> availableFoods,
    required String mealPattern,
  }) {
    return repository.generateAiPlan(
      goal: goal,
      durationDays: durationDays,
      availableFoods: availableFoods,
      mealPattern: mealPattern,
    );
  }
}
