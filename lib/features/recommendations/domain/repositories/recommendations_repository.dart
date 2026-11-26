import '../entities/recipe.dart';

/// Abstract repository contract for fetching recipes and recommendations.
abstract class RecommendationsRepository {
  Future<List<Recipe>> getRecommendedRecipes();
  Future<Recipe?> getRecipeById(String id);
  Future<List<Recipe>> searchRecipes({
    String? query,
    List<String>? ingredients,
    int? maxCalories,
    int? minProtein,
  });
  Future<void> toggleSaveRecipe(String id);
  Future<List<Recipe>> getSavedRecipes();
}
