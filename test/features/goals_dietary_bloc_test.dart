import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/features/onboarding/domain/entities/onboarding_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/data/datasources/goals_dietary_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/models/goals_dietary_preferences_model.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_goals_dietary_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/save_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/goals_dietary_bloc.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('DailyTargets initializes all five targets to zero by default', () {
    const targets = DailyTargets();
    expect(targets.calories, 0);
    expect(targets.protein, 0);
    expect(targets.carbohydrates, 0);
    expect(targets.fat, 0);
    expect(targets.water, 0);
    expect(targets.validate(), isNull);
  });

  test('DailyTargets rejects negative values', () {
    const negativeTargets = DailyTargets(calories: -10);
    expect(negativeTargets.validate(), isNotNull);
  });

  test(
    'GoalsDietaryPreferencesModel & Repository persist and restore round-trip',
    () async {
      final repository = LocalGoalsDietaryRepository(
        localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
      );

      expect(await repository.getSavedPreferences(), isNull);

      const prefs = GoalsDietaryPreferences(
        goal: 'Build Muscle',
        allergies: ['Peanuts', 'Soy'],
        dailyTargets: DailyTargets(
          calories: 2200,
          protein: 150,
          carbohydrates: 240,
          fat: 70,
          water: 2500,
        ),
        dietaryPattern: 'Vegetarian',
        excludedIngredients: ['Alcohol', 'Added sugar'],
        likedFoods: ['Oats', 'Lentils'],
      );

      await repository.savePreferences(prefs);
      final restored = await repository.getSavedPreferences();
      expect(restored, prefs);
    },
  );

  test(
    'GoalsDietaryPreferencesModel.tryDecode returns null for corrupt JSON',
    () {
      expect(GoalsDietaryPreferencesModel.tryDecode('not-json'), isNull);
      expect(GoalsDietaryPreferencesModel.tryDecode('[]'), isNull);
      expect(GoalsDietaryPreferencesModel.tryDecode(''), isNull);
    },
  );

  test(
    'SaveGoalsDietaryPreferences dedupes items and blocks liked foods conflicting with allergies',
    () async {
      final repository = LocalGoalsDietaryRepository(
        localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
      );
      final useCase = SaveGoalsDietaryPreferences(repository);

      final saved = await useCase(
        const GoalsDietaryPreferences(
          goal: 'Eat Healthier',
          allergies: ['Peanuts', 'peanuts', 'Soy'],
          dailyTargets: DailyTargets(calories: 1800),
          dietaryPattern: 'Flexitarian',
          excludedIngredients: ['Alcohol', 'alcohol'],
          likedFoods: ['Oats', 'Peanuts', 'Berries', 'oats'],
        ),
      );

      expect(saved.allergies, ['Peanuts', 'Soy']);
      expect(saved.excludedIngredients, ['Alcohol']);
      expect(saved.likedFoods, ['Oats', 'Berries']);
    },
  );

  test(
    'GoalsDietaryBloc initializes all targets to zero and preserves onboarding values',
    () async {
      final repository = LocalGoalsDietaryRepository(
        localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
      );
      final bloc = GoalsDietaryBloc(
        getPreferences: GetGoalsDietaryPreferences(repository),
        savePreferences: SaveGoalsDietaryPreferences(repository),
      );

      bloc.add(
        const GoalsDietaryStarted(
          onboardingProfile: OnboardingProfile(
            goal: 'Build Muscle',
            dietaryPreferences: {'Pescatarian'},
            favoriteFoods: {'Salmon', 'Rice'},
            allergies: {'Shellfish'},
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.status == GoalsDietaryStatus.ready);

      final draft = bloc.state.draftPreferences;
      expect(draft.goal, 'Build Muscle');
      expect(draft.dietaryPattern, 'Pescatarian');
      expect(draft.likedFoods, ['Salmon', 'Rice']);
      expect(draft.allergies, ['Shellfish']);
      expect(draft.dailyTargets, const DailyTargets());
      expect(draft.dailyTargets.calories, 0);
      expect(draft.dailyTargets.protein, 0);
      expect(draft.dailyTargets.carbohydrates, 0);
      expect(draft.dailyTargets.fat, 0);
      expect(draft.dailyTargets.water, 0);

      await bloc.close();
    },
  );

  test(
    'GoalsDietaryBloc supports draft edits, cancel rollback, and save persistence',
    () async {
      final repository = LocalGoalsDietaryRepository(
        localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
      );
      final bloc = GoalsDietaryBloc(
        getPreferences: GetGoalsDietaryPreferences(repository),
        savePreferences: SaveGoalsDietaryPreferences(repository),
      );

      bloc.add(const GoalsDietaryStarted());
      await bloc.stream.firstWhere((s) => s.status == GoalsDietaryStatus.ready);

      bloc.add(const GoalPreferenceChanged('Lose Weight'));
      bloc.add(
        const DailyTargetUpdated(field: DailyTargetField.calories, value: 1900),
      );
      bloc.add(const DietaryPatternChanged('Vegan'));
      await pumpEventQueue();
      expect(bloc.state.hasUnsavedChanges, isTrue);
      expect(await repository.getSavedPreferences(), isNull);

      // Cancel discards draft changes without saving.
      bloc.add(const GoalsDietaryChangesCancelled());
      await pumpEventQueue();
      expect(bloc.state.hasUnsavedChanges, isFalse);
      expect(bloc.state.draftPreferences.goal, 'Eat Healthier');
      expect(bloc.state.draftPreferences.dailyTargets.calories, 0);
      expect(bloc.state.draftPreferences.dietaryPattern, 'Flexitarian');
      expect(await repository.getSavedPreferences(), isNull);

      // Edit again and save.
      bloc.add(
        const DailyTargetUpdated(field: DailyTargetField.protein, value: 110),
      );
      bloc.add(const GoalsDietarySaved());
      await bloc.stream.firstWhere((s) => s.status == GoalsDietaryStatus.saved);

      expect(bloc.state.hasUnsavedChanges, isFalse);
      final persisted = await repository.getSavedPreferences();
      expect(persisted?.dailyTargets.protein, 110);
      expect(persisted?.dailyTargets.calories, 0);

      await bloc.close();
    },
  );

  test(
    'GoalsDietaryBloc rejects negative target and prevents liked foods overriding allergies',
    () async {
      final repository = LocalGoalsDietaryRepository(
        localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
      );
      final bloc = GoalsDietaryBloc(
        getPreferences: GetGoalsDietaryPreferences(repository),
        savePreferences: SaveGoalsDietaryPreferences(repository),
      );

      bloc.add(const GoalsDietaryStarted());
      await bloc.stream.firstWhere((s) => s.status == GoalsDietaryStatus.ready);

      bloc.add(
        const DailyTargetUpdated(field: DailyTargetField.fat, value: -5),
      );
      await pumpEventQueue();
      expect(bloc.state.status, GoalsDietaryStatus.failure);
      expect(bloc.state.draftPreferences.dailyTargets.fat, 0);

      bloc.add(const LikedFoodsUpdated(['Oats', 'Peanuts']));
      await pumpEventQueue();
      expect(bloc.state.draftPreferences.likedFoods, ['Oats']);
      expect(bloc.state.message, contains('Peanuts'));

      await bloc.close();
    },
  );
}
