import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_bottom_nav_bar.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_toast.dart';
import 'package:nutrivision_capstone_project/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/entities/auth_user.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_in.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_out.dart';
import 'package:nutrivision_capstone_project/features/auth/domain/usecases/sign_up.dart';
import 'package:nutrivision_capstone_project/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:nutrivision_capstone_project/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:nutrivision_capstone_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/in_memory_profile_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_user_profile.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/profile_screen.dart';

class _ControllableAuthRepository implements AuthRepository {
  AuthUser? _user = const AuthUser(
    id: 'maya@example.com',
    name: 'Maya',
    email: 'maya@example.com',
  );
  Completer<void>? signOutCompleter;
  int signOutCalls = 0;

  @override
  AuthUser? get currentUser => _user;

  @override
  bool get hasSeenWelcome => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> markWelcomeSeen() async {}

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async => _user!;

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async => _user!;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    if (signOutCompleter != null) {
      await signOutCompleter!.future;
    }
    _user = null;
  }
}

class _TestEnv {
  _TestEnv({AuthRepository? authRepository})
    : authRepository = authRepository ?? InMemoryAuthRepository(),
      homeBloc = HomeBloc(GetHomeDashboard(InMemoryHomeRepository())),
      profileBloc = ProfileBloc(GetUserProfile(InMemoryProfileRepository())) {
    authBloc = AuthSessionBloc(
      repository: this.authRepository,
      signIn: SignIn(this.authRepository),
      signUp: SignUp(this.authRepository),
      signOut: SignOut(this.authRepository),
    );
  }

  final AuthRepository authRepository;
  late final AuthSessionBloc authBloc;
  final HomeBloc homeBloc;
  final ProfileBloc profileBloc;

