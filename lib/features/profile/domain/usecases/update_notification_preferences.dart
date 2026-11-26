import '../entities/notification_preferences.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Persists notification reminder schedules and sound preferences.
class UpdateNotificationPreferences {
  const UpdateNotificationPreferences(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call(NotificationPreferences preferences) {
    return _repository.updateNotifications(preferences);
  }
}
