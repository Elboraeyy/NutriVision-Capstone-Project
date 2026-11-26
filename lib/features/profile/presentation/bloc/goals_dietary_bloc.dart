import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../onboarding/domain/entities/onboarding_profile.dart';
import '../../domain/entities/goals_dietary_preferences.dart';
import '../../domain/usecases/get_goals_dietary_preferences.dart';
import '../../domain/usecases/save_goals_dietary_preferences.dart';

enum GoalsDietaryStatus { initial, loading, ready, saving, saved, failure }

enum DailyTargetField { calories, protein, carbohydrates, fat, water }

class GoalsDietaryState {
  const GoalsDietaryState({
    this.status = GoalsDietaryStatus.initial,
    this.savedPreferences = const GoalsDietaryPreferences(),
    this.draftPreferences = const GoalsDietaryPreferences(),
    this.hasPersistedPreferences = false,
    this.message,
  });

  final GoalsDietaryStatus status;
  final GoalsDietaryPreferences savedPreferences;
  final GoalsDietaryPreferences draftPreferences;
  final bool hasPersistedPreferences;
  final String? message;

  bool get hasUnsavedChanges => draftPreferences != savedPreferences;

  GoalsDietaryState copyWith({
    GoalsDietaryStatus? status,
    GoalsDietaryPreferences? savedPreferences,
    GoalsDietaryPreferences? draftPreferences,
    bool? hasPersistedPreferences,
    String? message,
    bool clearMessage = false,
  }) {
    return GoalsDietaryState(
      status: status ?? this.status,
      savedPreferences: savedPreferences ?? this.savedPreferences,
      draftPreferences: draftPreferences ?? this.draftPreferences,
      hasPersistedPreferences:
          hasPersistedPreferences ?? this.hasPersistedPreferences,
      message: clearMessage ? null : message,
    );
  }
}

abstract class GoalsDietaryEvent {
  const GoalsDietaryEvent();
}

class GoalsDietaryStarted extends GoalsDietaryEvent {
  const GoalsDietaryStarted({this.onboardingProfile});

  final OnboardingProfile? onboardingProfile;
}

class GoalPreferenceChanged extends GoalsDietaryEvent {
  const GoalPreferenceChanged(this.goal);

  final String goal;
}

class AllergiesUpdated extends GoalsDietaryEvent {
  const AllergiesUpdated(this.allergies);

  final List<String> allergies;
}

class DailyTargetUpdated extends GoalsDietaryEvent {
  const DailyTargetUpdated({required this.field, required this.value});

  final DailyTargetField field;
  final int value;
}

class DietaryPatternChanged extends GoalsDietaryEvent {
  const DietaryPatternChanged(this.pattern);

  final String pattern;
}

class ExcludedIngredientsUpdated extends GoalsDietaryEvent {
  const ExcludedIngredientsUpdated(this.ingredients);

  final List<String> ingredients;
}

class LikedFoodsUpdated extends GoalsDietaryEvent {
  const LikedFoodsUpdated(this.foods);

  final List<String> foods;
}

class GoalsDietaryChangesCancelled extends GoalsDietaryEvent {
  const GoalsDietaryChangesCancelled();
}

class GoalsDietarySaved extends GoalsDietaryEvent {
  const GoalsDietarySaved();
}

class GoalsDietaryBloc extends Bloc<GoalsDietaryEvent, GoalsDietaryState> {
  GoalsDietaryBloc({
    required GetGoalsDietaryPreferences getPreferences,
    required SaveGoalsDietaryPreferences savePreferences,
  }) : _getPreferences = getPreferences,
       _savePreferences = savePreferences,
       super(const GoalsDietaryState()) {
    on<GoalsDietaryStarted>(_onStarted);
    on<GoalPreferenceChanged>(_onGoalChanged);
    on<AllergiesUpdated>(_onAllergiesUpdated);
    on<DailyTargetUpdated>(_onDailyTargetUpdated);
    on<DietaryPatternChanged>(_onDietaryPatternChanged);
    on<ExcludedIngredientsUpdated>(_onExcludedIngredientsUpdated);
    on<LikedFoodsUpdated>(_onLikedFoodsUpdated);
    on<GoalsDietaryChangesCancelled>(_onCancelled);
    on<GoalsDietarySaved>(_onSaved);
  }

  final GetGoalsDietaryPreferences _getPreferences;
  final SaveGoalsDietaryPreferences _savePreferences;

