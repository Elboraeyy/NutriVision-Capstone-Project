import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/sign_in_screen.dart';
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
          onSignIn: () => context.goNamed('sign-in'),
        ),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
}
