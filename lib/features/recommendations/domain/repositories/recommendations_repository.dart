import '../entities/recipe.dart';

/// Abstract repository contract for fetching recipes and recommendations.
abstract class RecommendationsRepository {
  Future<List<Recipe>> getRecommendedRecipes();
  Future<Recipe?> getRecipeById(String id);
}
