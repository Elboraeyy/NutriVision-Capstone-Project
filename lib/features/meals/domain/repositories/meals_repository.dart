import '../entities/logged_meal.dart';

/// Abstract contract for meal storage and retrieval operations.
abstract class MealsRepository {
  Future<List<LoggedMeal>> getRecentMeals();
  Future<LoggedMeal?> getMealById(String id);
  Future<void> saveMeal(LoggedMeal meal);
  Future<void> deleteMeal(String id);
}
