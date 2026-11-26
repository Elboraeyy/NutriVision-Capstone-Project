import '../repositories/meals_repository.dart';

/// Deletes a logged meal by its ID.
class DeleteMeal {
  const DeleteMeal(this.repository);

  final MealsRepository repository;

  Future<void> call(String id) => repository.deleteMeal(id);
}
