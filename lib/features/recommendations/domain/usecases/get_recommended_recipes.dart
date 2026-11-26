import '../entities/recipe.dart';
import '../repositories/recommendations_repository.dart';

/// Fetches recommended recipes for the user.
class GetRecommendedRecipes {
  const GetRecommendedRecipes(this.repository);

  final RecommendationsRepository repository;

  Future<List<Recipe>> call() => repository.getRecommendedRecipes();
}
