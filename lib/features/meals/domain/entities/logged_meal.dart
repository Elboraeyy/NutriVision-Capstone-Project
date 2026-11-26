import 'meal_food_item.dart';
import 'meal_nutrition.dart';

/// Business entity representing a logged or detected meal in NutriVision.
class LoggedMeal {
  const LoggedMeal({
    required this.id,
    required this.name,
    required this.category,
    required this.timeLabel,
    required this.servingLabel,
    required this.imageUrl,
    required this.nutrition,
    required this.foods,
    this.isEaten = true,
  });

  final String id;
  final String name;
  final String category;
  final String timeLabel;
  final String servingLabel;
  final String imageUrl;
  final MealNutrition nutrition;
  final List<MealFoodItem> foods;
  final bool isEaten;

  LoggedMeal copyWith({
    String? id,
    String? name,
    String? category,
    String? timeLabel,
    String? servingLabel,
    String? imageUrl,
    MealNutrition? nutrition,
    List<MealFoodItem>? foods,
    bool? isEaten,
  }) {
    return LoggedMeal(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      timeLabel: timeLabel ?? this.timeLabel,
      servingLabel: servingLabel ?? this.servingLabel,
      imageUrl: imageUrl ?? this.imageUrl,
      nutrition: nutrition ?? this.nutrition,
      foods: foods ?? this.foods,
      isEaten: isEaten ?? this.isEaten,
    );
  }
}
