import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/entities/recipe_step.dart';
import '../../domain/repositories/recommendations_repository.dart';

/// In-memory implementation of [RecommendationsRepository].
class InMemoryRecommendationsRepository implements RecommendationsRepository {
  InMemoryRecommendationsRepository({List<Recipe>? initialRecipes})
    : _recipes = initialRecipes ?? [_sampleRecipe];

  final List<Recipe> _recipes;

  static const _sampleRecipe = Recipe(
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
  );

  @override
  Future<List<Recipe>> getRecommendedRecipes() async {
    return List.unmodifiable(_recipes);
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