  Future<void> _onStarted(
    GoalsDietaryStarted event,
    Emitter<GoalsDietaryState> emit,
  ) async {
    emit(
      state.copyWith(status: GoalsDietaryStatus.loading, clearMessage: true),
    );
    try {
      final saved = await _getPreferences();
      final baseline =
          saved ?? _buildInitialPreferences(event.onboardingProfile);
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.ready,
          savedPreferences: baseline,
          draftPreferences: baseline,
          hasPersistedPreferences: saved != null,
          clearMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.failure,
          message: 'Unable to load your goals and dietary preferences.',
        ),
      );
    }
  }

  GoalsDietaryPreferences _buildInitialPreferences(
    OnboardingProfile? onboarding,
  ) {
    if (onboarding == null) {
      return const GoalsDietaryPreferences();
    }

    final rawGoal = onboarding.goal?.trim();
    final goal = rawGoal != null && rawGoal.isNotEmpty
        ? _normalizeGoal(rawGoal)
        : GoalsDietaryPreferences.defaultGoal;

    final List<String> allergies;
    if (onboarding.noAllergies) {
      allergies = const [];
    } else if (onboarding.allergies.isNotEmpty) {
      allergies = onboarding.allergies.toList();
    } else {
      allergies = GoalsDietaryPreferences.defaultAllergies;
    }

    final dietaryPattern = onboarding.dietaryPreferences.isNotEmpty
        ? onboarding.dietaryPreferences.first
        : GoalsDietaryPreferences.defaultDietaryPattern;

    final likedFoods = onboarding.favoriteFoods.isNotEmpty
        ? onboarding.favoriteFoods.toList()
        : GoalsDietaryPreferences.defaultLikedFoods;

    return GoalsDietaryPreferences(
      goal: goal,
      allergies: allergies,
      // All five daily targets MUST initialize to zero for a new profile.
      dailyTargets: const DailyTargets(),
      dietaryPattern: dietaryPattern,
      excludedIngredients: GoalsDietaryPreferences.defaultExcludedIngredients,
      likedFoods: likedFoods,
    );
  }

  String _normalizeGoal(String goal) {
    for (final available in GoalsDietaryPreferences.availableGoals) {
      if (available.toLowerCase() == goal.toLowerCase()) {
        return available;
      }
    }
    return goal;
  }

  void _onGoalChanged(
    GoalPreferenceChanged event,
    Emitter<GoalsDietaryState> emit,
  ) {
    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.draftPreferences.copyWith(goal: event.goal),
        clearMessage: true,
      ),
    );
  }

  void _onAllergiesUpdated(
    AllergiesUpdated event,
    Emitter<GoalsDietaryState> emit,
  ) {
    final cleanedAllergies = _dedupe(event.allergies);
    final updatedWithAllergies = state.draftPreferences.copyWith(
      allergies: cleanedAllergies,
    );
    // Keep allergy restrictions enforced: remove any liked food that conflicts
    // with the updated allergy list.
    final filteredLiked = state.draftPreferences.likedFoods
        .where((food) => !updatedWithAllergies.conflictsWithAllergies(food))
        .toList();

    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: updatedWithAllergies.copyWith(
          likedFoods: filteredLiked,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onDailyTargetUpdated(
    DailyTargetUpdated event,
    Emitter<GoalsDietaryState> emit,
  ) {
    if (event.value < 0) {
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.failure,
          message: 'Daily targets cannot be negative.',
        ),
      );
      return;
    }

    final current = state.draftPreferences.dailyTargets;
    final updatedTargets = switch (event.field) {
      DailyTargetField.calories => current.copyWith(calories: event.value),
      DailyTargetField.protein => current.copyWith(protein: event.value),
      DailyTargetField.carbohydrates => current.copyWith(
        carbohydrates: event.value,
      ),
      DailyTargetField.fat => current.copyWith(fat: event.value),
      DailyTargetField.water => current.copyWith(water: event.value),
    };

    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.draftPreferences.copyWith(
          dailyTargets: updatedTargets,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onDietaryPatternChanged(
    DietaryPatternChanged event,
    Emitter<GoalsDietaryState> emit,
  ) {
    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.draftPreferences.copyWith(
          dietaryPattern: event.pattern,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onExcludedIngredientsUpdated(
    ExcludedIngredientsUpdated event,
    Emitter<GoalsDietaryState> emit,
  ) {
    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.draftPreferences.copyWith(
          excludedIngredients: _dedupe(event.ingredients),
        ),
        clearMessage: true,
      ),
    );
  }

  void _onLikedFoodsUpdated(
    LikedFoodsUpdated event,
    Emitter<GoalsDietaryState> emit,
  ) {
    final cleaned = _dedupe(event.foods);
    final blocked = cleaned
        .where((food) => state.draftPreferences.conflictsWithAllergies(food))
        .toList();
    final allowed = cleaned
        .where((food) => !state.draftPreferences.conflictsWithAllergies(food))
        .toList();

    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.draftPreferences.copyWith(likedFoods: allowed),
        message: blocked.isNotEmpty
            ? '${blocked.join(', ')} cannot be added because of your allergy restrictions.'
            : null,
        clearMessage: blocked.isEmpty,
      ),
    );
  }

  void _onCancelled(
    GoalsDietaryChangesCancelled event,
    Emitter<GoalsDietaryState> emit,
  ) {
    final hadChanges = state.hasUnsavedChanges;
    emit(
      state.copyWith(
        status: GoalsDietaryStatus.ready,
        draftPreferences: state.savedPreferences,
        message: hadChanges ? 'Unsaved changes discarded.' : null,
        clearMessage: !hadChanges,
      ),
    );
  }

  Future<void> _onSaved(
    GoalsDietarySaved event,
    Emitter<GoalsDietaryState> emit,
  ) async {
    emit(state.copyWith(status: GoalsDietaryStatus.saving, clearMessage: true));
    try {
      final saved = await _savePreferences(state.draftPreferences);
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.saved,
          savedPreferences: saved,
          draftPreferences: saved,
          hasPersistedPreferences: true,
          message: 'Goals & dietary preferences saved.',
        ),
      );
    } on GoalsDietaryValidationException catch (error) {
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.failure,
          message: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: GoalsDietaryStatus.failure,
          message: 'Unable to save your goals and dietary preferences.',
        ),
      );
    }
  }

  List<String> _dedupe(List<String> items) {
    final seen = <String>{};
    final result = <String>[];
    for (final raw in items) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (seen.add(trimmed.toLowerCase())) {
        result.add(trimmed);
      }
    }
    return result;
  }
}
