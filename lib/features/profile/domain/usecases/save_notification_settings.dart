import '../entities/notification_settings.dart';
import '../repositories/notification_settings_repository.dart';

/// Validation exception thrown when notification settings fail business rules.
class NotificationSettingsValidationException implements Exception {
  const NotificationSettingsValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Validates and persists notification settings drafts.
class SaveNotificationSettings {
  const SaveNotificationSettings(this._repository);

  final NotificationSettingsRepository _repository;

  Future<void> call(NotificationSettings settings) async {
    if (!settings.hasAnySelection) {
      throw const NotificationSettingsValidationException(
        'Choose at least one reminder or sound preference before saving.',
      );
    }

    final quietHoursError = settings.quietHours?.validationError;
    if (quietHoursError != null) {
      throw NotificationSettingsValidationException(quietHoursError);
    }

    await _repository.saveSettings(settings);
  }
}
