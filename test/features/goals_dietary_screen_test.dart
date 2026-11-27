import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_bottom_nav_bar.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_toast.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/entities/auth_user.dart';
import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_in.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_out.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_up.dart';
import 'package:nutrivision_capstone_project/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:nutrivision_capstone_project/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:nutrivision_capstone_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:nutrivision_capstone_project/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutrivision_capstone_project/features/onboarding/domain/usecases/save_onboarding_draft.dart';
import 'package:nutrivision_capstone_project/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/data/datasources/goals_dietary_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_goals_dietary_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/save_goals_dietary_preferences.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/goals_dietary_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/goals_dietary_screen.dart';

class _SignedInAuthRepository extends InMemoryAuthRepository {
  @override
  AuthUser? get currentUser => const AuthUser(
    id: 'test-user',
    name: 'Test User',
    email: 'test@example.com',
  );
}

class _TestHarness {
  _TestHarness() {
    final authRepository = _SignedInAuthRepository();
    authBloc = AuthSessionBloc(
      repository: authRepository,
      signIn: SignIn(authRepository),
      signUp: SignUp(authRepository),
      signOut: SignOut(authRepository),
    );
    final onboardingRepo = InMemoryOnboardingRepository();
    onboardingBloc = OnboardingBloc(
      initialProfile: onboardingRepo.draft,
      saveDraft: SaveOnboardingDraft(onboardingRepo),
      complete: CompleteOnboarding(
        onboardingRepo,
        getPreferences: GetGoalsDietaryPreferences(
          LocalGoalsDietaryRepository(),
        ),
        savePreferences: SaveGoalsDietaryPreferences(
          LocalGoalsDietaryRepository(),
        ),
      ),
    );
    homeBloc = HomeBloc(GetHomeDashboard(InMemoryHomeRepository()));
    repository = LocalGoalsDietaryRepository(
      localDataSource: SharedPrefsGoalsDietaryLocalDataSource(),
    );
    bloc = GoalsDietaryBloc(
      getPreferences: GetGoalsDietaryPreferences(repository),
      savePreferences: SaveGoalsDietaryPreferences(repository),
    );
  }

  late final OnboardingBloc onboardingBloc;
  late final AuthSessionBloc authBloc;
  late final HomeBloc homeBloc;
  late final LocalGoalsDietaryRepository repository;
  late final GoalsDietaryBloc bloc;

  Future<void> dispose() async {
    AppToast.dismiss();
    await bloc.close();
    await authBloc.close();
    await onboardingBloc.close();
    await homeBloc.close();
  }

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.pushNamed('goals-dietary-preferences'),
                child: const Text('Open Goals & Dietary'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/goals-dietary',
          name: 'goals-dietary-preferences',
          builder: (context, state) => const GoalsDietaryScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const Scaffold(body: Text('Home Route')),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: onboardingBloc),
        BlocProvider.value(value: homeBloc),
        BlocProvider.value(value: bloc),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'renders all sections with five initial zero daily targets and adapts across viewports',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Goals & Dietary'));
      await tester.pumpAndSettle();

      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Goals & dietary\npreferences.'), findsOneWidget);
      expect(find.text('Shape your targets and food choices.'), findsOneWidget);
      expect(find.text('Your goal'), findsOneWidget);
      expect(find.text('Eat Healthier'), findsOneWidget);
      expect(find.text('Allergies'), findsOneWidget);
      expect(find.text('No allergies selected'), findsOneWidget);
      expect(find.text('Edit allergies'), findsOneWidget);
      expect(find.text('Your daily targets'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Carbohydrates'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
      expect(find.text('Water'), findsOneWidget);
      // All five daily targets MUST initialize to zero ('0').
      expect(find.text('0'), findsNWidgets(5));
      expect(find.text('Dietary pattern'), findsOneWidget);
      expect(find.text('No preference'), findsOneWidget);
      expect(find.text('Food preferences'), findsOneWidget);
      expect(find.text('No excluded ingredients'), findsOneWidget);
      expect(find.text('No liked foods selected'), findsOneWidget);
      expect(find.text('Save changes'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(
        find.text('Current saved settings · Save only after editing'),
        findsOneWidget,
      );
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(tester.takeException(), isNull);

      for (final size in const [Size(320, 568), Size(600, 900)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'edits targets, goal, dietary pattern, allergies, food preferences, and persists on reopen',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Goals & Dietary'));
      await tester.pumpAndSettle();

      // Edit goal -> Build Muscle.
      await tester.tap(find.byKey(const ValueKey('edit_goal_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Build Muscle'));
      await tester.pumpAndSettle();
      expect(find.text('Build Muscle'), findsOneWidget);

      // Edit Calories -> reject negative, then set 1850.
      await tester.tap(find.byKey(const ValueKey('target_calories_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('target_numeric_input')),
        '-100',
      );
      await tester.tap(find.byKey(const ValueKey('apply_target_button')));
      await tester.pumpAndSettle();
      expect(find.text('Value cannot be negative.'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('target_numeric_input')),
        '1850',
      );
      await tester.tap(find.byKey(const ValueKey('apply_target_button')));
      await tester.pumpAndSettle();
      expect(find.text('1,850'), findsOneWidget);

      // Change Dietary pattern -> Vegan.
      await tester.tap(find.byKey(const ValueKey('dietary_pattern_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vegan').last);
      await tester.pumpAndSettle();
      expect(find.text('Vegan'), findsOneWidget);

      // Edit Allergies -> add Soy.
      await tester.tap(find.byKey(const ValueKey('edit_allergies_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Soy'));
      await tester.tap(find.byKey(const ValueKey('apply_chips_button')));
      await tester.pumpAndSettle();
      expect(find.text('Soy'), findsOneWidget);

      // Edit Excluded ingredients -> add Added sugar.
      await tester.tap(find.byKey(const ValueKey('edit_excluded_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Added sugar'));
      await tester.tap(find.byKey(const ValueKey('apply_chips_button')));
      await tester.pumpAndSettle();
      expect(find.text('Added sugar'), findsOneWidget);

      // Save changes.
      await tester.tap(find.byKey(const ValueKey('save_goals_button')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Goals & dietary preferences saved.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate back and reopen to confirm persistence.
      await tester.tap(find.text('Profile & Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Goals & Dietary'));
      await tester.pumpAndSettle();

      expect(find.text('Build Muscle'), findsOneWidget);
      expect(find.text('1,850'), findsOneWidget);
      expect(find.text('Vegan'), findsOneWidget);
      expect(find.text('Soy'), findsOneWidget);
      expect(find.text('Added sugar'), findsOneWidget);
    },
  );

  testWidgets(
    'Cancel discards unsaved draft changes and bottom nav navigates home',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Goals & Dietary'));
      await tester.pumpAndSettle();

      // Make draft edit.
      await tester.tap(find.byKey(const ValueKey('edit_goal_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lose Weight'));
      await tester.pumpAndSettle();
      expect(find.text('Lose Weight'), findsOneWidget);

      // Press Cancel -> reverts to Eat Healthier.
      await tester.tap(find.byKey(const ValueKey('cancel_goals_button')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Eat Healthier'), findsOneWidget);
      expect(find.text('Unsaved changes discarded.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Bottom navigation to Home.
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Route'), findsOneWidget);
      expect(harness.homeBloc.state.selectedTab, 0);
    },
  );
}
