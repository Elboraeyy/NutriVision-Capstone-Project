import '../entities/notification_settings.dart';
import '../repositories/notification_settings_repository.dart';

/// Checks the current OS notification permission status without prompting.
class CheckNotificationPermission {
  const CheckNotificationPermission(this._repository);

  final NotificationSettingsRepository _repository;

  Future<NotificationPermissionStatus> call() =>
      _repository.checkPermissionStatus();
}

/// Requests OS notification permission following an explicit user action.
class RequestNotificationPermission {
  const RequestNotificationPermission(this._repository);

  final NotificationSettingsRepository _repository;

  Future<NotificationPermissionStatus> call() =>
      _repository.requestPermission();
}

/// Opens the system app settings page so the user can enable notifications.
class OpenNotificationAppSettings {
  const OpenNotificationAppSettings(this._repository);

  final NotificationSettingsRepository _repository;

  Future<bool> call() => _repository.openAppNotificationSettings();
}
