import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_recipe_details.dart';
import '../../domain/usecases/get_recommended_recipes.dart';
import '../../domain/usecases/get_saved_recipes.dart';
import '../../domain/usecases/search_recipes.dart';
import '../../domain/usecases/toggle_save_recipe.dart';

enum RecommendationsStatus { initial, loading, success, failure }

sealed class RecommendationsEvent {
  const RecommendationsEvent();
}

final class RecommendationsStarted extends RecommendationsEvent {
  const RecommendationsStarted();
}

final class RecipeDetailsRequested extends RecommendationsEvent {
  const RecipeDetailsRequested(this.id);
  final String id;
}

final class RecipeSearchChanged extends RecommendationsEvent {
  const RecipeSearchChanged(this.query);
  final String query;
}

final class RecipeIngredientToggled extends RecommendationsEvent {
  const RecipeIngredientToggled(this.ingredient);
  final String ingredient;
}

final class RecipeCaloriesFilterChanged extends RecommendationsEvent {
  const RecipeCaloriesFilterChanged(this.maxCalories);
  final int maxCalories;
}

final class RecipeProteinFilterChanged extends RecommendationsEvent {
  const RecipeProteinFilterChanged(this.minProtein);
  final int minProtein;
}

final class RecipeFiltersReset extends RecommendationsEvent {
  const RecipeFiltersReset();
}

final class RecipeSaveToggled extends RecommendationsEvent {
  const RecipeSaveToggled(this.id);
  final String id;
}

class RecommendationsState {
  const RecommendationsState({
    this.status = RecommendationsStatus.initial,
    this.recipes = const [],
    this.filteredRecipes = const [],
    this.savedRecipes = const [],
    this.featuredRecipe,
    this.selectedRecipe,
    this.searchQuery = '',
    this.selectedIngredients = const [],
    this.maxCalories = 800,
    this.minProtein = 0,
    this.message,
  });

  final RecommendationsStatus status;
  final List<Recipe> recipes;
  final List<Recipe> filteredRecipes;
  final List<Recipe> savedRecipes;
  final Recipe? featuredRecipe;
  final Recipe? selectedRecipe;
  final String searchQuery;
  final List<String> selectedIngredients;
  final int maxCalories;
  final int minProtein;
  final String? message;

