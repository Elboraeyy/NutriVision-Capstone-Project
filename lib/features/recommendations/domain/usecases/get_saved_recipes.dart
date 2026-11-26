import '../entities/recipe.dart';
import '../repositories/recommendations_repository.dart';

/// Retrieves all saved bookmarked recipes.
class GetSavedRecipes {
  const GetSavedRecipes(this.repository);

  final RecommendationsRepository repository;

  Future<List<Recipe>> call() => repository.getSavedRecipes();
}
