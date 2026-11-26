import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/logged_meal.dart';
import '../../domain/usecases/delete_meal.dart';
import '../../domain/usecases/get_recent_meals.dart';
import '../../domain/usecases/save_meal.dart';

enum MealsStatus { initial, loading, success, failure }

sealed class MealsEvent {
  const MealsEvent();
}

final class MealsStarted extends MealsEvent {
  const MealsStarted();
}

final class MealSaveRequested extends MealsEvent {
  const MealSaveRequested(this.meal);
  final LoggedMeal meal;
}

final class MealDeleteRequested extends MealsEvent {
  const MealDeleteRequested(this.id);
  final String id;
}

class MealsState {
  const MealsState({
    this.status = MealsStatus.initial,
    this.meals = const [],
    this.selectedMeal,
    this.message,
  });

  final MealsStatus status;
  final List<LoggedMeal> meals;
  final LoggedMeal? selectedMeal;
  final String? message;

  MealsState copyWith({
    MealsStatus? status,
    List<LoggedMeal>? meals,
    LoggedMeal? selectedMeal,
    String? message,
  }) {
    return MealsState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      selectedMeal: selectedMeal ?? this.selectedMeal,
      message: message ?? this.message,
    );
  }
}

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  MealsBloc({
    required this.getRecentMeals,
    required this.saveMeal,
    required this.deleteMeal,
  }) : super(const MealsState()) {
    on<MealsStarted>(_onStarted);
    on<MealSaveRequested>(_onSaveMeal);
    on<MealDeleteRequested>(_onDeleteMeal);
  }

  final GetRecentMeals getRecentMeals;
  final SaveMeal saveMeal;
  final DeleteMeal deleteMeal;

  Future<void> _onStarted(MealsStarted event, Emitter<MealsState> emit) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      final meals = await getRecentMeals();
      emit(
        state.copyWith(
          status: MealsStatus.success,
          meals: meals,
          selectedMeal: meals.isNotEmpty ? meals.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MealsStatus.failure,
          message: 'Unable to load meals: $e',
        ),
      );
    }
  }

  Future<void> _onSaveMeal(
    MealSaveRequested event,
    Emitter<MealsState> emit,
  ) async {
    try {
      await saveMeal(event.meal);
      final meals = await getRecentMeals();
      emit(
        state.copyWith(
          status: MealsStatus.success,
          meals: meals,
          selectedMeal: event.meal,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MealsStatus.failure,
          message: 'Unable to save meal: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteMeal(
    MealDeleteRequested event,
    Emitter<MealsState> emit,
  ) async {
    try {
      await deleteMeal(event.id);
      final meals = await getRecentMeals();
      emit(
        state.copyWith(
          status: MealsStatus.success,
          meals: meals,
          selectedMeal: meals.isNotEmpty ? meals.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MealsStatus.failure,
          message: 'Unable to delete meal: $e',
        ),
      );
    }
  }
}
