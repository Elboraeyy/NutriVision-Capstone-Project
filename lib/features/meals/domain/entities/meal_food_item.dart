/// Individual food item detected or logged in a meal.
class MealFoodItem {
  const MealFoodItem({
    required this.name,
    required this.amount,
    this.unit = 'g',
    this.warning = false,
  });

  final String name;
  final String amount;
  final String unit;
  final bool warning;

  MealFoodItem copyWith({
    String? name,
    String? amount,
    String? unit,
    bool? warning,
  }) {
    return MealFoodItem(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      warning: warning ?? this.warning,
    );
  }
}
