import '../entities/notification_settings.dart';
import '../repositories/notification_settings_repository.dart';

/// Loads previously saved notification settings, if any.
class GetNotificationSettings {
  const GetNotificationSettings(this._repository);

  final NotificationSettingsRepository _repository;

  Future<NotificationSettings?> call() => _repository.loadSettings();
}
