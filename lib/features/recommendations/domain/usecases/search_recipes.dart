import '../entities/recipe.dart';
import '../repositories/recommendations_repository.dart';

/// Searches recipes with optional ingredients and macro constraints.
class SearchRecipes {
  const SearchRecipes(this.repository);

  final RecommendationsRepository repository;

  Future<List<Recipe>> call({
    String? query,
    List<String>? ingredients,
    int? maxCalories,
    int? minProtein,
  }) {
    return repository.searchRecipes(
      query: query,
      ingredients: ingredients,
      maxCalories: maxCalories,
      minProtein: minProtein,
    );
  }
}
