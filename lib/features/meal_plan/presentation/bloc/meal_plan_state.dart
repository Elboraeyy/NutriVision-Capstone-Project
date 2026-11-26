import '../../domain/entities/daily_meal_plan.dart';

enum MealPlanStatus { initial, loading, success, failure }

/// State representation for meal plan flows.
class MealPlanState {
  const MealPlanState({
    this.status = MealPlanStatus.initial,
    this.activePlan,
    this.draftPlan,
    required this.selectedDate,
    this.isGeneratingAi = false,
    this.isCyclingMeal = false,
    this.cyclingMealId,
    this.errorMessage,
    this.feedbackMessage,
  });

  final MealPlanStatus status;
  final DailyMealPlan? activePlan;
  final DailyMealPlan? draftPlan;
  final DateTime selectedDate;
  final bool isGeneratingAi;
  final bool isCyclingMeal;
  final String? cyclingMealId;
  final String? errorMessage;
  final String? feedbackMessage;

  MealPlanState copyWith({
    MealPlanStatus? status,
    DailyMealPlan? activePlan,
    DailyMealPlan? draftPlan,
    DateTime? selectedDate,
    bool? isGeneratingAi,
    bool? isCyclingMeal,
    String? cyclingMealId,
    String? errorMessage,
    String? feedbackMessage,
    bool clearDraft = false,
  }) {
    return MealPlanState(
      status: status ?? this.status,
      activePlan: activePlan ?? this.activePlan,
      draftPlan: clearDraft ? null : (draftPlan ?? this.draftPlan),
      selectedDate: selectedDate ?? this.selectedDate,
      isGeneratingAi: isGeneratingAi ?? this.isGeneratingAi,
      isCyclingMeal: isCyclingMeal ?? this.isCyclingMeal,
      cyclingMealId: cyclingMealId ?? this.cyclingMealId,
      errorMessage: errorMessage,
      feedbackMessage: feedbackMessage,
    );
  }
}
