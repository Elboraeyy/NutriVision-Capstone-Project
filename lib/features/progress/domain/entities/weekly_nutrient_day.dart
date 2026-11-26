/// Represents a single day's logged macro breakdown in the weekly chart.
class WeeklyNutrientDay {
  const WeeklyNutrientDay({
    required this.shortDay,
    required this.isToday,
    required this.hasData,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  final String shortDay;
  final bool isToday;
  final bool hasData;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  int valueForNutrient(String nutrientId) {
    switch (nutrientId) {
      case 'calories':
        return calories;
      case 'protein':
        return protein;
      case 'carbs':
        return carbs;
      case 'fat':
        return fat;
      default:
        return calories;
    }
  }
}
