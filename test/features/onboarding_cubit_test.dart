import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/save_onboarding_draft.dart';
import 'package:nutrivision_capstone_project/features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() {
  test('keeps onboarding choices in one shared draft', () async {
    final repository = InMemoryOnboardingRepository();
    final bloc = OnboardingBloc(
      initialProfile: repository.draft,
      saveDraft: SaveOnboardingDraft(repository),
      complete: CompleteOnboarding(repository),
    );
    addTearDown(bloc.close);

    bloc.add(const GoalSelected('Build Muscle'));
    await bloc.stream.firstWhere(
      (state) => state.profile.goal == 'Build Muscle',
    );
    bloc.add(const DietaryPreferenceToggled('Vegetarian'));
    await bloc.stream.firstWhere(
      (state) => state.profile.dietaryPreferences.contains('Vegetarian'),
    );
    bloc.add(const AllergyToggled('Peanuts'));
    await bloc.stream.firstWhere(
      (state) => state.profile.allergies.contains('Peanuts'),
    );
    final completed = bloc.stream.firstWhere(
      (state) => state.status == OnboardingStatus.completed,
    );
    bloc.add(const OnboardingCompleted());
    final state = await completed;

    expect(state.profile.goal, 'Build Muscle');
    expect(state.profile.dietaryPreferences, contains('Vegetarian'));
    expect(state.profile.allergies, contains('Peanuts'));
    expect(state.status, OnboardingStatus.completed);
    expect(repository.draft.allergies, contains('Peanuts'));
  });
}
