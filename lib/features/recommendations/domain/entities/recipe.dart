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
    this.tagline = 'Per serving · Fresh, bright & satisfying',
    this.isFeatured = false,
    this.isSaved = false,
    this.categories = const ['High Protein', 'Easy'],
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
  final String tagline;
  final bool isFeatured;
  final bool isSaved;
  final List<String> categories;

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? totalTime,
    String? difficulty,
    String? proteinPerServing,
    int? calories,
    String? protein,
    String? carbs,
    String? fat,
    String? imageUrl,
    List<RecipeIngredient>? ingredients,
    List<RecipeStep>? steps,
    String? prepTime,
    String? cookTime,
    String? tagline,
    bool? isFeatured,
    bool? isSaved,
    List<String>? categories,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      totalTime: totalTime ?? this.totalTime,
      difficulty: difficulty ?? this.difficulty,
      proteinPerServing: proteinPerServing ?? this.proteinPerServing,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      tagline: tagline ?? this.tagline,
      isFeatured: isFeatured ?? this.isFeatured,
      isSaved: isSaved ?? this.isSaved,
      categories: categories ?? this.categories,
    );
  }
}
