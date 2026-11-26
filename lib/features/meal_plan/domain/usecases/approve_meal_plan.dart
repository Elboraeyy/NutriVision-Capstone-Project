import '../entities/daily_meal_plan.dart';
import '../repositories/meal_plan_repository.dart';

/// Approves and saves a draft plan into the active schedule.
class ApproveMealPlan {
  const ApproveMealPlan(this.repository);

  final MealPlanRepository repository;

  Future<void> call(DailyMealPlan plan) => repository.approvePlan(plan);
}
