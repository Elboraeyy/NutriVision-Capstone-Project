import '../repositories/recommendations_repository.dart';

/// Toggles whether a recipe is saved in the user's bookmarks.
class ToggleSaveRecipe {
  const ToggleSaveRecipe(this.repository);

  final RecommendationsRepository repository;

  Future<void> call(String id) => repository.toggleSaveRecipe(id);
}
