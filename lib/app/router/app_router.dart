import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/allergies_screen.dart';
import '../../features/onboarding/presentation/screens/food_preferences_screen.dart';
import '../../features/onboarding/presentation/screens/goal_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
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
        builder: (context, state) => const SplashScreen(),
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
