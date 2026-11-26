import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/app/router/app_router.dart';
import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_in.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_out.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_up.dart';
import 'package:nutrivision_capstone_project/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:nutrivision_capstone_project/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/repositories/home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:nutrivision_capstone_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:nutrivision_capstone_project/features/meals/data/repositories/in_memory_meals_repository.dart';
import 'package:nutrivision_capstone_project/features/meals/domain/repositories/meals_repository.dart';
import 'package:nutrivision_capstone_project/features/meals/domain/usecases/delete_meal.dart';
import 'package:nutrivision_capstone_project/features/meals/domain/usecases/get_recent_meals.dart';
import 'package:nutrivision_capstone_project/features/meals/domain/usecases/save_meal.dart';
import 'package:nutrivision_capstone_project/features/meals/presentation/bloc/meals_bloc.dart';
import 'package:nutrivision_capstone_project/features/meals/presentation/screens/analyzing_meal_screen.dart';
import 'package:nutrivision_capstone_project/features/meals/presentation/screens/camera_scanner_screen.dart';
import 'package:nutrivision_capstone_project/features/meals/presentation/screens/meal_details_screen.dart';
import 'package:nutrivision_capstone_project/features/meals/presentation/screens/meal_screen.dart';
import 'package:nutrivision_capstone_project/features/recommendations/data/repositories/in_memory_recommendations_repository.dart';
import 'package:nutrivision_capstone_project/features/recommendations/domain/repositories/recommendations_repository.dart';
import 'package:nutrivision_capstone_project/features/recommendations/domain/usecases/get_recipe_details.dart';
import 'package:nutrivision_capstone_project/features/recommendations/domain/usecases/get_recommended_recipes.dart';
import 'package:nutrivision_capstone_project/features/recommendations/presentation/bloc/recommendations_bloc.dart';
import 'package:nutrivision_capstone_project/features/recommendations/presentation/screens/recipe_details_screen.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/data/datasources/water_local_data_source.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/data/repositories/water_repository_impl.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/domain/repositories/water_repository.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/domain/usecases/add_water.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/domain/usecases/get_today_water.dart';
import 'package:nutrivision_capstone_project/features/water_tracker/presentation/bloc/water_bloc.dart';

Widget _buildRouterTestApp() {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(
        create: (_) => InMemoryAuthRepository(),
      ),
      RepositoryProvider<HomeRepository>(
        create: (_) => InMemoryHomeRepository(),
      ),
      RepositoryProvider<WaterRepository>(
        create: (_) =>
            WaterRepositoryImpl(SharedPreferencesWaterLocalDataSource()),
      ),
      RepositoryProvider<MealsRepository>(
        create: (_) => InMemoryMealsRepository(),
      ),
      RepositoryProvider<RecommendationsRepository>(
        create: (_) => InMemoryRecommendationsRepository(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final repository = context.read<AuthRepository>();
            return AuthSessionBloc(
              repository: repository,
              signIn: SignIn(repository),
              signUp: SignUp(repository),
              signOut: SignOut(repository),
            );
          },
        ),
        BlocProvider(
          create: (context) =>
              HomeBloc(GetHomeDashboard(context.read<HomeRepository>()))
                ..add(const HomeDashboardRequested()),
        ),
        BlocProvider(
          create: (context) {
            final repository = context.read<WaterRepository>();
            return WaterBloc(
              getTodayWater: GetTodayWater(repository),
              addWater: AddWater(repository),
            )..add(const WaterTrackerStarted());
          },
        ),
        BlocProvider(
          create: (context) {
            final repository = context.read<MealsRepository>();
            return MealsBloc(
              getRecentMeals: GetRecentMeals(repository),
              saveMeal: SaveMeal(repository),
              deleteMeal: DeleteMeal(repository),
            )..add(const MealsStarted());
          },
        ),
        BlocProvider(
          create: (context) {
            final repository = context.read<RecommendationsRepository>();
            return RecommendationsBloc(
              getRecommendedRecipes: GetRecommendedRecipes(repository),
              getRecipeDetails: GetRecipeDetails(repository),
            )..add(const RecommendationsStarted());
          },
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    ),
  );
}

