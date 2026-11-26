import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/entities/recipe_step.dart';
import '../../domain/repositories/recommendations_repository.dart';

/// In-memory implementation of [RecommendationsRepository].
class InMemoryRecommendationsRepository implements RecommendationsRepository {
  InMemoryRecommendationsRepository({List<Recipe>? initialRecipes})
    : _recipes = initialRecipes ?? List.of(_defaultRecipes);

  final List<Recipe> _recipes;
  final Set<String> _savedRecipeIds = {};

  static final List<Recipe> _defaultRecipes = [
    const Recipe(
      id: 'sample-lemon-salmon-couscous',
      title: 'Lemon salmon & couscous',
      description:
          'Bright lemon, flaky salmon and a fluffy couscous base. '
          'Simple ingredients, a satisfying bowl.',
      totalTime: '25 min total',
      difficulty: 'Easy',
      proteinPerServing: '30 g protein / serving',
      calories: 420,
      protein: '30 g',
      carbs: '48 g',
      fat: '12 g',
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288'
          '?auto=format&fit=crop&w=900&q=85',
      prepTime: 'Prep 10',
      cookTime: 'Cook 15 min',
      tagline: 'Per serving · Fresh, bright & satisfying',
      isFeatured: true,
      categories: ['High Protein', 'Seafood', 'Easy'],
      ingredients: [
        RecipeIngredient(name: 'Salmon fillets', amount: '240 g · 2 × 120 g'),
        RecipeIngredient(name: 'Dry couscous', amount: '100 g'),
        RecipeIngredient(name: 'Broccoli florets', amount: '160 g'),
        RecipeIngredient(name: 'Cherry tomatoes', amount: '100 g'),
        RecipeIngredient(name: 'Lemon', amount: '1 · zest & juice'),
        RecipeIngredient(name: 'Olive oil', amount: '2 tsp'),
        RecipeIngredient(name: 'Salt & black pepper', amount: '¼ tsp each'),
        RecipeIngredient(name: 'Boiling water', amount: '120 ml'),
      ],
      steps: [
        RecipeStep(
          number: '1',
          title: 'Prep the oven & vegetables',
          description:
              'Heat the oven to 200°C / 180°C fan. Pat the salmon dry. '
              'Cut the broccoli into small florets and halve the tomatoes. '
              'Zest and juice the lemon.',
        ),
        RecipeStep(
          number: '2',
          title: 'Season & roast',
          description:
              'Place salmon, broccoli and tomatoes on a lined tray. '
              'Toss with 2 tsp olive oil, half the lemon juice, all the zest, '
              '¼ tsp salt and ¼ tsp pepper. Roast for 12–15 min, until salmon '
              'reaches 63°C in the thickest part and vegetables are tender.',
        ),
        RecipeStep(
          number: '3',
          title: 'Fluff the couscous',
          description:
              'While the tray roasts, put 100 g couscous in a heatproof bowl. '
              'Pour over 120 ml boiling water. Cover for 5 min, or follow pack '
              'directions, then fluff with a fork. Stir in the remaining lemon juice.',
        ),
        RecipeStep(
          number: '4',
          title: 'Plate & enjoy',
          description:
              'Divide couscous and vegetables equally between 2 bowls. '
              'Add one 120 g salmon fillet to each. Serve warm. '
              'Refrigerate leftovers within 2 hours and eat within 2 days.',
        ),
      ],
    ),
    const Recipe(
      id: 'sample-chicken-quinoa-bowl',
      title: 'Chicken & quinoa bowl',
      description:
          'Warm fluffy quinoa, marinated grilled chicken breast, and crisp garden veggies.',
      totalTime: '30 min · Easy',
      difficulty: 'Easy',
      proteinPerServing: '40 g protein / serving',
      calories: 520,
      protein: '40 g',
      carbs: '42 g',
      fat: '14 g',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c'
          '?auto=format&fit=crop&w=900&q=85',
      prepTime: 'Prep 15',
      cookTime: 'Cook 15 min',
      tagline: 'Per serving · High protein & energizing',
      isFeatured: false,
      categories: ['High Protein', 'Poultry', 'Bowl'],
      ingredients: [
        RecipeIngredient(name: 'Chicken breast', amount: '250 g'),
        RecipeIngredient(name: 'Quinoa', amount: '120 g'),
        RecipeIngredient(name: 'Cucumber', amount: '1 medium'),
        RecipeIngredient(name: 'Cherry tomatoes', amount: '80 g'),
        RecipeIngredient(name: 'Avocado', amount: '½ sliced'),
        RecipeIngredient(name: 'Olive oil', amount: '1 tbsp'),
      ],
      steps: [
        RecipeStep(
          number: '1',
          title: 'Cook quinoa',
          description:
              'Rinse quinoa and simmer in salted water for 15 minutes.',
        ),
        RecipeStep(
          number: '2',
          title: 'Grill chicken',
          description:
              'Season chicken breast with herbs, garlic, and grill until cooked through.',
        ),
        RecipeStep(
          number: '3',
          title: 'Assemble bowl',
          description:
              'Layer warm quinoa with sliced chicken, crisp cucumber, tomatoes, and avocado.',
        ),
      ],
    ),
    const Recipe(
      id: 'sample-roasted-chickpea-crunch',
      title: 'Roasted chickpea crunch',
      description:
          'Crispy spiced chickpeas tossed with baby spinach, creamy tahini dressing, and toasted seeds.',
      totalTime: '20 min · Easy',
      difficulty: 'Easy',
      proteinPerServing: '18 g protein / serving',
      calories: 390,
      protein: '18 g',
      carbs: '45 g',
      fat: '11 g',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd'
          '?auto=format&fit=crop&w=900&q=85',
      prepTime: 'Prep 5',
      cookTime: 'Cook 15 min',
      tagline: 'Per serving · Plant powered & fiber rich',
      isFeatured: false,
      categories: ['Vegetarian', 'Quick & Easy', 'Fiber Rich'],
      ingredients: [
        RecipeIngredient(name: 'Chickpeas', amount: '240 g rinsed'),
        RecipeIngredient(name: 'Baby spinach', amount: '100 g'),
        RecipeIngredient(name: 'Tahini', amount: '2 tbsp'),
        RecipeIngredient(name: 'Lemon juice', amount: '1 tbsp'),
        RecipeIngredient(name: 'Cumin & paprika', amount: '½ tsp each'),
        RecipeIngredient(name: 'Olive oil', amount: '1 tsp'),
      ],
      steps: [
        RecipeStep(
          number: '1',
          title: 'Roast chickpeas',
          description:
              'Toss chickpeas with olive oil and spices. Roast at 200°C for 15 minutes until crunchy.',
        ),
        RecipeStep(
          number: '2',
          title: 'Mix dressing',
          description:
              'Whisk tahini with fresh lemon juice and a splash of warm water.',
        ),
        RecipeStep(
          number: '3',
          title: 'Combine & serve',
          description:
              'Toss spinach with warm crunchy chickpeas and drizzle with tahini dressing.',
        ),
      ],
    ),
  ];