  RecommendationsState copyWith({
    RecommendationsStatus? status,
    List<Recipe>? recipes,
    List<Recipe>? filteredRecipes,
    List<Recipe>? savedRecipes,
    Recipe? featuredRecipe,
    Recipe? selectedRecipe,
    String? searchQuery,
    List<String>? selectedIngredients,
    int? maxCalories,
    int? minProtein,
    String? message,
  }) {
    return RecommendationsState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      featuredRecipe: featuredRecipe ?? this.featuredRecipe,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      maxCalories: maxCalories ?? this.maxCalories,
      minProtein: minProtein ?? this.minProtein,
      message: message ?? this.message,
    );
  }
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc({
    required this.getRecommendedRecipes,
    required this.getRecipeDetails,
    required this.searchRecipes,
    required this.toggleSaveRecipe,
    required this.getSavedRecipes,
  }) : super(const RecommendationsState()) {
    on<RecommendationsStarted>(_onStarted);
    on<RecipeDetailsRequested>(_onRecipeDetails);
    on<RecipeSearchChanged>(_onSearchChanged);
    on<RecipeIngredientToggled>(_onIngredientToggled);
    on<RecipeCaloriesFilterChanged>(_onCaloriesChanged);
    on<RecipeProteinFilterChanged>(_onProteinChanged);
    on<RecipeFiltersReset>(_onFiltersReset);
    on<RecipeSaveToggled>(_onSaveToggled);
  }

  final GetRecommendedRecipes getRecommendedRecipes;
  final GetRecipeDetails getRecipeDetails;
  final SearchRecipes searchRecipes;
  final ToggleSaveRecipe toggleSaveRecipe;
  final GetSavedRecipes getSavedRecipes;

  Future<void> _onStarted(
    RecommendationsStarted event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(state.copyWith(status: RecommendationsStatus.loading));
    try {
      final recipes = await getRecommendedRecipes();
      final saved = await getSavedRecipes();
      final featured = recipes.firstWhere(
        (r) => r.isFeatured,
        orElse: () => recipes.first,
      );

      emit(
        state.copyWith(
          status: RecommendationsStatus.success,
          recipes: recipes,
          filteredRecipes: recipes,
          savedRecipes: saved,
          featuredRecipe: featured,
          selectedRecipe: state.selectedRecipe ?? featured,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecommendationsStatus.failure,
          message: 'Unable to load recommendations: $e',
        ),
      );
    }
  }

  Future<void> _onRecipeDetails(
    RecipeDetailsRequested event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(state.copyWith(status: RecommendationsStatus.loading));
    try {
      final recipe = await getRecipeDetails(event.id);
      emit(
        state.copyWith(
          status: RecommendationsStatus.success,
          selectedRecipe: recipe,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecommendationsStatus.failure,
          message: 'Unable to load recipe details: $e',
        ),
      );
    }
  }

  Future<void> _onSearchChanged(
    RecipeSearchChanged event,
    Emitter<RecommendationsState> emit,
  ) async {
    final results = await searchRecipes(
      query: event.query,
      ingredients: state.selectedIngredients,
      maxCalories: state.maxCalories,
      minProtein: state.minProtein,
    );
    emit(state.copyWith(searchQuery: event.query, filteredRecipes: results));
  }

  Future<void> _onIngredientToggled(
    RecipeIngredientToggled event,
    Emitter<RecommendationsState> emit,
  ) async {
    final current = List<String>.from(state.selectedIngredients);
    if (current.contains(event.ingredient)) {
      current.remove(event.ingredient);
    } else {
      current.add(event.ingredient);
    }
    final results = await searchRecipes(
      query: state.searchQuery,
      ingredients: current,
      maxCalories: state.maxCalories,
      minProtein: state.minProtein,
    );
    emit(
      state.copyWith(selectedIngredients: current, filteredRecipes: results),
    );
  }

  Future<void> _onCaloriesChanged(
    RecipeCaloriesFilterChanged event,
    Emitter<RecommendationsState> emit,
  ) async {
    final results = await searchRecipes(
      query: state.searchQuery,
      ingredients: state.selectedIngredients,
      maxCalories: event.maxCalories,
      minProtein: state.minProtein,
    );
    emit(
      state.copyWith(maxCalories: event.maxCalories, filteredRecipes: results),
    );
  }

  Future<void> _onProteinChanged(
    RecipeProteinFilterChanged event,
    Emitter<RecommendationsState> emit,
  ) async {
    final results = await searchRecipes(
      query: state.searchQuery,
      ingredients: state.selectedIngredients,
      maxCalories: state.maxCalories,
      minProtein: event.minProtein,
    );
    emit(
      state.copyWith(minProtein: event.minProtein, filteredRecipes: results),
    );
  }

  Future<void> _onFiltersReset(
    RecipeFiltersReset event,
    Emitter<RecommendationsState> emit,
  ) async {
    final results = await searchRecipes(
      query: '',
      ingredients: const [],
      maxCalories: 800,
      minProtein: 0,
    );
    emit(
      state.copyWith(
        searchQuery: '',
        selectedIngredients: const [],
        maxCalories: 800,
        minProtein: 0,
        filteredRecipes: results,
      ),
    );
  }

  Future<void> _onSaveToggled(
    RecipeSaveToggled event,
    Emitter<RecommendationsState> emit,
  ) async {
    try {
      await toggleSaveRecipe(event.id);
      final recipes = await getRecommendedRecipes();
      final saved = await getSavedRecipes();
      final updatedFiltered = state.filteredRecipes
          .map((r) => r.id == event.id ? r.copyWith(isSaved: !r.isSaved) : r)
          .toList();
      final updatedFeatured = state.featuredRecipe?.id == event.id
          ? state.featuredRecipe!.copyWith(
              isSaved: !state.featuredRecipe!.isSaved,
            )
          : state.featuredRecipe;
      final updatedSelected = state.selectedRecipe?.id == event.id
          ? state.selectedRecipe!.copyWith(
              isSaved: !state.selectedRecipe!.isSaved,
            )
          : state.selectedRecipe;

      emit(
        state.copyWith(
          recipes: recipes,
          filteredRecipes: updatedFiltered,
          savedRecipes: saved,
          featuredRecipe: updatedFeatured,
          selectedRecipe: updatedSelected,
        ),
      );
    } catch (_) {}
  }
}
