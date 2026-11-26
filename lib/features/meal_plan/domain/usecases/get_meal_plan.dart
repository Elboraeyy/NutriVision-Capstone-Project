import '../entities/daily_meal_plan.dart';
import '../repositories/meal_plan_repository.dart';

/// Fetches the daily meal plan for a specified date.
class GetMealPlan {
  const GetMealPlan(this.repository);

  final MealPlanRepository repository;

  Future<DailyMealPlan> call(DateTime date) =>
      repository.getMealPlanForDate(date);
}
