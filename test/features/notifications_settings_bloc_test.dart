import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/features/profile/data/datasources/notification_permission_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/datasources/notification_settings_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/models/notification_settings_model.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_notification_settings_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/get_notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/notification_permission_usecases.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/save_notification_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/notifications_settings_bloc.dart';

class _FakePermissionDataSource implements NotificationPermissionDataSource {
  _FakePermissionDataSource({
    this.initialStatus = NotificationPermissionStatus.denied,
    this.requestResult = NotificationPermissionStatus.granted,
  });

  NotificationPermissionStatus initialStatus;
  NotificationPermissionStatus requestResult;

  int checkCalls = 0;
  int requestCalls = 0;
  int openSettingsCalls = 0;

  @override
  Future<NotificationPermissionStatus> checkStatus() async {
    checkCalls++;
    return initialStatus;
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    requestCalls++;
    initialStatus = requestResult;
    return requestResult;
  }

  @override
  Future<bool> openSystemSettings() async {
    openSettingsCalls++;
    return true;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('QuietHoursRange validation', () {
    test('allows overnight range such as 10:00 PM to 7:00 AM', () {
      const range = QuietHoursRange(
        start: TimeOfDayValue(hour: 22, minute: 0),
        end: TimeOfDayValue(hour: 7, minute: 0),
      );

      expect(range.isValid, isTrue);
      expect(range.validationError, isNull);
      expect(range.durationMinutes, 9 * 60);
      expect(range.formatRange(), '10:00 PM – 7:00 AM');
    });

    test('rejects equal start and end times', () {
      const range = QuietHoursRange(
        start: TimeOfDayValue(hour: 21, minute: 30),
        end: TimeOfDayValue(hour: 21, minute: 30),
      );

      expect(range.isValid, isFalse);
      expect(range.validationError, 'Start and end times cannot be the same.');
    });

    test('rejects ranges shorter than 30 minutes', () {
      const range = QuietHoursRange(
        start: TimeOfDayValue(hour: 22, minute: 0),
        end: TimeOfDayValue(hour: 22, minute: 15),
      );

      expect(range.isValid, isFalse);
      expect(
        range.validationError,
        'Quiet hours must span at least 30 minutes.',
      );
    });
  });

  group('NotificationSettingsModel & Repository', () {
    test(
      'persists and restores settings round-trip via SharedPreferences',
      () async {
        final repository = LocalNotificationSettingsRepository(
          localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
          permissionDataSource: _FakePermissionDataSource(),
        );

        const original = NotificationSettings(
          mealSchedule: MealReminderSchedule.threeMeals,
          waterSchedule: WaterReminderSchedule.everyTwoHours,
          soundPreference: ReminderSoundPreference.vibrateOnly,
          quietHours: QuietHoursRange(
            start: TimeOfDayValue(hour: 22, minute: 0),
            end: TimeOfDayValue(hour: 7, minute: 0),
          ),
        );

        expect(await repository.loadSettings(), isNull);
        await repository.saveSettings(original);

        // Re-create repository to simulate reopening the app/screen.
        final freshRepository = LocalNotificationSettingsRepository(
          localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
          permissionDataSource: _FakePermissionDataSource(),
        );
        final loaded = await freshRepository.loadSettings();

        expect(loaded, original);
      },
    );

    test('tryDecode returns null for corrupt JSON', () {
      expect(NotificationSettingsModel.tryDecode('{bad json'), isNull);
    });
  });

  group('SaveNotificationSettings use case', () {
    test('rejects empty settings draft', () async {
      final repository = LocalNotificationSettingsRepository(
        localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
        permissionDataSource: _FakePermissionDataSource(),
      );
      final useCase = SaveNotificationSettings(repository);

      expect(
        () => useCase(const NotificationSettings()),
        throwsA(isA<NotificationSettingsValidationException>()),
      );
    });

    test('rejects invalid quiet hours', () async {
      final repository = LocalNotificationSettingsRepository(
        localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
        permissionDataSource: _FakePermissionDataSource(),
      );
      final useCase = SaveNotificationSettings(repository);

      expect(
        () => useCase(
          const NotificationSettings(
            quietHours: QuietHoursRange(
              start: TimeOfDayValue(hour: 9, minute: 0),
              end: TimeOfDayValue(hour: 9, minute: 0),
            ),
          ),
        ),
        throwsA(isA<NotificationSettingsValidationException>()),
      );
    });
  });

  group('NotificationsSettingsBloc', () {
    test(
      'checks permission without requesting on start, keeps drafts separate until saved',
      () async {
        final permissionDataSource = _FakePermissionDataSource(
          initialStatus: NotificationPermissionStatus.denied,
          requestResult: NotificationPermissionStatus.granted,
        );
        final repository = LocalNotificationSettingsRepository(
          localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
          permissionDataSource: permissionDataSource,
        );

        final bloc = NotificationsSettingsBloc(
          getSettings: GetNotificationSettings(repository),
          saveSettings: SaveNotificationSettings(repository),
          checkPermission: CheckNotificationPermission(repository),
          requestPermission: RequestNotificationPermission(repository),
          openAppSettings: OpenNotificationAppSettings(repository),
        );
        addTearDown(bloc.close);

        final ready = bloc.stream.firstWhere(
          (s) => s.status == NotificationsSettingsStatus.ready,
        );
        bloc.add(const NotificationsSettingsStarted());
        final initialState = await ready;

        expect(
          initialState.permissionStatus,
          NotificationPermissionStatus.denied,
        );
        expect(permissionDataSource.checkCalls, 1);
        expect(permissionDataSource.requestCalls, 0);
        expect(initialState.hasSavedSettings, isFalse);

        // Update drafts without saving.
        bloc.add(const MealScheduleChanged(MealReminderSchedule.threeMeals));
        bloc.add(
          const WaterScheduleChanged(WaterReminderSchedule.everyTwoHours),
        );
        bloc.add(
          const ReminderSoundChanged(ReminderSoundPreference.systemDefault),
        );
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state.hasSavedSettings, isFalse);
        expect(bloc.state.hasUnsavedChanges, isTrue);
        expect(await repository.loadSettings(), isNull);

        // Save changes persists to storage.
        final saved = bloc.stream.firstWhere(
          (s) => s.status == NotificationsSettingsStatus.saved,
        );
        bloc.add(const NotificationsSettingsSaved());
        final savedState = await saved;

        expect(savedState.hasSavedSettings, isTrue);
        expect(savedState.hasUnsavedChanges, isFalse);
        expect(
          (await repository.loadSettings())?.mealSchedule,
          MealReminderSchedule.threeMeals,
        );
      },
    );

    test(
      'handles permission request and permanentlyDenied app settings action',
      () async {
        final permissionDataSource = _FakePermissionDataSource(
          initialStatus: NotificationPermissionStatus.denied,
          requestResult: NotificationPermissionStatus.permanentlyDenied,
        );
        final repository = LocalNotificationSettingsRepository(
          localDataSource: SharedPrefsNotificationSettingsLocalDataSource(),
          permissionDataSource: permissionDataSource,
        );

        final bloc = NotificationsSettingsBloc(
          getSettings: GetNotificationSettings(repository),
          saveSettings: SaveNotificationSettings(repository),
          checkPermission: CheckNotificationPermission(repository),
          requestPermission: RequestNotificationPermission(repository),
          openAppSettings: OpenNotificationAppSettings(repository),
        );
        addTearDown(bloc.close);

        bloc.add(const NotificationsSettingsStarted());
        await bloc.stream.firstWhere(
          (s) => s.status == NotificationsSettingsStatus.ready,
        );

        bloc.add(const NotificationPermissionRequested());
        final afterRequest = await bloc.stream.firstWhere(
          (s) =>
              s.permissionStatus ==
              NotificationPermissionStatus.permanentlyDenied,
        );
        expect(afterRequest.message, contains('blocked'));
        expect(permissionDataSource.requestCalls, 1);

        bloc.add(const NotificationAppSettingsOpened());
        await Future<void>.delayed(Duration.zero);
        expect(permissionDataSource.openSettingsCalls, 1);
      },
    );
  });
}
