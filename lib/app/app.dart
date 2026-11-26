import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'observer/app_bloc_observer.dart';
import 'router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/repositories/in_memory_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/domain/usecases/sign_up.dart';
import '../features/auth/presentation/bloc/auth_session_bloc.dart';
import '../features/home/data/repositories/in_memory_home_repository.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home_dashboard.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/meals/data/repositories/in_memory_meals_repository.dart';
import '../features/meals/domain/repositories/meals_repository.dart';
import '../features/meals/domain/usecases/delete_meal.dart';
import '../features/meals/domain/usecases/get_recent_meals.dart';
import '../features/meals/domain/usecases/save_meal.dart';
import '../features/meals/presentation/bloc/meals_bloc.dart';
import '../features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import '../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../features/onboarding/domain/usecases/save_onboarding_draft.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../features/recommendations/data/repositories/in_memory_recommendations_repository.dart';
import '../features/recommendations/domain/repositories/recommendations_repository.dart';
import '../features/recommendations/domain/usecases/get_recipe_details.dart';
import '../features/recommendations/domain/usecases/get_recommended_recipes.dart';
import '../features/recommendations/domain/usecases/get_saved_recipes.dart';
import '../features/recommendations/domain/usecases/search_recipes.dart';
import '../features/recommendations/domain/usecases/toggle_save_recipe.dart';
import '../features/recommendations/presentation/bloc/recommendations_bloc.dart';
import '../features/water_tracker/data/datasources/water_local_data_source.dart';
import '../features/water_tracker/data/repositories/water_repository_impl.dart';
import '../features/water_tracker/domain/repositories/water_repository.dart';
import '../features/water_tracker/domain/usecases/add_water.dart';
import '../features/water_tracker/domain/usecases/get_today_water.dart';
import '../features/water_tracker/presentation/bloc/water_bloc.dart';

/// Root application widget.
///
/// Feature-specific repositories and blocs will be registered here as the
/// corresponding features are implemented. Keeping this composition root in
/// one place prevents dependencies from leaking into presentation widgets.
class NutriVisionApp extends StatelessWidget {
  const NutriVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => InMemoryAuthRepository(),
        ),
        RepositoryProvider<OnboardingRepository>(
          create: (_) => InMemoryOnboardingRepository(),
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
            create: (context) {
              final repository = context.read<OnboardingRepository>();
              return OnboardingBloc(
                initialProfile: repository.draft,
                saveDraft: SaveOnboardingDraft(repository),
                complete: CompleteOnboarding(repository),
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
                searchRecipes: SearchRecipes(repository),
                toggleSaveRecipe: ToggleSaveRecipe(repository),
                getSavedRecipes: GetSavedRecipes(repository),
              )..add(const RecommendationsStarted());
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'NutriVision',
          theme: AppTheme.light,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}

/// Shared access point for the app-level observer configuration.
///
/// The observer is installed from [main] so tests can replace it when needed.
final appBlocObserver = AppBlocObserver();
