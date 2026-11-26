import '../entities/recipe.dart';
import '../repositories/recommendations_repository.dart';

/// Fetches details for a specific recipe.
class GetRecipeDetails {
  const GetRecipeDetails(this.repository);

  final RecommendationsRepository repository;

  Future<Recipe?> call(String id) => repository.getRecipeById(id);
}
