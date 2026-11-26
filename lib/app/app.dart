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
import '../features/meal_plan/data/repositories/in_memory_meal_plan_repository.dart';
import '../features/meal_plan/domain/repositories/meal_plan_repository.dart';
import '../features/meal_plan/domain/usecases/approve_meal_plan.dart';
import '../features/meal_plan/domain/usecases/cycle_alternative_meal.dart';
import '../features/meal_plan/domain/usecases/generate_ai_meal_plan.dart';
import '../features/meal_plan/domain/usecases/get_meal_plan.dart';
import '../features/meal_plan/presentation/bloc/meal_plan_bloc.dart';
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
import '../features/profile/data/repositories/in_memory_profile_repository.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/delete_account_data.dart';
import '../features/profile/domain/usecases/get_user_profile.dart';
import '../features/profile/domain/usecases/request_data_export.dart';
import '../features/profile/domain/usecases/update_goals_and_preferences.dart';
import '../features/profile/domain/usecases/update_notification_preferences.dart';
import '../features/profile/domain/usecases/update_privacy_preferences.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/progress/data/repositories/in_memory_progress_repository.dart';
import '../features/progress/domain/repositories/progress_repository.dart';
import '../features/progress/domain/usecases/get_progress_snapshot.dart';
import '../features/progress/presentation/bloc/progress_bloc.dart';
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
        RepositoryProvider<MealPlanRepository>(
          create: (_) => InMemoryMealPlanRepository(),
        ),
        RepositoryProvider<ProgressRepository>(
          create: (_) => InMemoryProgressRepository(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => InMemoryProfileRepository(
            onboardingRepository: context.read<OnboardingRepository>(),
          ),
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
          BlocProvider(
            create: (context) {
              final repository = context.read<MealPlanRepository>();
              return MealPlanBloc(
                getMealPlan: GetMealPlan(repository),
                generateAiMealPlan: GenerateAiMealPlan(repository),
                cycleAlternativeMeal: CycleAlternativeMeal(repository),
                approveMealPlan: ApproveMealPlan(repository),
              )..add(const MealPlanStarted());
            },
          ),
          BlocProvider(
            create: (context) {
              final repository = context.read<ProgressRepository>();
              return ProgressBloc(
                getProgressSnapshot: GetProgressSnapshot(repository),
              )..add(const ProgressStarted());
            },
          ),
          BlocProvider(
            create: (context) {
              final repository = context.read<ProfileRepository>();
              return ProfileBloc(
                getUserProfile: GetUserProfile(repository),
                updateGoalsAndPreferences: UpdateGoalsAndPreferences(
                  repository,
                ),
                updateNotificationPreferences: UpdateNotificationPreferences(
                  repository,
                ),
                updatePrivacyPreferences: UpdatePrivacyPreferences(repository),
                requestDataExport: RequestDataExport(repository),
                deleteAccountData: DeleteAccountData(repository),
              )..add(const ProfileLoadRequested());
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
