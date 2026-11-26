import '../../domain/entities/daily_meal_plan.dart';
import '../../domain/entities/planned_meal.dart';

/// Base event for [MealPlanBloc].
abstract class MealPlanEvent {
  const MealPlanEvent();
}

/// Dispatched to load the plan for a date.
class MealPlanStarted extends MealPlanEvent {
  const MealPlanStarted([this.date]);

  final DateTime? date;
}

/// Dispatched to change the selected date.
class MealPlanDateChanged extends MealPlanEvent {
  const MealPlanDateChanged(this.newDate);

  final DateTime newDate;
}

/// Dispatched when the user requests an AI-generated meal plan draft.
class MealPlanAiGenerationRequested extends MealPlanEvent {
  const MealPlanAiGenerationRequested({
    this.goal = 'Fat loss & muscle retain (1,850 kcal/day)',
    this.durationDays = 1,
    this.availableFoods = const [
      'Chicken breast',
      'Rolled oats',
      'Greek yogurt',
      'Salmon',
      'Chickpeas',
    ],
    this.mealPattern = '3 meals + 1 snack',
  });

  final String goal;
  final int durationDays;
  final List<String> availableFoods;
  final String mealPattern;
}

/// Dispatched to cycle an alternative meal for a meal slot.
class MealPlanAlternativeCycled extends MealPlanEvent {
  const MealPlanAlternativeCycled({
    required this.mealId,
    this.isForDraft = false,
  });

  final String mealId;
  final bool isForDraft;
}

/// Dispatched to replace a meal with a specific item.
class MealPlanMealReplaced extends MealPlanEvent {
  const MealPlanMealReplaced({
    required this.mealId,
    required this.newMeal,
    this.isForDraft = false,
  });

  final String mealId;
  final PlannedMeal newMeal;
  final bool isForDraft;
}

/// Dispatched when approving and saving the draft plan.
class MealPlanApproved extends MealPlanEvent {
  const MealPlanApproved(this.plan);

  final DailyMealPlan plan;
}
