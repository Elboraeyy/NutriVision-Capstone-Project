import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plan_nutrition.dart';
import '../../domain/usecases/approve_meal_plan.dart';
import '../../domain/usecases/cycle_alternative_meal.dart';
import '../../domain/usecases/generate_ai_meal_plan.dart';
import '../../domain/usecases/get_meal_plan.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

export 'meal_plan_event.dart';
export 'meal_plan_state.dart';

/// Bloc managing daily meal plans, AI draft generation, meal cycling, and plan approval.
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc({
    required this.getMealPlan,
    required this.generateAiMealPlan,
    required this.cycleAlternativeMeal,
    required this.approveMealPlan,
  }) : super(MealPlanState(selectedDate: DateTime.now())) {
    on<MealPlanStarted>(_onStarted);
    on<MealPlanDateChanged>(_onDateChanged);
    on<MealPlanAiGenerationRequested>(_onAiGenerationRequested);
    on<MealPlanAlternativeCycled>(_onAlternativeCycled);
    on<MealPlanMealReplaced>(_onMealReplaced);
    on<MealPlanApproved>(_onApproved);
  }

  final GetMealPlan getMealPlan;
  final GenerateAiMealPlan generateAiMealPlan;
  final CycleAlternativeMeal cycleAlternativeMeal;
  final ApproveMealPlan approveMealPlan;

  Future<void> _onStarted(
    MealPlanStarted event,
    Emitter<MealPlanState> emit,
  ) async {
    final targetDate = event.date ?? state.selectedDate;
    emit(
      state.copyWith(status: MealPlanStatus.loading, selectedDate: targetDate),
    );

    try {
      final plan = await getMealPlan(targetDate);
      emit(state.copyWith(status: MealPlanStatus.success, activePlan: plan));
    } catch (e) {
      emit(
        state.copyWith(
          status: MealPlanStatus.failure,
          errorMessage: 'Failed to load meal plan: $e',
        ),
      );
    }
  }

  Future<void> _onDateChanged(
    MealPlanDateChanged event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MealPlanStatus.loading,
        selectedDate: event.newDate,
      ),
    );

    try {
      final plan = await getMealPlan(event.newDate);
      emit(state.copyWith(status: MealPlanStatus.success, activePlan: plan));
    } catch (e) {
      emit(
        state.copyWith(
          status: MealPlanStatus.failure,
          errorMessage: 'Failed to load plan for date: $e',
        ),
      );
    }
  }

  Future<void> _onAiGenerationRequested(
    MealPlanAiGenerationRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(state.copyWith(isGeneratingAi: true, errorMessage: null));

    try {
      final draft = await generateAiMealPlan(
        goal: event.goal,
        durationDays: event.durationDays,
        availableFoods: event.availableFoods,
        mealPattern: event.mealPattern,
      );

      emit(
        state.copyWith(
          isGeneratingAi: false,
          draftPlan: draft,
          feedbackMessage: 'Generated draft plan tailored to your profile!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isGeneratingAi: false,
          errorMessage: 'Failed to generate AI plan: $e',
        ),
      );
    }
  }

  Future<void> _onAlternativeCycled(
    MealPlanAlternativeCycled event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(state.copyWith(isCyclingMeal: true, cyclingMealId: event.mealId));

    try {
      final newMeal = await cycleAlternativeMeal(event.mealId);

      if (event.isForDraft && state.draftPlan != null) {
        final currentDraft = state.draftPlan!;
        final updatedMeals = currentDraft.meals.map((m) {
          return m.id == event.mealId ? newMeal : m;
        }).toList();

        final recalculatedNutrition = _recalculateNutrition(
          updatedMeals,
          currentDraft.nutrition,
        );

        emit(
          state.copyWith(
            isCyclingMeal: false,
            cyclingMealId: null,
            draftPlan: currentDraft.copyWith(
              meals: updatedMeals,
              nutrition: recalculatedNutrition,
            ),
            feedbackMessage: 'Swapped ${newMeal.title}',
          ),
        );
      } else if (state.activePlan != null) {
        final currentActive = state.activePlan!;
        final updatedMeals = currentActive.meals.map((m) {
          return m.id == event.mealId ? newMeal : m;
        }).toList();

        final recalculatedNutrition = _recalculateNutrition(
          updatedMeals,
          currentActive.nutrition,
        );

        emit(
          state.copyWith(
            isCyclingMeal: false,
            cyclingMealId: null,
            activePlan: currentActive.copyWith(
              meals: updatedMeals,
              nutrition: recalculatedNutrition,
            ),
            feedbackMessage: 'Swapped ${newMeal.title}',
          ),
        );
      } else {
        emit(state.copyWith(isCyclingMeal: false, cyclingMealId: null));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isCyclingMeal: false,
          cyclingMealId: null,
          errorMessage: 'Failed to cycle alternative meal: $e',
        ),
      );
    }
  }

  Future<void> _onMealReplaced(
    MealPlanMealReplaced event,
    Emitter<MealPlanState> emit,
  ) async {
    if (event.isForDraft && state.draftPlan != null) {
      final currentDraft = state.draftPlan!;
      final updatedMeals = currentDraft.meals.map((m) {
        return m.id == event.mealId ? event.newMeal : m;
      }).toList();

      final nutrition = _recalculateNutrition(
        updatedMeals,
        currentDraft.nutrition,
      );

      emit(
        state.copyWith(
          draftPlan: currentDraft.copyWith(
            meals: updatedMeals,
            nutrition: nutrition,
          ),
          feedbackMessage: 'Meal replaced with ${event.newMeal.title}',
        ),
      );
    } else if (state.activePlan != null) {
      final currentActive = state.activePlan!;
      final updatedMeals = currentActive.meals.map((m) {
        return m.id == event.mealId ? event.newMeal : m;
      }).toList();

      final nutrition = _recalculateNutrition(
        updatedMeals,
        currentActive.nutrition,
      );

      emit(
        state.copyWith(
          activePlan: currentActive.copyWith(
            meals: updatedMeals,
            nutrition: nutrition,
          ),
          feedbackMessage: 'Meal replaced with ${event.newMeal.title}',
        ),
      );
    }
  }

  Future<void> _onApproved(
    MealPlanApproved event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(state.copyWith(status: MealPlanStatus.loading));
    try {
      await approveMealPlan(event.plan);
      emit(
        state.copyWith(
          status: MealPlanStatus.success,
          activePlan: event.plan.copyWith(
            statusNote: '4 planned meals · Approved',
          ),
          clearDraft: true,
          feedbackMessage: 'Plan approved and saved to your schedule!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MealPlanStatus.failure,
          errorMessage: 'Failed to approve plan: $e',
        ),
      );
    }
  }

  PlanNutrition _recalculateNutrition(
    List<dynamic> meals,
    PlanNutrition current,
  ) {
    var totalCal = 0;
    var totalP = 0;
    var totalC = 0;
    var totalF = 0;

    for (final m in meals) {
      totalCal += (m.calories as int);
      totalP += int.tryParse(m.protein.replaceAll('g', '')) ?? 0;
      totalC += int.tryParse(m.carbs.replaceAll('g', '')) ?? 0;
      totalF += int.tryParse(m.fat.replaceAll('g', '')) ?? 0;
    }

    return PlanNutrition(
      calories: totalCal,
      targetCalories: current.targetCalories,
      proteinGrams: totalP,
      targetProteinGrams: current.targetProteinGrams,
      carbsGrams: totalC,
      targetCarbsGrams: current.targetCarbsGrams,
      fatGrams: totalF,
      targetFatGrams: current.targetFatGrams,
    );
  }
}
