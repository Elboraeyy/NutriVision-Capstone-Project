import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/meal_plan/presentation/screens/ai_plan_generate_screen.dart';
import '../../features/meal_plan/presentation/screens/edit_meal_plan_screen.dart';
import '../../features/meal_plan/presentation/screens/meal_plan_screen.dart';
import '../../features/meals/presentation/screens/analyzing_meal_screen.dart';
import '../../features/meals/presentation/screens/camera_scanner_screen.dart';
import '../../features/meals/presentation/screens/meal_details_screen.dart';
import '../../features/meals/presentation/screens/meal_screen.dart';
import '../../features/onboarding/presentation/screens/allergies_screen.dart';
import '../../features/onboarding/presentation/screens/food_preferences_screen.dart';
import '../../features/onboarding/presentation/screens/goal_screen.dart';
import '../../features/profile/presentation/screens/goals_preferences_screen.dart';
import '../../features/profile/presentation/screens/notifications_settings_screen.dart';
import '../../features/profile/presentation/screens/privacy_data_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/progress/presentation/screens/insights_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/recommendations/presentation/screens/discover_screen.dart';
import '../../features/recommendations/presentation/screens/recipe_details_screen.dart';
import '../../features/recommendations/presentation/screens/recipe_search_screen.dart';
import '../../features/recommendations/presentation/screens/saved_recipes_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/water_tracker/presentation/screens/water_tracker_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';

/// Application navigation map.
///
/// Authentication and onboarding redirects will be added here once their
/// Cubits are implemented. Screens should navigate through named routes
/// instead of creating MaterialPageRoute instances directly.
abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) =>
            SplashScreen(destination: state.uri.queryParameters['destination']),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => WelcomeScreen(
          onSignIn: () => context.pushNamed('sign-in'),
          onSignUp: () => context.pushNamed('sign-up'),
        ),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/onboarding/goal',
        name: 'onboarding-goal',
        pageBuilder: (context, state) =>
            _onboardingPage(key: state.pageKey, child: const GoalScreen()),
      ),
      GoRoute(
        path: '/onboarding/preferences',
        name: 'food-preferences',
        pageBuilder: (context, state) => _onboardingPage(
          key: state.pageKey,
          child: const FoodPreferencesScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding/allergies',
        name: 'allergies',
        pageBuilder: (context, state) =>
            _onboardingPage(key: state.pageKey, child: const AllergiesScreen()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) =>
            _onboardingPage(key: state.pageKey, child: const ProfileScreen()),
      ),
      GoRoute(
        path: '/profile/goals',
        name: 'profile-goals',
        builder: (context, state) => const GoalsPreferencesScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        name: 'profile-notifications',
        builder: (context, state) => const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        name: 'profile-privacy',
        builder: (context, state) => const PrivacyDataScreen(),
      ),
      GoRoute(
        path: '/water-tracker',
        name: 'water-tracker',
        builder: (context, state) => const WaterTrackerScreen(),
      ),
      GoRoute(
        path: '/meals/scan',
        name: 'meal-scan',
        builder: (context, state) => const CameraScannerScreen(),
      ),
      GoRoute(
        path: '/meals/analyzing',
        name: 'meal-analyzing',
        builder: (context, state) => const AnalyzingMealScreen(),
      ),
      GoRoute(
        path: '/meals/review',
        name: 'meal-review',
        builder: (context, state) => const MealScreen(),
      ),
      GoRoute(
        path: '/meals/details',
        name: 'meal-details',
        builder: (context, state) => const MealDetailsScreen(),
      ),
      GoRoute(
        path: '/recommendations/recipe',
        name: 'recipe-details',
        builder: (context, state) => const RecipeDetailsScreen(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/discover/search',
        name: 'recipe-search',
        builder: (context, state) => const RecipeSearchScreen(),
      ),
      GoRoute(
        path: '/discover/saved',
        name: 'saved-recipes',
        builder: (context, state) => const SavedRecipesScreen(),
      ),
      GoRoute(
        path: '/meal-plan',
        name: 'meal-plan',
        builder: (context, state) => const MealPlanScreen(),
      ),
      GoRoute(
        path: '/meal-plan/generate',
        name: 'ai-plan-generate',
        builder: (context, state) => const AiPlanGenerateScreen(),
      ),
      GoRoute(
        path: '/meal-plan/edit',
        name: 'edit-meal-plan',
        builder: (context, state) => const EditMealPlanScreen(),
      ),
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/progress/insights',
        name: 'insights',
        builder: (context, state) => const InsightsScreen(),
      ),
    ],
  );

  static CustomTransitionPage<void> _onboardingPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final slideAnimation = Tween<Offset>(
          begin: const Offset(.14, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
    );
  }
}