void _setPhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  test('AppTheme uses PlusJakartaSans font family from menna branch', () {
    expect(AppTheme.light.textTheme.bodyMedium?.fontFamily, 'PlusJakartaSans');
  });

  group('Meals Clean Architecture', () {
    test(
      'MealsRepository provides recent meals and supports save and delete',
      () async {
        final repository = InMemoryMealsRepository();
        final meals = await repository.getRecentMeals();
        expect(meals, isNotEmpty);
        expect(meals.first.name, 'Chicken & quinoa bowl');

        final sample = meals.first.copyWith(
          id: 'new-meal-id',
          name: 'Salmon Bowl',
        );
        await repository.saveMeal(sample);
        final updated = await repository.getRecentMeals();
        expect(updated.length, meals.length + 1);

        await repository.deleteMeal('new-meal-id');
        final afterDelete = await repository.getRecentMeals();
        expect(afterDelete.length, meals.length);
      },
    );

    test(
      'MealsBloc emits loaded state and handles save and delete events',
      () async {
        final repository = InMemoryMealsRepository();
        final bloc = MealsBloc(
          getRecentMeals: GetRecentMeals(repository),
          saveMeal: SaveMeal(repository),
          deleteMeal: DeleteMeal(repository),
        );
        addTearDown(bloc.close);

        final loadedStateFuture = bloc.stream.firstWhere(
          (s) => s.status == MealsStatus.success,
        );
        bloc.add(const MealsStarted());
        final loadedState = await loadedStateFuture;
        expect(loadedState.meals, isNotEmpty);
        expect(loadedState.selectedMeal?.name, 'Chicken & quinoa bowl');
      },
    );
  });

  group('Recommendations Clean Architecture', () {
    test('RecommendationsRepository returns recommended recipes', () async {
      final repository = InMemoryRecommendationsRepository();
      final recipes = await repository.getRecommendedRecipes();
      expect(recipes, isNotEmpty);
      expect(recipes.first.title, 'Lemon salmon & couscous');
      expect(recipes.first.ingredients, hasLength(8));
      expect(recipes.first.steps, hasLength(4));
    });

    test('RecommendationsBloc loads recommendations', () async {
      final repository = InMemoryRecommendationsRepository();
      final bloc = RecommendationsBloc(
        getRecommendedRecipes: GetRecommendedRecipes(repository),
        getRecipeDetails: GetRecipeDetails(repository),
      );
      addTearDown(bloc.close);

      final loadedFuture = bloc.stream.firstWhere(
        (s) => s.status == RecommendationsStatus.success,
      );
      bloc.add(const RecommendationsStarted());
      final loaded = await loadedFuture;
      expect(loaded.recipes, isNotEmpty);
      expect(loaded.selectedRecipe?.title, 'Lemon salmon & couscous');
    });
  });

  group('Integrated meal and recipe screens', () {
    testWidgets('CameraScannerScreen renders without errors', (tester) async {
      _setPhoneViewport(tester);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const CameraScannerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Scan your meal'), findsOneWidget);
      expect(find.text('Choose photo'), findsOneWidget);
      expect(find.text('Take photo'), findsOneWidget);
    });

    testWidgets('AnalyzingMealScreen renders without errors', (tester) async {
      _setPhoneViewport(tester);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const AnalyzingMealScreen()),
      );
      await tester.pump();

      expect(find.text('A closer look'), findsOneWidget);
      expect(find.text('Analyzing your photo...'), findsOneWidget);
      expect(find.text('Continue to review'), findsOneWidget);
      expect(find.text('Cancel analysis'), findsOneWidget);
    });

    testWidgets('MealScreen renders and triggers feedback callbacks', (
      tester,
    ) async {
      _setPhoneViewport(tester);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const MealScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Make it your meal'), findsOneWidget);
      expect(find.text('Grilled chicken'), findsOneWidget);
      expect(find.text('Confirm & save'), findsOneWidget);

      await tester.ensureVisible(find.text('Confirm & save'));
      await tester.tap(find.text('Confirm & save'));
      await tester.pump();
      expect(find.text('Meal saving will be connected soon.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets(
      'MealDetailsScreen renders safely without crashing on missing asset',
      (tester) async {
        _setPhoneViewport(tester);

        await tester.pumpWidget(
          MaterialApp(theme: AppTheme.light, home: const MealDetailsScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Meal details'), findsOneWidget);
        expect(find.text('Chicken & quinoa bowl'), findsOneWidget);

        await tester.ensureVisible(find.text('Delete meal'));
        await tester.tap(find.text('Delete meal'));
        await tester.pumpAndSettle();

        expect(find.text('Delete meal?'), findsOneWidget);
        await tester.tap(find.text('Delete'));
        await tester.pump();
        expect(
          find.text('Meal deletion will be connected soon.'),
          findsOneWidget,
        );
        await tester.pump(const Duration(seconds: 3));
      },
    );

    testWidgets('RecipeDetailsScreen renders and shows AppToast on add', (
      tester,
    ) async {
      _setPhoneViewport(tester);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const RecipeDetailsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recipe details'), findsOneWidget);
      expect(find.text('Lemon salmon & couscous'), findsOneWidget);

      await tester.ensureVisible(find.text('Add to Meal Plan'));
      await tester.tap(find.text('Add to Meal Plan'));
      await tester.pump();
      expect(find.text('Meal plan feature coming soon!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  testWidgets('HomeScreen navigates to integrated meal and recipe routes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    _setPhoneViewport(tester);

    AppRouter.router.goNamed('home');
    await tester.pumpWidget(_buildRouterTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan a meal'));
    await tester.pumpAndSettle();
    expect(find.byType(CameraScannerScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Take photo'));
    await tester.tap(find.text('Take photo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(AnalyzingMealScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Continue to review'));
    await tester.tap(find.text('Continue to review'));
    await tester.pumpAndSettle();
    expect(find.byType(MealScreen), findsOneWidget);

    AppRouter.router.goNamed('home');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Chicken & quinoa bowl'));
    await tester.tap(find.text('Chicken & quinoa bowl'));
    await tester.pumpAndSettle();
    expect(find.byType(MealDetailsScreen), findsOneWidget);

    AppRouter.router.goNamed('home');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Discover'));
    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeDetailsScreen), findsOneWidget);
  });
}
