import 'plan_nutrition.dart';
import 'planned_meal.dart';

/// Full plan for a given day.
class DailyMealPlan {
  const DailyMealPlan({
    required this.date,
    required this.formattedDate,
    required this.isToday,
    required this.nutrition,
    required this.meals,
    this.statusNote = '4 planned meals · Not logged',
  });

  final DateTime date;
  final String formattedDate;
  final bool isToday;
  final PlanNutrition nutrition;
  final List<PlannedMeal> meals;
  final String statusNote;

  DailyMealPlan copyWith({
    DateTime? date,
    String? formattedDate,
    bool? isToday,
    PlanNutrition? nutrition,
    List<PlannedMeal>? meals,
    String? statusNote,
  }) {
    return DailyMealPlan(
      date: date ?? this.date,
      formattedDate: formattedDate ?? this.formattedDate,
      isToday: isToday ?? this.isToday,
      nutrition: nutrition ?? this.nutrition,
      meals: meals ?? this.meals,
      statusNote: statusNote ?? this.statusNote,
    );
  }
}