  Future<void> dispose() async {
    AppToast.dismiss();
    await authBloc.close();
    await homeBloc.close();
    await profileBloc.close();
  }

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const Scaffold(body: Text('Home Route')),
        ),
        GoRoute(
          path: '/sign-in',
          name: 'sign-in',
          builder: (context, state) =>
              const Scaffold(body: Text('Sign In Route')),
        ),
        GoRoute(
          path: '/profile/goals-dietary',
          name: 'goals-dietary-preferences',
          builder: (context, state) =>
              const Scaffold(body: Text('Goals & Dietary Preferences Route')),
        ),
        GoRoute(
          path: '/profile/notifications',
          name: 'notifications-settings',
          builder: (context, state) =>
              const Scaffold(body: Text('Notifications Settings Route')),
        ),
        GoRoute(
          path: '/profile/privacy-data',
          name: 'privacy-data-management',
          builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: const Text('Privacy & Data Management Route'),
          ),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: homeBloc),
        BlocProvider.value(value: profileBloc),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders Profile & settings UI with default Maya profile', (
    tester,
  ) async {
    final env = _TestEnv();
    addTearDown(env.dispose);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(env.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('NutriVision'), findsOneWidget);
    expect(find.text('Profile & settings.'), findsOneWidget);
    expect(find.text('Your nutrition, your way.'), findsOneWidget);
    expect(find.text('Maya'), findsOneWidget);
    expect(find.text('Your NutriVision profile'), findsOneWidget);
    expect(find.text('Account settings'), findsOneWidget);
    expect(find.text('Goals & Dietary Preferences'), findsOneWidget);
    expect(find.text('Notifications Settings'), findsOneWidget);
    expect(find.text('Privacy & Data Management'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('Sign out of your account'), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('displays signed-in user name and adapts across screen sizes', (
    tester,
  ) async {
    final env = _TestEnv();
    addTearDown(env.dispose);

    env.authBloc.add(
      const SignUpRequested(
        name: 'Nancy',
        email: 'nancy@example.com',
        password: 'Password1',
      ),
    );
    await env.authBloc.stream.firstWhere(
      (state) => state.status == AuthSessionStatus.signedIn,
    );

    for (final size in const [Size(320, 568), Size(390, 844), Size(600, 900)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Nancy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets(
    'navigates to goals-dietary-preferences from Goals & Dietary Preferences',
    (tester) async {
      final env = _TestEnv();
      addTearDown(env.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Goals & Dietary Preferences'));
      await tester.pumpAndSettle();

      expect(find.text('Goals & Dietary Preferences Route'), findsOneWidget);
    },
  );

  testWidgets(
    'navigates to notifications-settings and privacy-data-management',
    (tester) async {
      final env = _TestEnv();
      addTearDown(env.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Privacy & Data Management'));
      await tester.pumpAndSettle();
      expect(find.text('Privacy & Data Management Route'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Notifications Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Notifications Settings Route'), findsOneWidget);
    },
  );

  testWidgets(
    'shows confirmation dialog before signing out, preserves saved data, and navigates to sign-in',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile.goals_dietary_preferences.v1': '{"goal":"Eat Healthier"}',
      });
      final env = _TestEnv();
      addTearDown(env.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      env.authBloc.add(
        const SignUpRequested(
          name: 'Maya',
          email: 'maya@example.com',
          password: 'Password1',
        ),
      );
      await env.authBloc.stream.firstWhere(
        (state) => state.status == AuthSessionStatus.signedIn,
      );

      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      // Open dialog and close via X button.
      await tester.ensureVisible(find.text('Sign out'));
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(find.text('Sign out?'), findsOneWidget);
      expect(
        find.text(
          "You'll be signed out of your NutriVision account. Your data and preferences will be saved.",
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('sign_out_dialog_close')));
      await tester.pumpAndSettle();
      expect(find.text('Profile & settings.'), findsOneWidget);
      expect(env.authBloc.state.status, AuthSessionStatus.signedIn);

      // Reopen dialog and dismiss via Cancel button.
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('sign_out_cancel_button')));
      await tester.pumpAndSettle();
      expect(find.text('Profile & settings.'), findsOneWidget);
      expect(env.authBloc.state.status, AuthSessionStatus.signedIn);

      // Reopen dialog and confirm Sign out.
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('sign_out_confirm_button')));
      await tester.pumpAndSettle();

      expect(env.authBloc.state.status, AuthSessionStatus.signedOut);
      expect(find.text('Sign In Route'), findsOneWidget);

      // Saved user data remains preserved in SharedPreferences.
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString('profile.goals_dietary_preferences.v1'),
        '{"goal":"Eat Healthier"}',
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'sign-out dialog shows loading state and prevents repeated taps during logout',
    (tester) async {
      final controllableRepo = _ControllableAuthRepository()
        ..signOutCompleter = Completer<void>();
      final env = _TestEnv(authRepository: controllableRepo);
      addTearDown(env.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      env.authBloc.add(
        const SignInRequested(email: 'maya@example.com', password: 'Password1'),
      );
      await env.authBloc.stream.firstWhere(
        (state) => state.status == AuthSessionStatus.signedIn,
      );

      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Sign out'));
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      // Tap Sign out twice while completer is pending.
      final confirmButton = find.byKey(
        const ValueKey('sign_out_confirm_button'),
      );
      await tester.tap(confirmButton);
      await tester.pump();
      await tester.tap(confirmButton, warnIfMissed: false);
      await tester.pump();

      expect(controllableRepo.signOutCalls, 1);
      expect(tester.widget<FilledButton>(confirmButton).onPressed, isNull);

      controllableRepo.signOutCompleter!.complete();
      await tester.pumpAndSettle();

      expect(find.text('Sign In Route'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'bottom navigation navigates to Home and shows toast for pending tabs',
    (tester) async {
      final env = _TestEnv();
      addTearDown(env.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(env.buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Meal Plan'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Meal Plan will be connected soon.'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Route'), findsOneWidget);
      expect(env.homeBloc.state.selectedTab, 0);
    },
  );
}
