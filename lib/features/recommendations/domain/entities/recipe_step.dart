/// Business entity representing a numbered step in recipe preparation.
class RecipeStep {
  const RecipeStep({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;
}
