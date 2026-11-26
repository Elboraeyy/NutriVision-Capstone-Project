import '../entities/logged_meal.dart';
import '../repositories/meals_repository.dart';

/// Saves or updates a logged meal.
class SaveMeal {
  const SaveMeal(this.repository);

  final MealsRepository repository;

  Future<void> call(LoggedMeal meal) => repository.saveMeal(meal);
}
