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
import 'package:nutrivision_capstone_project/features/profile/data/datasources/notification_permission_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/datasources/notification_settings_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_notification_settings_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/notification_permission_usecases.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/save_notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/notifications_settings_bloc.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/screens/notifications_settings_screen.dart';

class _TestPermissionDataSource implements NotificationPermissionDataSource {
  _TestPermissionDataSource({
    this.status = NotificationPermissionStatus.notChecked,
    this.requestResult = NotificationPermissionStatus.granted,
  });

  NotificationPermissionStatus status;
  NotificationPermissionStatus requestResult;
  int openSettingsCalls = 0;

  @override
  Future<NotificationPermissionStatus> checkStatus() async => status;

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    status = requestResult;
    return requestResult;
  }

  @override
  Future<bool> openSystemSettings() async {
    openSettingsCalls++;
    return true;
  }
}

class _TestHarness {
  _TestHarness({
    NotificationPermissionStatus initialPermission =
        NotificationPermissionStatus.notChecked,
    NotificationPermissionStatus requestResult =
        NotificationPermissionStatus.granted,
  }) : permissionDataSource = _TestPermissionDataSource(
         status: initialPermission,
         requestResult: requestResult,
       ),
       homeBloc = HomeBloc(GetHomeDashboard(InMemoryHomeRepository())) {
    repository = LocalNotificationSettingsRepository(
      localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
      permissionDataSource: permissionDataSource,
    );
    bloc = NotificationsSettingsBloc(
      getSettings: GetNotificationSettings(repository),
      saveSettings: SaveNotificationSettings(repository),
      checkPermission: CheckNotificationPermission(repository),
      requestPermission: RequestNotificationPermission(repository),
      openAppSettings: OpenNotificationAppSettings(repository),
    );
  }

  final _TestPermissionDataSource permissionDataSource;
  late final LocalNotificationSettingsRepository repository;
  late final NotificationsSettingsBloc bloc;
  final HomeBloc homeBloc;

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
                onPressed: () => context.pushNamed('notifications-settings'),
                child: const Text('Open Notifications'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/notifications',
          name: 'notifications-settings',
          builder: (context, state) => const NotificationsSettingsScreen(),
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
    'renders all sections and adapts across narrow, normal, and wide viewports',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);

      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Notifications\nsettings.'), findsOneWidget);
      expect(find.text('A routine that works for you.'), findsOneWidget);
      expect(find.text('Device permission'), findsOneWidget);
      expect(find.text('Push notifications'), findsOneWidget);
      expect(find.text('Meal logging reminders'), findsOneWidget);
      expect(find.text('Water reminders'), findsNWidgets(2));
      expect(find.text('No saved schedule'), findsNWidgets(2));
      expect(find.text('Sound & quiet hours'), findsOneWidget);
      expect(find.text('Reminder sound'), findsOneWidget);
      expect(find.text('Quiet hours'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Draft only · No changes saved yet'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('Save changes'), findsOneWidget);
      expect(find.text('Draft only · No changes saved yet'), findsOneWidget);
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(tester.takeException(), isNull);

      for (final size in const [Size(320, 568), Size(600, 900)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.binding.setSurfaceSize(null);
    },
  );

  testWidgets(
    'dropdowns update drafts, Save changes persists, and reopening restores saved settings',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      // Use a tall surface so all content is visible without scrolling,
      // avoiding the multi-Scrollable ambiguity in scrollUntilVisible.
      await tester.binding.setSurfaceSize(const Size(390, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      // Select Meal reminders -> 3 meals daily.
      await tester.tap(find.byKey(const ValueKey('meal_reminders_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 meals daily').last);
      await tester.pumpAndSettle();

      // Select Water reminders -> Every 2 hrs.
      await tester.tap(find.byKey(const ValueKey('water_reminders_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Every 2 hrs').last);
      await tester.pumpAndSettle();

      // Select Reminder sound -> Vibrate only.
      await tester.tap(find.byKey(const ValueKey('reminder_sound_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vibrate only').last);
      await tester.pumpAndSettle();

      // Draft is NOT saved yet — with no prior saved settings the status label
      // is always 'Draft only · No changes saved yet'.
      expect(find.text('No saved schedule'), findsNWidgets(2));
      expect(find.text('Draft only · No changes saved yet'), findsOneWidget);

      // Save changes.
      await tester.ensureVisible(find.text('Save changes'));
      await tester.tap(find.text('Save changes'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Notification preferences saved.'), findsOneWidget);
      expect(find.text('Saved: 3 meals daily'), findsOneWidget);
      expect(find.text('Saved: Every 2 hrs'), findsOneWidget);
      expect(
        find.text('Saved · Preferences stored on this device'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Navigate back to Profile and reopen Notifications Settings.
      await tester.ensureVisible(find.text('Profile & Settings'));
      await tester.tap(find.text('Profile & Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Open Notifications'), findsOneWidget);

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Saved: 3 meals daily'), findsOneWidget);
      expect(find.text('Saved: Every 2 hrs'), findsOneWidget);
      expect(find.text('Vibrate only'), findsOneWidget);
    },
  );

  testWidgets(
    'handles permission request and permanentlyDenied open app settings',
    (tester) async {
      final harness = _TestHarness(
        initialPermission: NotificationPermissionStatus.denied,
        requestResult: NotificationPermissionStatus.permanentlyDenied,
      );
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Denied'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('push_notifications_dropdown')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Allow notifications').last);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Blocked'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('push_notifications_dropdown')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open app settings').last);
      await tester.pumpAndSettle();

      expect(harness.permissionDataSource.openSettingsCalls, 1);
    },
  );

  testWidgets(
    'configures quiet hours via dialog and navigates home via bottom nav',
    (tester) async {
      final harness = _TestHarness();
      addTearDown(harness.dispose);
      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(harness.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('quiet_hours_picker')),
      );
      await tester.tap(find.byKey(const ValueKey('quiet_hours_picker')));
      await tester.pumpAndSettle();

      expect(find.text('Start time'), findsOneWidget);
      expect(find.text('End time'), findsOneWidget);

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('10:00 PM – 7:00 AM'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Route'), findsOneWidget);
      expect(harness.homeBloc.state.selectedTab, 0);
    },
  );
}
