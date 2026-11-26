/// Daily macro and hydration targets configured by the user.
class DailyNutritionTargets {
  const DailyNutritionTargets({
    this.calories = 2000,
    this.proteinGrams = 120,
    this.carbsGrams = 245,
    this.fatGrams = 60,
    this.waterMl = 2000,
  });

  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int waterMl;

  DailyNutritionTargets copyWith({
    int? calories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatGrams,
    int? waterMl,
  }) {
    return DailyNutritionTargets(
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      waterMl: waterMl ?? this.waterMl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyNutritionTargets &&
        other.calories == calories &&
        other.proteinGrams == proteinGrams &&
        other.carbsGrams == carbsGrams &&
        other.fatGrams == fatGrams &&
        other.waterMl == waterMl;
  }

  @override
  int get hashCode =>
      Object.hash(calories, proteinGrams, carbsGrams, fatGrams, waterMl);
}
