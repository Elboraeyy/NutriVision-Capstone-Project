import '../entities/notification_settings.dart';

/// Contract for loading/saving notification preferences and checking OS
/// notification permissions.
abstract class NotificationSettingsRepository {
  Future<NotificationSettings?> loadSettings();

  Future<void> saveSettings(NotificationSettings settings);

  Future<NotificationPermissionStatus> checkPermissionStatus();

  Future<NotificationPermissionStatus> requestPermission();

  Future<bool> openAppNotificationSettings();
}
