/// Single planned meal inside a daily meal schedule.
class PlannedMeal {
  const PlannedMeal({
    required this.id,
    required this.type,
    required this.time,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.allergens,
    required this.tileColorHex,
    this.recipeId,
  });

  final String id;
  final String type;
  final String time;
  final String title;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final String imageUrl;
  final String allergens;
  final int tileColorHex;
  final String? recipeId;

  PlannedMeal copyWith({
    String? id,
    String? type,
    String? time,
    String? title,
    int? calories,
    String? protein,
    String? carbs,
    String? fat,
    String? imageUrl,
    String? allergens,
    int? tileColorHex,
    String? recipeId,
  }) {
    return PlannedMeal(
      id: id ?? this.id,
      type: type ?? this.type,
      time: time ?? this.time,
      title: title ?? this.title,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      imageUrl: imageUrl ?? this.imageUrl,
      allergens: allergens ?? this.allergens,
      tileColorHex: tileColorHex ?? this.tileColorHex,
      recipeId: recipeId ?? this.recipeId,
    );
  }
}
