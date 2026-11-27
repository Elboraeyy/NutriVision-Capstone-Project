import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/entities/onboarding_profile.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/save_onboarding_draft.dart';
import 'package:nutrivision_capstone_project/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_goals_dietary_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/save_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('completes onboarding into user-scoped profile preferences', () async {
    final repository = InMemoryOnboardingRepository();
    final goalsRepository = LocalGoalsDietaryRepository();
    final bloc = OnboardingBloc(
      initialProfile: repository.draft,
      saveDraft: SaveOnboardingDraft(repository),
      complete: CompleteOnboarding(
        repository,
        getPreferences: GetGoalsDietaryPreferences(goalsRepository),
        savePreferences: SaveGoalsDietaryPreferences(goalsRepository),
      ),
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
    bloc.add(const OnboardingCompleted(userId: 'nancy@example.com'));
    final state = await completed;

    expect(state.profile.goal, 'Build Muscle');
    expect(state.profile.dietaryPreferences, contains('Vegetarian'));
    expect(state.profile.allergies, contains('Peanuts'));
    expect(state.status, OnboardingStatus.completed);
    expect(repository.draft.allergies, contains('Peanuts'));
    final saved = await GetGoalsDietaryPreferences(goalsRepository)(
      userId: 'nancy@example.com',
    );
    expect(saved?.goal, 'Build Muscle');
    expect(saved?.dietaryPattern, 'Vegetarian');
    expect(saved?.allergies, ['Peanuts']);
    expect(
      await GetGoalsDietaryPreferences(goalsRepository)(userId: 'other-user'),
      isNull,
    );
  });

  test('None clears allergies and saves an empty allergy list', () async {
    final onboardingRepository = InMemoryOnboardingRepository();
    final goalsRepository = LocalGoalsDietaryRepository();
    final bloc = OnboardingBloc(
      initialProfile: onboardingRepository.draft,
      saveDraft: SaveOnboardingDraft(onboardingRepository),
      complete: CompleteOnboarding(
        onboardingRepository,
        getPreferences: GetGoalsDietaryPreferences(goalsRepository),
        savePreferences: SaveGoalsDietaryPreferences(goalsRepository),
      ),
    );
    addTearDown(bloc.close);

    bloc.add(const AllergyToggled('Peanuts'));
    await bloc.stream.firstWhere((state) => state.profile.allergies.isNotEmpty);
    bloc.add(const AllergyToggled('None'));
    await bloc.stream.firstWhere((state) => state.profile.noAllergies);
    final completed = bloc.stream.firstWhere(
      (state) => state.status == OnboardingStatus.completed,
    );
    bloc.add(const OnboardingCompleted(userId: 'user-with-none'));
    await completed;

    final saved = await GetGoalsDietaryPreferences(goalsRepository)(
      userId: 'user-with-none',
    );
    expect(saved?.allergies, isEmpty);
  });

  test(
    'preferences remain attached to the user after sign out and sign in',
    () async {
      final auth = InMemoryAuthRepository();
      final user = await auth.signUp(
        name: 'Nancy',
        email: 'nancy@example.com',
        password: 'Password1',
      );
      final goalsRepository = LocalGoalsDietaryRepository();
      final completion = CompleteOnboarding(
        InMemoryOnboardingRepository(),
        getPreferences: GetGoalsDietaryPreferences(goalsRepository),
        savePreferences: SaveGoalsDietaryPreferences(goalsRepository),
      );
      const profile = OnboardingProfile(
        goal: 'Maintain Weight',
        dietaryPreferences: {'Vegan'},
        favoriteFoods: {'Lentils'},
        noAllergies: true,
      );
      await completion(profile, userId: user.id);

      await auth.signOut();
      final restoredUser = await auth.signIn(
        email: 'nancy@example.com',
        password: 'Password1',
      );
      final saved = await GetGoalsDietaryPreferences(goalsRepository)(
        userId: restoredUser.id,
      );

      expect(saved?.goal, 'Maintain Weight');
      expect(saved?.dietaryPattern, 'Vegan');
      expect(saved?.likedFoods, ['Lentils']);
      expect(saved?.allergies, isEmpty);
    },
  );
}
