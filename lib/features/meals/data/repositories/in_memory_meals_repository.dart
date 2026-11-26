import '../../domain/entities/logged_meal.dart';
import '../../domain/entities/meal_food_item.dart';
import '../../domain/entities/meal_nutrition.dart';
import '../../domain/repositories/meals_repository.dart';

/// In-memory placeholder implementation of [MealsRepository].
///
/// Follows Clean Architecture by implementing the domain contract without
/// locking the presentation layer to any specific backend.
class InMemoryMealsRepository implements MealsRepository {
  InMemoryMealsRepository({List<LoggedMeal>? initialMeals})
    : _meals = initialMeals ?? [_defaultSampleMeal];

  final List<LoggedMeal> _meals;

  static const _defaultSampleMeal = LoggedMeal(
    id: 'sample-chicken-quinoa-bowl',
    name: 'Chicken & quinoa bowl',
    category: 'Dinner',
    timeLabel: 'Today · 6:30 PM',
    servingLabel: '1 bowl · Logged at 12:30 PM',
    imageUrl: 'assets/images/Chicken and quinoa bowl.png',
    nutrition: MealNutrition(
      calories: 520,
      protein: '40 g',
      carbs: '54 g',
      fat: '16 g',
    ),
    foods: [
      MealFoodItem(name: 'Grilled chicken', amount: '100'),
      MealFoodItem(name: 'Cooked quinoa', amount: '150'),
      MealFoodItem(name: 'Avocado', amount: '40', warning: true),
      MealFoodItem(name: 'Mixed vegetables', amount: '80'),
    ],
  );

  @override
  Future<List<LoggedMeal>> getRecentMeals() async {
    return List.unmodifiable(_meals);
  }

  @override
  Future<LoggedMeal?> getMealById(String id) async {
    try {
      return _meals.firstWhere((meal) => meal.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveMeal(LoggedMeal meal) async {
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index >= 0) {
      _meals[index] = meal;
    } else {
      _meals.insert(0, meal);
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    _meals.removeWhere((meal) => meal.id == id);
  }
}