  @override
  Future<List<Recipe>> getRecommendedRecipes() async {
    return _recipes
        .map((r) => r.copyWith(isSaved: _savedRecipeIds.contains(r.id)))
        .toList(growable: false);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final recipe = _recipes.firstWhere((r) => r.id == id);
      return recipe.copyWith(isSaved: _savedRecipeIds.contains(recipe.id));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Recipe>> searchRecipes({
    String? query,
    List<String>? ingredients,
    int? maxCalories,
    int? minProtein,
  }) async {
    final cleanQuery = query?.trim().toLowerCase() ?? '';
    final activeIngredients =
        ingredients
            ?.map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList() ??
        const [];

    return _recipes
        .where((recipe) {
          if (cleanQuery.isNotEmpty) {
            final matchesTitle = recipe.title.toLowerCase().contains(
              cleanQuery,
            );
            final matchesDesc = recipe.description.toLowerCase().contains(
              cleanQuery,
            );
            final matchesIngredient = recipe.ingredients.any(
              (i) => i.name.toLowerCase().contains(cleanQuery),
            );
            if (!matchesTitle && !matchesDesc && !matchesIngredient) {
              return false;
            }
          }

          if (activeIngredients.isNotEmpty) {
            final recipeIngredients = recipe.ingredients
                .map((i) => i.name.toLowerCase())
                .toList();
            final hasAny = activeIngredients.any(
              (wanted) =>
                  recipeIngredients.any((actual) => actual.contains(wanted)),
            );
            if (!hasAny) {
              return false;
            }
          }

          if (maxCalories != null && recipe.calories > maxCalories) {
            return false;
          }

          if (minProtein != null) {
            final proteinNum =
                int.tryParse(
                  recipe.protein.replaceAll(RegExp(r'[^0-9]'), ''),
                ) ??
                0;
            if (proteinNum < minProtein) {
              return false;
            }
          }

          return true;
        })
        .map((r) => r.copyWith(isSaved: _savedRecipeIds.contains(r.id)))
        .toList();
  }

  @override
  Future<void> toggleSaveRecipe(String id) async {
    if (_savedRecipeIds.contains(id)) {
      _savedRecipeIds.remove(id);
    } else {
      _savedRecipeIds.add(id);
    }
  }

  @override
  Future<List<Recipe>> getSavedRecipes() async {
    return _recipes
        .where((r) => _savedRecipeIds.contains(r.id))
        .map((r) => r.copyWith(isSaved: true))
        .toList(growable: false);
  }
}
