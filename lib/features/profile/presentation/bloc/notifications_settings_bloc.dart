import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_settings.dart';
import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/notification_permission_usecases.dart';
import '../../domain/usecases/save_notification_settings.dart';

enum NotificationsSettingsStatus {
  initial,
  loading,
  ready,
  saving,
  saved,
  failure,
}

class NotificationsSettingsState {
  const NotificationsSettingsState({
    this.status = NotificationsSettingsStatus.initial,
    this.permissionStatus = NotificationPermissionStatus.notChecked,
    this.savedSettings,
    this.draftSettings = const NotificationSettings(),
    this.message,
    this.isCheckingPermission = false,
  });

  final NotificationsSettingsStatus status;
  final NotificationPermissionStatus permissionStatus;
  final NotificationSettings? savedSettings;
  final NotificationSettings draftSettings;
  final String? message;
  final bool isCheckingPermission;

  bool get hasSavedSettings => savedSettings != null;

  bool get hasUnsavedChanges {
    final saved = savedSettings;
    if (saved == null) return draftSettings.hasAnySelection;
    return draftSettings != saved;
  }

  NotificationsSettingsState copyWith({
    NotificationsSettingsStatus? status,
    NotificationPermissionStatus? permissionStatus,
    NotificationSettings? savedSettings,
    bool clearSavedSettings = false,
    NotificationSettings? draftSettings,
    String? message,
    bool clearMessage = false,
    bool? isCheckingPermission,
  }) {
    return NotificationsSettingsState(
      status: status ?? this.status,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      savedSettings: clearSavedSettings
          ? null
          : (savedSettings ?? this.savedSettings),
      draftSettings: draftSettings ?? this.draftSettings,
      message: clearMessage ? null : message,
      isCheckingPermission: isCheckingPermission ?? this.isCheckingPermission,
    );
  }
}

abstract class NotificationsSettingsEvent {
  const NotificationsSettingsEvent();
}

class NotificationsSettingsStarted extends NotificationsSettingsEvent {
  const NotificationsSettingsStarted();
}

class NotificationPermissionChecked extends NotificationsSettingsEvent {
  const NotificationPermissionChecked();
}

class NotificationPermissionRequested extends NotificationsSettingsEvent {
  const NotificationPermissionRequested();
}

class NotificationAppSettingsOpened extends NotificationsSettingsEvent {
  const NotificationAppSettingsOpened();
}

class MealScheduleChanged extends NotificationsSettingsEvent {
  const MealScheduleChanged(this.schedule);

  final MealReminderSchedule? schedule;
}

class WaterScheduleChanged extends NotificationsSettingsEvent {
  const WaterScheduleChanged(this.schedule);

  final WaterReminderSchedule? schedule;
}

class ReminderSoundChanged extends NotificationsSettingsEvent {
  const ReminderSoundChanged(this.sound);

  final ReminderSoundPreference? sound;
}

class QuietHoursChanged extends NotificationsSettingsEvent {
  const QuietHoursChanged(this.range);

  final QuietHoursRange? range;
}

class NotificationsSettingsSaved extends NotificationsSettingsEvent {
  const NotificationsSettingsSaved();
}

