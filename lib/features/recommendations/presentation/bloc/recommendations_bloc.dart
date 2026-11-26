import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_recipe_details.dart';
import '../../domain/usecases/get_recommended_recipes.dart';

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

class RecommendationsState {
  const RecommendationsState({
    this.status = RecommendationsStatus.initial,
    this.recipes = const [],
    this.selectedRecipe,
    this.message,
  });

  final RecommendationsStatus status;
  final List<Recipe> recipes;
  final Recipe? selectedRecipe;
  final String? message;

  RecommendationsState copyWith({
    RecommendationsStatus? status,
    List<Recipe>? recipes,
    Recipe? selectedRecipe,
    String? message,
  }) {
    return RecommendationsState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      message: message ?? this.message,
    );
  }
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc({
    required this.getRecommendedRecipes,
    required this.getRecipeDetails,
  }) : super(const RecommendationsState()) {
    on<RecommendationsStarted>(_onStarted);
    on<RecipeDetailsRequested>(_onRecipeDetails);
  }

  final GetRecommendedRecipes getRecommendedRecipes;
  final GetRecipeDetails getRecipeDetails;

  Future<void> _onStarted(
    RecommendationsStarted event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(state.copyWith(status: RecommendationsStatus.loading));
    try {
      final recipes = await getRecommendedRecipes();
      emit(
        state.copyWith(
          status: RecommendationsStatus.success,
          recipes: recipes,
          selectedRecipe: recipes.isNotEmpty ? recipes.first : null,
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
}
