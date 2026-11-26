import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/core/theme/app_theme.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_bottom_nav_bar.dart';
import 'package:nutrivision_capstone_project/core/widgets/app_toast.dart';
import 'package:nutrivision_capstone_project/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:nutrivision_capstone_project/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:nutrivision_capstone_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/data/datasources/privacy_data_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_privacy_data_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/privacy_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/repositories/privacy_data_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/privacy_data_usecases.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/privacy_data_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/privacy_data_screen.dart';

class _ConfigurablePrivacyRepository implements PrivacyDataRepository {
  PrivacySettings? _settings;
  bool allowDeleteSuccess = false;

  @override
  Future<PrivacySettings?> getPrivacySettings() async => _settings;

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    _settings = settings;
  }

  @override
  Future<void> requestDataExport() async {
    throw const PrivacyBackendUnavailableException(
      'Data export requires a connected backend service and is not available yet.',
    );
  }

  @override
  Future<void> deleteAccount() async {
    if (!allowDeleteSuccess) {
      throw const PrivacyBackendUnavailableException(
        'Account deletion requires a connected backend service and cannot be completed offline.',
      );
    }
  }
}

class _TestHarness {
  _TestHarness({PrivacyDataRepository? repository})
    : homeBloc = HomeBloc(GetHomeDashboard(InMemoryHomeRepository())),
      repository =
          repository ??
          LocalPrivacyDataRepository(
            localDataSource: SharedPrefsPrivacyDataLocalDataSource(),
          ) {
    bloc = PrivacyDataBloc(
      getPrivacySettings: GetPrivacySettings(this.repository),
      savePrivacySettings: SavePrivacySettings(this.repository),
      requestDataExport: RequestAccountDataExport(this.repository),
      deleteUserAccount: DeleteUserAccount(this.repository),
    );
  }

  final HomeBloc homeBloc;
  final PrivacyDataRepository repository;
  late final PrivacyDataBloc bloc;

  Future<void> dispose() async {
    AppToast.dismiss();
    await bloc.close();
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
                onPressed: () => context.pushNamed('privacy-data-management'),
                child: const Text('Open Privacy & Data'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/privacy-data',
          name: 'privacy-data-management',
          builder: (context, state) => const PrivacyDataScreen(),
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
      ],
    );

    return MultiBlocProvider(
      providers: [
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
    'renders all sections accurately and adapts across narrow, normal, and wide viewports',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Privacy & Data'));
      await tester.pumpAndSettle();

      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Privacy & data\nmanagement.'), findsOneWidget);
      expect(
        find.text('Understand your data and your options.'),
        findsOneWidget,
      );
      expect(find.text('View your data'), findsOneWidget);
      expect(find.text('Open food diary'), findsOneWidget);
      expect(find.text('Privacy & AI data'), findsOneWidget);
      expect(find.text('Allow meal photo processing'), findsOneWidget);
      expect(find.text('How photos are used'), findsOneWidget);
      expect(find.text('Review AI estimates'), findsOneWidget);
      expect(find.text('Manage account data'), findsOneWidget);
      expect(find.text('Request data export'), findsOneWidget);
      expect(find.text('Delete account & data'), findsOneWidget);
      expect(find.text('Confirm deletion'), findsOneWidget);
      expect(
        find.text('I understand this is permanent and irreversible'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
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
    'persists photo processing toggle across reopens and shows feedback for pending food diary & export',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Privacy & Data'));
      await tester.pumpAndSettle();

      // Open food diary -> pending route toast.
      await tester.tap(find.byKey(const ValueKey('open_food_diary_row')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Food diary will be connected soon.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Toggle meal photo processing on.
      final switchFinder = find.byKey(
        const ValueKey('meal_photo_processing_switch'),
      );
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
      await tester.tap(switchFinder);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
      expect(
        find.text('Photo processing permission preference saved.'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Request data export -> unavailable backend warning toast.
      await tester.tap(find.byKey(const ValueKey('request_data_export_row')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text(
          'Data export requires a connected backend service and is not available yet.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate back to Profile and reopen -> toggle stays true.
      await tester.tap(find.text('Profile & Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Open Privacy & Data'), findsOneWidget);

      await tester.tap(find.text('Open Privacy & Data'));
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    },
  );

  testWidgets(
    'deletion requires checkbox confirmation, Cancel resets it, and Delete handles error/success',
    (tester) async {
      final repo = _ConfigurablePrivacyRepository();
      final harness = _TestHarness(repository: repo);
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Privacy & Data'));
      await tester.pumpAndSettle();

      final deleteButtonFinder = find.byKey(
        const ValueKey('delete_account_button'),
      );
      expect(tester.widget<FilledButton>(deleteButtonFinder).onPressed, isNull);

      // Check confirmation -> Delete becomes enabled.
      await tester.tap(find.byKey(const ValueKey('confirm_deletion_checkbox')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(deleteButtonFinder).onPressed,
        isNotNull,
      );

      // Cancel unchecks confirmation and keeps Delete disabled.
      await tester.tap(find.byKey(const ValueKey('cancel_deletion_button')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<FilledButton>(deleteButtonFinder).onPressed, isNull);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Confirm again and tap Delete when backend is unavailable -> stays on screen & shows error.
      await tester.tap(find.byKey(const ValueKey('confirm_deletion_checkbox')));
      await tester.pumpAndSettle();
      await tester.tap(deleteButtonFinder);
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text(
          'Account deletion requires a connected backend service and cannot be completed offline.',
        ),
        findsOneWidget,
      );
      expect(find.text('Manage account data'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // When backend supports deletion and succeeds -> navigates to Sign In.
      repo.allowDeleteSuccess = true;
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Sign In Route'), findsOneWidget);
    },
  );

  testWidgets('bottom navigation navigates home', (tester) async {
    final harness = _TestHarness();
    addTearDown(harness.dispose);
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Privacy & Data'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Home Route'), findsOneWidget);
    expect(harness.homeBloc.state.selectedTab, 0);
  });
}