class NotificationsSettingsBloc
    extends Bloc<NotificationsSettingsEvent, NotificationsSettingsState> {
  NotificationsSettingsBloc({
    required GetNotificationSettings getSettings,
    required SaveNotificationSettings saveSettings,
    required CheckNotificationPermission checkPermission,
    required RequestNotificationPermission requestPermission,
    required OpenNotificationAppSettings openAppSettings,
  }) : _getSettings = getSettings,
       _saveSettings = saveSettings,
       _checkPermission = checkPermission,
       _requestPermission = requestPermission,
       _openAppSettings = openAppSettings,
       super(const NotificationsSettingsState()) {
    on<NotificationsSettingsStarted>(_onStarted);
    on<NotificationPermissionChecked>(_onPermissionChecked);
    on<NotificationPermissionRequested>(_onPermissionRequested);
    on<NotificationAppSettingsOpened>(_onAppSettingsOpened);
    on<MealScheduleChanged>(_onMealScheduleChanged);
    on<WaterScheduleChanged>(_onWaterScheduleChanged);
    on<ReminderSoundChanged>(_onReminderSoundChanged);
    on<QuietHoursChanged>(_onQuietHoursChanged);
    on<NotificationsSettingsSaved>(_onSaved);
  }

  final GetNotificationSettings _getSettings;
  final SaveNotificationSettings _saveSettings;
  final CheckNotificationPermission _checkPermission;
  final RequestNotificationPermission _requestPermission;
  final OpenNotificationAppSettings _openAppSettings;

  Future<void> _onStarted(
    NotificationsSettingsStarted event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.loading,
        clearMessage: true,
      ),
    );
    try {
      final saved = await _getSettings();
      final permission = await _checkPermission();
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.ready,
          permissionStatus: permission,
          savedSettings: saved,
          clearSavedSettings: saved == null,
          draftSettings: saved ?? const NotificationSettings(),
          clearMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.failure,
          message: 'Unable to load notification preferences.',
        ),
      );
    }
  }

  Future<void> _onPermissionChecked(
    NotificationPermissionChecked event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    emit(state.copyWith(isCheckingPermission: true, clearMessage: true));
    final permission = await _checkPermission();
    emit(
      state.copyWith(
        permissionStatus: permission,
        isCheckingPermission: false,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onPermissionRequested(
    NotificationPermissionRequested event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    emit(state.copyWith(isCheckingPermission: true, clearMessage: true));
    final permission = await _requestPermission();
    final feedback = switch (permission) {
      NotificationPermissionStatus.granted => 'Push notifications enabled.',
      NotificationPermissionStatus.permanentlyDenied =>
        'Notifications are blocked. Open device settings to enable them.',
      _ => null,
    };
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.ready,
        permissionStatus: permission,
        isCheckingPermission: false,
        message: feedback,
      ),
    );
  }

  Future<void> _onAppSettingsOpened(
    NotificationAppSettingsOpened event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    final opened = await _openAppSettings();
    if (!opened) {
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.failure,
          message: 'Could not open device notification settings.',
        ),
      );
    }
  }

  void _onMealScheduleChanged(
    MealScheduleChanged event,
    Emitter<NotificationsSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.ready,
        draftSettings: state.draftSettings.copyWith(
          mealSchedule: event.schedule,
          clearMealSchedule: event.schedule == null,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onWaterScheduleChanged(
    WaterScheduleChanged event,
    Emitter<NotificationsSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.ready,
        draftSettings: state.draftSettings.copyWith(
          waterSchedule: event.schedule,
          clearWaterSchedule: event.schedule == null,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onReminderSoundChanged(
    ReminderSoundChanged event,
    Emitter<NotificationsSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.ready,
        draftSettings: state.draftSettings.copyWith(
          soundPreference: event.sound,
          clearSoundPreference: event.sound == null,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onQuietHoursChanged(
    QuietHoursChanged event,
    Emitter<NotificationsSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.ready,
        draftSettings: state.draftSettings.copyWith(
          quietHours: event.range,
          clearQuietHours: event.range == null,
        ),
        clearMessage: true,
      ),
    );
  }

  Future<void> _onSaved(
    NotificationsSettingsSaved event,
    Emitter<NotificationsSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationsSettingsStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      await _saveSettings(state.draftSettings);
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.saved,
          savedSettings: state.draftSettings,
          message: 'Notification preferences saved.',
        ),
      );
    } on NotificationSettingsValidationException catch (error) {
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.failure,
          message: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NotificationsSettingsStatus.failure,
          message: 'Unable to save notification preferences.',
        ),
      );
    }
  }
}
