import '../entities/logged_meal.dart';
import '../repositories/meals_repository.dart';

/// Retrieves recently logged meals.
class GetRecentMeals {
  const GetRecentMeals(this.repository);

  final MealsRepository repository;

  Future<List<LoggedMeal>> call() => repository.getRecentMeals();
}
