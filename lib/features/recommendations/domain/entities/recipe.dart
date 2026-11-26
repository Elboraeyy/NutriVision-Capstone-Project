import 'recipe_ingredient.dart';
import 'recipe_step.dart';

/// Business entity representing a culinary recipe with macro breakdowns and steps.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.totalTime,
    required this.difficulty,
    required this.proteinPerServing,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.prepTime,
    required this.cookTime,
  });

  final String id;
  final String title;
  final String description;
  final String totalTime;
  final String difficulty;
  final String proteinPerServing;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final String imageUrl;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final String prepTime;
  final String cookTime;
}
