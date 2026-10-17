import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'observer/app_bloc_observer.dart';
import 'router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/repositories/in_memory_auth_repository.dart';
import '../features/auth/domain/usecases/sign_in.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/domain/usecases/sign_up.dart';
import '../features/auth/presentation/bloc/auth_session_bloc.dart';
import '../features/home/data/repositories/in_memory_home_repository.dart';
import '../features/home/domain/usecases/get_home_dashboard.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import '../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../features/onboarding/domain/usecases/save_onboarding_draft.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';

/// Root application widget.
///
/// Feature-specific repositories and blocs will be registered here as the
/// corresponding features are implemented. Keeping this composition root in
/// one place prevents dependencies from leaking into presentation widgets.
class NutriVisionApp extends StatelessWidget {
  const NutriVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = InMemoryAuthRepository();
    final onboardingRepository = InMemoryOnboardingRepository();
    final homeRepository = InMemoryHomeRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthSessionBloc(
            repository: authRepository,
            signIn: SignIn(authRepository),
            signUp: SignUp(authRepository),
            signOut: SignOut(authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => OnboardingBloc(
            initialProfile: onboardingRepository.draft,
            saveDraft: SaveOnboardingDraft(onboardingRepository),
            complete: CompleteOnboarding(onboardingRepository),
          ),
        ),
        BlocProvider(
          create: (_) =>
              HomeBloc(GetHomeDashboard(homeRepository))
                ..add(const HomeDashboardRequested()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'NutriVision',
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

/// Shared access point for the app-level observer configuration.
///
/// The observer is installed from [main] so tests can replace it when needed.
final appBlocObserver = AppBlocObserver();
