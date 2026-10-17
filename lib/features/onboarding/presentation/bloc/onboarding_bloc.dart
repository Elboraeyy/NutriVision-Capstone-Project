import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/onboarding_profile.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/save_onboarding_draft.dart';

enum OnboardingStatus { editing, saving, completed, failure }

class OnboardingState {
  const OnboardingState({
    this.profile = const OnboardingProfile(),
    this.status = OnboardingStatus.editing,
    this.message,
  });

  final OnboardingProfile profile;
  final OnboardingStatus status;
  final String? message;

  OnboardingState copyWith({
    OnboardingProfile? profile,
    OnboardingStatus? status,
    String? message,
  }) {
    return OnboardingState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      message: message,
    );
  }
}

abstract class OnboardingEvent {
  const OnboardingEvent();
}

class GoalSelected extends OnboardingEvent {
  const GoalSelected(this.goal);

  final String goal;
}

class DietaryPreferenceToggled extends OnboardingEvent {
  const DietaryPreferenceToggled(this.value);

  final String value;
}

class FavoriteFoodToggled extends OnboardingEvent {
  const FavoriteFoodToggled(this.value);

  final String value;
}

class AllergyToggled extends OnboardingEvent {
  const AllergyToggled(this.value);

  final String value;
}

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}

class OnboardingDraftSaveRequested extends OnboardingEvent {
  const OnboardingDraftSaveRequested();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required OnboardingProfile initialProfile,
    required SaveOnboardingDraft saveDraft,
    required CompleteOnboarding complete,
  }) : _saveDraft = saveDraft,
       _complete = complete,
       super(OnboardingState(profile: initialProfile)) {
    on<GoalSelected>(_onGoalSelected);
    on<DietaryPreferenceToggled>(_onDietaryPreferenceToggled);
    on<FavoriteFoodToggled>(_onFavoriteFoodToggled);
    on<AllergyToggled>(_onAllergyToggled);
    on<OnboardingReset>(_onReset);
    on<OnboardingDraftSaveRequested>(_onSaveDraft);
    on<OnboardingCompleted>(_onComplete);
  }

  final SaveOnboardingDraft _saveDraft;
  final CompleteOnboarding _complete;

  Future<void> _onGoalSelected(
    GoalSelected event,
    Emitter<OnboardingState> emit,
  ) => _update(state.profile.copyWith(goal: event.goal), emit);

  Future<void> _onDietaryPreferenceToggled(
    DietaryPreferenceToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final next = {...state.profile.dietaryPreferences};
    if (event.value == 'No preference') {
      next
        ..clear()
        ..add(event.value);
    } else {
      next.remove('No preference');
      if (!next.add(event.value)) next.remove(event.value);
    }
    return _update(state.profile.copyWith(dietaryPreferences: next), emit);
  }

  Future<void> _onFavoriteFoodToggled(
    FavoriteFoodToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final next = {...state.profile.favoriteFoods};
    if (!next.add(event.value)) next.remove(event.value);
    return _update(state.profile.copyWith(favoriteFoods: next), emit);
  }

  Future<void> _onAllergyToggled(
    AllergyToggled event,
    Emitter<OnboardingState> emit,
  ) {
    if (event.value == 'None') {
      return _update(
        state.profile.copyWith(allergies: {}, noAllergies: true),
        emit,
      );
    }

    final next = {...state.profile.allergies};
    if (!next.add(event.value)) next.remove(event.value);
    return _update(
      state.profile.copyWith(allergies: next, noAllergies: false),
      emit,
    );
  }

  Future<void> _onReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
    const profile = OnboardingProfile();
    emit(const OnboardingState());
    await _saveDraft(profile);
  }

  Future<void> _onSaveDraft(
    OnboardingDraftSaveRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.saving, message: null));
    try {
      await _saveDraft(state.profile);
      emit(state.copyWith(status: OnboardingStatus.editing, message: null));
    } catch (error) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onComplete(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.saving, message: null));
    try {
      await _complete(state.profile);
      emit(state.copyWith(status: OnboardingStatus.completed, message: null));
    } catch (error) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _update(
    OnboardingProfile profile,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(profile: profile, status: OnboardingStatus.editing));
    try {
      await _saveDraft(profile);
    } catch (error) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
